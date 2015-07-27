//
//  NMPaginator.h
//
//  Created by Nicolas Mondollot on 07/04/12.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestStatus) {
    RequestStatusNone,
    RequestStatusInProgress,
    RequestStatusDone // request succeeded or failed
};

@protocol NMPaginatorDelegate
@required
- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results;

@optional
- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results infos:(NSDictionary*)infoDict;
- (void)paginatorDidReceiveSuccessfulResponseForFirstPage:(id)paginator;
- (void)paginatorDidFailToRespond:(id)paginator;
- (void)paginatorDidReset:(id)paginator;
@end

@interface NMPaginator : NSObject {
    id <NMPaginatorDelegate> __weak delegate;
}

@property (weak) id delegate;
@property (assign, readonly) NSInteger pageSize; // number of results per page
@property (assign, readonly) NSInteger page; // number of pages already fetched
@property (assign, readonly) NSInteger total; // total number of results
@property (assign, readonly) RequestStatus requestStatus;
@property (nonatomic, strong, readonly) NSMutableArray *results;
@property (nonatomic, readonly, assign) BOOL someDataFetched;

@property (assign, nonatomic) BOOL responceDoesntContainsTotalCount;

- (id)initWithPageSize:(NSInteger)pageSize delegate:(id<NMPaginatorDelegate>)paginatorDelegate;
- (void)reset;
- (BOOL)reachedLastPage;

- (void)fetchFirstPage;
- (void)initFirstPageFetch;
- (void)fetchNextPage;
- (void)fetchFirstPageNoResetData;
- (void)fetchObjectAtIndex:(NSInteger)index completionHandler:(void (^)(id object, NSError *error))handler;


// use this methods for deleteng objects from results
- (void) removeResultAtIndex:(NSInteger)index;
- (void) removeObjectFromResult:(id)object;

// call these from subclass when you receive the results
- (void)receivedResults:(NSArray *)results total:(NSInteger)total;
- (void)receivedResults:(NSArray *)results total:(NSInteger)total infos:(NSDictionary*)infoDict;
- (void)failed;

@end
