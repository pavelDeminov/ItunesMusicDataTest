//
//  MusicPlayer.m
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "TrackPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "TrackData+Extended.h"


@interface TrackPlayer () <AVAudioPlayerDelegate>


@property(nonatomic,strong) AVPlayer *songPlayer;
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;

@end;

@implementation TrackPlayer



+ (instancetype)sharedInstance
{
    static TrackPlayer *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[TrackPlayer alloc] init];
    });
    
    return sharedInstance;
}


-(void)setDelegate:(id<TrackPlayerDelegate>)delegate {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(TrackPlayerDelegate)]) {
        [self.delegate stopPLayingTrack:_playingTrack];
    }
    _delegate = delegate;
    
}
-(void)playTrack:(TrackData*)trackData {
    
    if ( trackData==_playingTrack && _isPaused == YES) {
        
        _isPaused = NO;
        [self.songPlayer play];

        
    } else {
        
        _isPaused = NO;
        _playingTrack = trackData;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.songPlayer removeObserver:self forKeyPath:@"status"];
        
        AVPlayer *player = [[AVPlayer alloc]initWithURL:trackData.previewUrl];
        self.songPlayer = player;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_songPlayer currentItem]];
        [self.songPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
        
        
        [self.songPlayer play];
        
        
    }
    
     
    
}

-(void)pauseTrack {
    
    _isPaused = YES;
    [self.songPlayer pause];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == _songPlayer && [keyPath isEqualToString:@"status"]) {
        if (_songPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (_songPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            
        } else if (_songPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    TrackData *oldTrack =_playingTrack;
    _playingTrack = nil;
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(TrackPlayerDelegate)]) {
        [self.delegate stopPLayingTrack:oldTrack];
    }
    
    NSLog(@"Finished Playing");
    
}


@end
