//
//  TrackPaginator.h
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "NMPaginator.h"

@interface TrackPaginator : NMPaginator

@property(nonatomic) NSInteger totalCount;
@property(nonatomic) NSString *searchText;

@end
