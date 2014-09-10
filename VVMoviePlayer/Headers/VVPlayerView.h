//
//  VVContentPlayerView.h
//  mobile
//
//  Created by Benjamin Askren on 12/31/12.
//  Copyright (c) 2012 42nd Parallel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AVPlayer;

/**
 \brief View used internally for VVMoviePlayerController
 */
@interface VVPlayerView : UIView

@property (nonatomic, retain) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
