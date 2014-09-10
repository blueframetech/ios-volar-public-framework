//
//  UIViewController+VVMoviePlayerViewController.h
//  VVMoviePlayer
//
//  Created by Benjamin Askren on 6/6/13.
//  Copyright (c) 2013 Zach Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VVMoviePlayerViewController;

/**
 This category adds methods to the UIViewController class for presenting and dismissing a VolarVideo movie player using a specific set of animations. The transitions used by these methods are the same ones used by the YouTube and iPod applications to display video content.
 */
@interface UIViewController(VVMoviePlayerViewController)

/**
 @name Presenting and Dismissing the Movie Player
 */
/**
 Presents the movie player view controller using the standard movie player transition.
 
 @param player The VolarVideo movie player view controller to present.


 @availability
 Available in iOS 5.0 or later.
*/
-(void) presentVolarMoviePlayerViewControllerAnimated:(VVMoviePlayerViewController*)player;

/**
 Dismisses a VolarVideo movie player view controller using the standard movie player transition.
 
 @discussion
 If the receiver’s modalViewController property does not contain a VolarVideo movie player view controller, this method does nothing.
 
 @availability
 Available in iOS 5.0 or later.
 */
-(void) dismissVolarMoviePlayerViewControllerAnimated;

@end
