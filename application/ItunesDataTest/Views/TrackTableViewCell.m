//
//  TrackTableViewCell.m
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "TrackTableViewCell.h"
#import "TrackData+Extended.h"
#import "UIImageView+WebCache.h"
#import "TrackPlayer.h"


@interface TrackTableViewCell () <TrackPlayerDelegate>{
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *ivThumbnail;
    IBOutlet UILabel *lblArtist;
    IBOutlet UIButton *btnPLay;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@end;

@implementation TrackTableViewCell

#pragma mark Base

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Setters
-(void)setTrackData:(TrackData *)trackData {
    
    _trackData = trackData;
    [self updateView];
    
}


#pragma mark Actions

-(IBAction)btnPlayPressed:(id)sender {
    
    
    if ([TrackPlayer sharedInstance].playingTrack == _trackData &&  [TrackPlayer sharedInstance].isPaused == NO) {
        
        [[TrackPlayer sharedInstance] pauseTrack];
        
    } else {
        [[TrackPlayer sharedInstance] playTrack:_trackData];
        [TrackPlayer sharedInstance].delegate = self;
        
        
    }
    [self updateView];
    
    
}

#pragma mark TrackPlayerDelegate

-(void)stopPLayingTrack:(TrackData*)trackData {
    
    [self updateView];
    
}

#pragma mark Private

-(void)updateView {
    
    lblTitle.text = _trackData.title;
    lblArtist.text = _trackData.artist;
    
    [activityIndicator startAnimating];
    [ivThumbnail sd_setImageWithURL:_trackData.imgUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [activityIndicator stopAnimating];
        
    }];
    
    if ([TrackPlayer sharedInstance].playingTrack == _trackData &&  [TrackPlayer sharedInstance].isPaused == NO) {
        
        UIImage *pauseImage = [UIImage imageNamed:@"btnPause"];
        [btnPLay setImage:pauseImage forState:UIControlStateNormal];
    } else {
        UIImage *playImage = [UIImage imageNamed:@"btnPlay"];
        [btnPLay setImage:playImage forState:UIControlStateNormal];
        
    }
    
}




@end
