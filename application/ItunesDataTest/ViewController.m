//
//  ViewController.m
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ViewController.h"
#import "APIClient.h"
#import "MBProgressHUD.h"
#import "TrackData+Extended.h"
#import "TrackTableViewCell.h"
#import "TrackPaginator.h"
#import "SearchView.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,NMPaginatorDelegate,SearchViewDelegate> {
    
    IBOutlet UITableView *_tableView;
    
}
@property (nonatomic,strong) NSArray *tracks;
@property (nonatomic,strong) TrackPaginator   *trackPaginator;
@property (nonatomic,strong) SearchView   *searchView;

@end

@implementation ViewController


#pragma mark - VC Base methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setupTableViewFooter];
    //[self setupTableViewHeader];
    
    self.trackPaginator= [[TrackPaginator alloc] initWithPageSize:20 delegate:self];
    
    //[self loadData];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
//    [self updateTableViewHeaderViewHeight];
//}

#pragma mark UITableView Delegate & DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.trackPaginator.results.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TrackTableViewCell class]) forIndexPath:indexPath];
    
    
    TrackData *trackData =[self.trackPaginator.results objectAtIndex:indexPath.row];
    cell.trackData = trackData;
    
    return cell;
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return _searchView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_searchView==nil) {
        
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:self options:nil] lastObject];
        _searchView.delegate = self;
        
    }
   
    
    return _searchView.frame.size.height;
}



#pragma mark TableView ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
        
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height)
    {
        if(![self.trackPaginator reachedLastPage])
        {
            [self fetchNextPage];
        }
    }
    
}


#pragma mark NMPAginator delegate

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    //  [self.activityIndicator stopAnimating];
    [_tableView reloadData];
    
}

#pragma mark SearchView delegate

-(void)searchText:(NSString*)text {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.trackPaginator.searchText = text;
    [self.trackPaginator fetchFirstPage];
    
    
}

#pragma mark - Private methods

- (void)fetchNextPage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.trackPaginator fetchNextPage];
    // [self.activityIndicator startAnimating];
}

- (void)setupTableViewFooter
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)setupTableViewHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
    headerView.backgroundColor = [UIColor clearColor];
    
    SearchView *searchView = [[[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:self options:nil] lastObject];
    searchView.delegate = self;
    [headerView addSubview:searchView];
    _tableView.tableHeaderView = headerView;
}

//-(void)loadData {
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[APIClient sharedInstance] getMusicData:@"The doors" country:@"" limit:@(20) offset:@(20) completionHandler:^(BOOL succes, NSArray *songs, NSError *error) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        NSMutableArray *tracks = [NSMutableArray new];
//        for (NSDictionary *dict in songs) {
//            
//            TrackData *trackData = [[TrackData alloc] initWithDictionary:dict];
//            [tracks addObject:trackData];
//        }
//        
//        self.tracks = tracks;
//        [_tableView reloadData];
//        
//        
//    }];
//    
//}




@end
