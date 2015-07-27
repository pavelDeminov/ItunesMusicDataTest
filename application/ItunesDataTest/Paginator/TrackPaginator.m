//
//  TrackPaginator.m
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "TrackPaginator.h"
#import "APIClient.h"
#import "TrackData+Extended.h"

@implementation TrackPaginator

- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    
    NSInteger limit = pageSize;
    NSInteger offset = page*pageSize;
    
    [[APIClient sharedInstance] getMusicData:_searchText country:@"" limit:@(limit) offset:@(offset) completionHandler:^(BOOL succes, NSArray *songs, NSError *error,NSInteger total) {
        
        
        if (succes) {
            
            NSMutableArray *tracks = [NSMutableArray new];
            for (NSDictionary *dict in songs) {
                
                TrackData *trackData = [[TrackData alloc] initWithDictionary:dict];
                [tracks addObject:trackData];
            }
            //some work around solution because API not return totalCount
            if (total==0) {
                //stop fetch
                _totalCount+=total;
            } else {
                //fetch next page
                _totalCount+=total+1;

            }
            
            [self receivedResults:tracks total:_totalCount];
        } else {
            NSLog(@"%@", error);
            [self receivedResults: nil total: 0];
        }
        
        
        
        
    }];
    
   }


@end
