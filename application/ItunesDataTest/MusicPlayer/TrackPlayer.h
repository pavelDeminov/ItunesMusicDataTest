//
//  MusicPlayer.h
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrackData;

@protocol TrackPlayerDelegate <NSObject>

-(void)stopPLayingTrack:(TrackData*)trackData;

@end



@interface TrackPlayer : NSObject

@property (nonatomic,weak) TrackData *playingTrack;
@property (nonatomic) BOOL isPaused;
@property (nonatomic,weak) id <TrackPlayerDelegate> delegate;


+ (instancetype)sharedInstance;

-(void)playTrack:(TrackData*)trackData;
-(void)pauseTrack;

@end
