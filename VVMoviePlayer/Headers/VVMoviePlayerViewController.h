//
//  VVMoviePlayerViewController.h
//  mobile
//
//  Created by Benjamin Askren on 12/16/12.
//  Copyright (c) 2012 42nd Parallel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewController.h>
#import "VVMoviePlayerController.h"
#import "VVCMSAPI.h"
#import "UIViewController+VVMoviePlayerViewController.h"

/**
 \brief Default view controller that wraps a VVMoviePlayerController

 The VVMoviePlayerViewController class implements a simple view controller for displaying full-screen VolarVideo movies. Unlike using an VVMoviePlayerController object on its own to present a movie immediately, you can incorporate a movie player view controller wherever you would normally use a view controller. For example, you can present it using a tab bar or navigation bar-based interface, taking advantage of the transitions offered by those interfaces.
 
 To present a VolarVideo movie player view controller modally, you typically use the presentMoviePlayerViewControllerAnimated: method. This method is part of a category on the UIViewController class and is implemented by the Media Player framework. The presentMoviePlayerViewControllerAnimated: method presents a movie player view controller using the standard transition animations for presenting video content. To dismiss a modally presented movie player view controller, call the dismissMoviePlayerViewControllerAnimated method.
 */
@interface VVMoviePlayerViewController : UIViewController {
}

/**
 @name Creating and Initializing the object
 */
/**
 Returns a VolarVideo movie player view controller initialized with the specified movie.
 
 @param extendedVMAPURL The string representation of the URL that points to the content to be played.
 
 @return
 A VolarVideo movie player view controller initialized with the specified string represenation of the VolarVMAP URL.
 */
-(id) initWithExtendedVMAPURIString:(NSString*)extendedVMAPURL;

/**
 @name Creating and Initializing the object
 */
/**
 Returns a VolarVideo movie player view controller initialized with the specified movie.
 
 @param extendedVMAPURL The string representation of the URL that points to the content to be played.
 @param api If an authenticated instance of VVCMSAPI is provided, access to test-mode broadcasts is granted.
 
 @return
 A VolarVideo movie player view controller initialized with the specified string represenation of the VolarVMAP URL.
 */
-(id) initWithExtendedVMAPURIString:(NSString*)extendedVMAPURL withAPI:(VVCMSAPI*)api;

/**
 @name Accessing the VVMoviePlayerController base object:
 */

/**
 The VolarVideo movie player controller object used to present the movie. (read-only)
 
 @discussion 
 The MPMoviePlayerController object in this property is created automatically by the receiver and cannot be changed. However, you can use the object to manage the presentation and configuration of the movie playback.
 
 @availability
 Available in iOS 5.0 or later.
 */
@property(nonatomic, readonly) VVMoviePlayerController* moviePlayer;

/**
 @name Controller the display of the VVMoviePlayerController view
 */

/**
 Returns a Boolean value indicating whether the view controller supports the specified orientation.
 
 @param toInterfaceOrientation The orientation of the application’s user interface after the rotation. The possible values are described in UIInterfaceOrientation.

 @return 
 YES if the view controller supports the specified orientation or NO if it does not.
 
 @discussion 
 This method is an override that replaces the default behavior by returning YES for the UIInterfaceOrientationPortrait, UIInterfaceOrientationLandscapeLeft, and UIInterfaceOrientationLandscapeRight orientations.

 @availability
 Available in iOS 5.0 or later.
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end


 