//
//  VVMoviePlayerDelegate.h
//  VVMoviePlayer
//
//  Created by user on 5/20/14.
//  Copyright (c) 2014 VolarVideo. All rights reserved.
//

#ifndef VVMoviePlayer_VVMoviePlayerDelegate_h
#define VVMoviePlayer_VVMoviePlayerDelegate_h

@class VVMasterController;
@class VVBasicPlayer;

@protocol VVMoviePlayerDelegate

-(void) setLoadState:(MPMovieLoadState)loadstate;
-(void) setMovieMediaTypes:(MPMovieMediaTypeMask)movieMediaTypes;
-(void) setDuration:(NSTimeInterval)d;
-(void) setNaturalSize:(CGSize)s;

-(void) shutdown;
-(void) pause;
-(void) resume;
-(BOOL) isLiveContent;
-(BOOL) inAdBreak;
-(void) setContentPlayer:(VVBasicPlayer*)player;
-(void) setActivePlayer:(VVBasicPlayer*)player;
-(BOOL) playing;
-(BOOL) playingAd;
-(BOOL) playingContent;
-(BOOL) contentIsActive;
-(BOOL) adIsActive;
-(void) displayMessage:(NSString*)message;
-(void) hideMessages;
-(void) updateAdCountdownTime:(NSTimeInterval)remaining;
-(void) showSplash:(UIImage *)image;
-(void) hideSplash;
-(void) showSpinner:(BOOL)show;
-(void) contentPreloadDidFinishWithError:(NSError*)error message:(NSString*)message;
-(void) contentFinishedWithError:(NSError*)error message:(NSString*)message;
-(VVBasicPlayer*) activePlayer;
-(void) checkAudioOnlyToggle;
-(void) setReadyForDisplay:(BOOL)ready;

@end

/*
 -(void) setAudioOnly:(BOOL)audioOnly;
 -(void) hideSpinner;
 -(UIActivityIndicatorView*)spinner;
 -(void) setStartCount:(double)c;
 -(void) setEndCount:(double)c;
 */



#endif
