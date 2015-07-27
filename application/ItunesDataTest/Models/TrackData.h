//
//  TrackData.h
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackData : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSURL *imgUrl;
@property (strong, nonatomic) NSURL *previewUrl;

@end
