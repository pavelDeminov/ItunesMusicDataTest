//
//  TrackData+Extended.m
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "TrackData+Extended.h"

@implementation TrackData (Extended)


- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self updateFromDictionary:dict];
    }
    return self;
}

- (void)updateFromDictionary:(NSDictionary *)dict
{
    NSString *uid = [dict objectForKey:@"trackId"];
    if (uid) {
        self.uid = uid;
    }
    
    NSString *title = [dict objectForKey:@"trackName"];
    if (title) {
        self.title = title;
    }
    
    NSString *artist = [dict objectForKey:@"artistName"];
    if (artist) {
        self.artist = artist;
    }
    
    NSString *imgUrl = [dict objectForKey:@"artworkUrl60"];
    if (imgUrl) {
        self.imgUrl = [NSURL URLWithString:imgUrl];
    }
    
    NSString *previewURL = [dict objectForKey:@"previewUrl"];
    if (previewURL) {
        self.previewUrl = [NSURL URLWithString:previewURL];
    }

    
    
}

@end
