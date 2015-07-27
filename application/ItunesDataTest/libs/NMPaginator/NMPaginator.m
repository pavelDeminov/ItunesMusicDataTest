//
//  NMPaginator.m
//
//  Created by Nicolas Mondollot on 07/04/12.
//

#import "NMPaginator.h"

@interface NMPaginator() {
    NSInteger _deletedCount;
    BOOL _lastResponceContainsEmptyAnswer;
}

// protected properties
@property (assign, readwrite) NSInteger pageSize; 
@property (assign, readwrite) NSInteger page; 
@property (assign, readwrite) NSInteger total;
@property (nonatomic, strong, readwrite) NSMutableArray *results;
@property (assign, readwrite) RequestStatus requestStatus;

@end

@implementation NMPaginator
@synthesize delegate;
@synthesize page=_page, total=_total, results=_results, requestStatus=_requestStatus, pageSize=_pageSize;

- (id)initWithPageSize:(NSInteger)pageSize delegate:(id<NMPaginatorDelegate>)paginatorDelegate
{
    if(self = [super init])
    {
        [self setDefaultValues];
        self.pageSize = pageSize;
        self.delegate = paginatorDelegate;
    }
    
    return self;
}

- (void)setDefaultValues
{
    self.total = 0;
    self.page = 0;
    _deletedCount = 0;
    self.results = [NSMutableArray array];
    self.requestStatus = RequestStatusNone;
    _lastResponceContainsEmptyAnswer = NO;
}

- (void)reset
{
    [self setDefaultValues];
    _someDataFetched = NO;
    // send message to delegate
    if([self.delegate respondsToSelector:@selector(paginatorDidReset:)])
        [self.delegate paginatorDidReset:self];
}
- (void)resetWithNoResetData
{
    self.total = 0;
    self.page = 0;
    _deletedCount = 0;
    self.requestStatus = RequestStatusNone;
    
    // send message to delegate
    if([self.delegate respondsToSelector:@selector(paginatorDidReset:)])
        [self.delegate paginatorDidReset:self];
}
- (BOOL)reachedLastPage
{
    if(self.requestStatus == RequestStatusNone) return NO; // if we haven't made a request, we can't know for sure
    
    if (_responceDoesntContainsTotalCount && _lastResponceContainsEmptyAnswer) return YES;
    
    NSInteger totalPages = ceil((float)self.total/(float)self.pageSize); // total number of pages
    return self.page >= totalPages;
}

# pragma - fetch results

- (void)initFirstPageFetch
{

}

- (void)fetchFirstPage
{     
    // reset paginator
    [self reset];
    [self initFirstPageFetch];
    [self fetchNextPage];
}

- (void)fetchFirstPageNoResetData{
    [self resetWithNoResetData];
    [self initFirstPageFetch];
    [self fetchNextPage];
}

- (void) removeResultAtIndex:(NSInteger)index
{
    [self.results removeObjectAtIndex:index];
    _deletedCount++;
}

- (void) removeObjectFromResult:(id)object
{
    [self.results removeObject:object];
    _deletedCount++;
}

- (void) correctPageNumber
{
    NSInteger deletedPages = floor(_deletedCount / (float)_pageSize);
    _deletedCount -= _pageSize * deletedPages;
    self.page = _page - deletedPages;
}

- (NSInteger) correctedPageSize
{
    return self.pageSize + _deletedCount;
}

- (void)fetchNextPage
{    
    // don't do anything if there's already a request in progress
    if(self.requestStatus == RequestStatusInProgress) 
        return;
    
    if(![self reachedLastPage]) {
        self.requestStatus = RequestStatusInProgress;
        [self correctPageNumber];
        [self fetchResultsWithPage:self.page pageSize:[self correctedPageSize]];
    }
}

#pragma mark - Sublclass methods

- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    // override this in subclass
}

- (void)fetchObjectAtIndex:(NSInteger)index completionHandler:(void (^)(id object, NSError *error))handler;
{
    // override this in subclass
}

#pragma mark received results

// call these from subclass when you receive the results
- (void)receivedResults:(NSArray *)results total:(NSInteger)total infos:(NSDictionary*)infoDict
{
    _someDataFetched = YES;
    
    if(_page == 0)
        self.results = [NSMutableArray array];
    _deletedCount = 0;
    if (results) {
        [self.results addObjectsFromArray:results];
        self.page++;
        self.total = total;
    }
    self.requestStatus = RequestStatusDone;
    
    _lastResponceContainsEmptyAnswer = results.count == 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(paginator:didReceiveResults:infos:)]) {
        [self.delegate paginator:self didReceiveResults:results infos:infoDict];
    }
}

- (void)receivedResults:(NSArray *)results total:(NSInteger)total
{
    _someDataFetched = YES;
    
    if(_page == 0)
        self.results = [NSMutableArray array];
    _deletedCount = 0;
    [self.results addObjectsFromArray:results];
    
    self.page++;
    self.total = total;
    self.requestStatus = RequestStatusDone;
    
    _lastResponceContainsEmptyAnswer = results.count == 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(paginator:didReceiveResults:)]) {
        [self.delegate paginator:self didReceiveResults:results];
    }
}

- (void)failed
{
    _someDataFetched = YES;
    
    self.requestStatus = RequestStatusDone;
    
    if([self.delegate respondsToSelector:@selector(paginatorDidFailToRespond:)])
        [self.delegate paginatorDidFailToRespond:self];
}

@end
