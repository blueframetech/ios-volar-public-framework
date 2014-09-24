//
//  VVMoviePlayerController.h
//  mobile
//
//  Created by Benjamin Askren on 12/16/12.
//  Copyright (c) 2012 42nd Parallel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import "VVMoviePlayerDelegate.h"
#import "VVCMSAPI.h"

#define VVVmapPlayerDidChangeNotification @"com.volarvideo.notification.vmapPlayerChanged"

@class VVPlayerView;
@class VVVmap;
@class VVMasterController;
@class VVBasicPlayer;
@class VVMoviePlayerViewController;

/*!
 \brief A VolarVideo media player.
 
 @discussion A VolarVideo movie player (of type VVMoviePlayerController) manages the playback of a movie from a file or a network stream. Playback occurs in a view owned by the VolarVideo movie player and takes place either fullscreen or inline. You can incorporate a movie player’s view into a view hierarchy owned by your app, or use an VVMoviePlayerViewController object to manage the presentation for you.
 
 VolarVideo movie players do not yet support wireless movie playback to AirPlay-enabled hardware such as Apple TV.
 
 When you add a movie player’s view to your app’s view hierarchy, be sure to size the frame correctly, as shown here:
 
 \code
     VVMoviePlayerController *player = [[VVMoviePlayerController alloc] initWithExtendedVMAPURIString:myURLString autoPlay:YES];
     [player.view setFrame: myView.bounds];  // player's frame must match parent's
     [myView addSubview: player.view];
     // ...
     [player play];
 \endcode
 
 Consider a VolarVideo movie player view to be an opaque structure. You can add your own custom subviews to layer content on top of the movie but you must never modify any of its existing subviews.
 
 In addition to layering content on top of a movie, you can provide custom background content by adding subviews to the view in the backgroundView property. Custom subviews are supported in both inline and fullscreen playback modes but you must adjust the positions of your views when entering or exiting fullscreen mode. Use the MPMoviePlayerWillEnterFullscreenNotification and MPMoviePlayerWillExitFullscreenNotification notifications to detect changes to and from fullscreen mode.
 
 This class supports programmatic control of movie playback, and user-based control via buttons supplied by the movie player. You can control most aspects of playback programmatically using the methods and properties of the MPMediaPlayback protocol, to which this class conforms. The methods and properties of that protocol let you start and stop playback, seek forward and backward through the movie’s content, and even change the playback rate. In addition, the controlStyle property of this class lets you display a set of standard system controls that allow the user to manipulate playback. You can also set the shouldAutoplay property for network-based content to start automatically.
 
 You typically specify the movie you want to play when you create a new VVMoviePlayerController object. However, you can also change the currently playing movie by changing the value in the contentURL property. Changing this property lets you reuse the same movie player controller object in multiple places. For performance reasons you may want to play movies as local files. Do this by first downloading them to a local directory.
 
 > **Note:** Although you can create multiple VVMoviePlayerController objects and present their views in your interface, only one movie player at a time can play its movie.
 
 To facilitate the creation of video bookmarks or chapter links for a long movie, the VVMoviePlayerController class defines methods for generating thumbnail images at specific times within a movie. You can request a single thumbnail image using the thumbnailImageAtTime:timeOption: method or request multiple thumbnail images using the requestThumbnailImagesAtTimes:timeOption: method.
 
 To play a network stream whose URL requires access credentials, first connect to your VolarVideo site account by creating a VVCMSAPI instance.  With the credential and protection space information in place, you can then play the protected stream.
 
 @availability 2013-06-06
 */


@interface VVMoviePlayerController : UIViewController <MPMediaPlayback,VVMoviePlayerDelegate> {
}

/*!
 @name Creating and Initializing the Object
 */

/*!
 @abstract Returns a VVMoviePlayerController object initialized with the VolarVideo movie at the specified NSString representation of a URL.
 
 @param vmapURI The location of the VolarVideo movie file. This file must be located either in your app directory or on a remote server.
 
 @param ap Specifies whether the player should automatically play once loaded.
 
 @return The VolarVideo movie player object.
 
 @discussion This method initializes a VolarVideo movie player, and prepares it for playback.
 
 To be notified when a new movie player is ready to play, register for the MPMoviePlayerLoadStateDidChangeNotification notification. You can then check load state by accessing the loadState property.
 
 To check for errors in URL loading, register for the MPMoviePlayerPlaybackDidFinishNotification notification. On error, this notification contains an NSError object available using the @"error" key in the notification’s userInfo dictionary.
 
 @availability Available in iOS 5.0 and later.
 
 */
-(id) initWithExtendedVMAPURIString:(NSString *)vmapURI autoPlay:(BOOL)ap;

/*!
 @abstract Returns a VVMoviePlayerController object initialized with the VolarVideo movie at the specified NSString representation of a URL.
 
 @param vmapURI The location of the VolarVideo movie file. This file must be located either in your app directory or on a remote server.
 
 @param api If an authenticated instance of VVCMSAPI is provided, access to test-mode broadcasts is granted.
 
 @param ap Specifies whether the player should automatically play once loaded.
 
 @return The VolarVideo movie player object.
 
 @discussion This method initializes a VolarVideo movie player, and prepares it for playback.
 
 To be notified when a new movie player is ready to play, register for the MPMoviePlayerLoadStateDidChangeNotification notification. You can then check load state by accessing the loadState property.
 
 To check for errors in URL loading, register for the MPMoviePlayerPlaybackDidFinishNotification notification. On error, this notification contains an NSError object available using the @"error" key in the notification’s userInfo dictionary.
 
 @availability Available in iOS 5.0 and later.
 
 */
-(id) initWithExtendedVMAPURIString:(NSString *)vmapURI withAPI:(VVCMSAPI*)api autoPlay:(BOOL)ap;

/*!
 @name Accessing movie properties
 */
/*!
 @return The NSURL for the VolarExtendedVMAP file.
 
 @discussion Can be nil. A NSURL version of the extendedUriString parameter of [VVMoviePlayerController initWithExtendedVMAPURIString:].
 
 @availability Available in iOS 5.0 and later.
 
 */
@property(nonatomic, readonly) NSURL *extendedVMAPURL;
/*!
 Indicates whether the movie player is currently playing video via AirPlay.
 
 @discussion You can query this property after receiving an MPMoviePlayerIsAirPlayVideoActiveDidChangeNotification notification to find out whether the AirPlay video started or stopped.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property(nonatomic, readonly) BOOL airPlayVideoActive;
/*!
 Specifies whether the movie player allows AirPlay movie playback.
 
 @discussion A movie player supports wireless movie playback to AirPlay-enabled hardware. By default, this property’s value is YES.
 
 To disable AirPlay movie playback, set this property’s value to NO. The movie player then presents a control that allows the user to choose AirPlay-enabled hardware for playback when such hardware is in range.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property(nonatomic) BOOL allowsAirPlay;
/*!
 The URL that points to the raw HLS form of the VolarVideo movie file.
 
 @discussion This is for application programmers benefit. Properties that not yet provided by VVMoviePlayerController but are provided by MPMoviePlayerController can be obtained using this as the contentURL for an instance of MPMoviePlayerController.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property(nonatomic, readonly) NSURL *contentURL;
/*!
 The style of the playback controls.
 
 @discussion The default value of this property is MPMovieControlStyleDefault. You can change the value of this property to change the style of the controls or to hide the controls altogether. For a list of available control styles, see “MPMovieControlStyle.”
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property(nonatomic) MPMovieControlStyle controlStyle;
/*!
 A Boolean that indicates whether the movie player is in full-screen mode.
 
 @discussion The default value of this property is NO. Changing the value of this property causes the movie player to enter or exit full-screen mode immediately. If you want to animate the transition to full-screen mode, use the setFullscreen:animated: method instead.
 
 Whenever the movie player enters or exits full-screen mode, it posts appropriate notifications to reflect the change. For example, upon entering full-screen mode, it posts MPMoviePlayerWillEnterFullscreenNotification and MPMoviePlayerDidEnterFullscreenNotification notifications. Upon exiting from full-screen mode, it posts MPMoviePlayerWillExitFullscreenNotification and MPMoviePlayerDidExitFullscreenNotification notifications.
 
 The value of this property may also change as a result of the user interacting with the movie player controls.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property (nonatomic, getter=isFullscreen) BOOL fullscreen;
/*!
 The types of media available in the movie. (read-only)
 
 @discussion Movies can contain a combination of audio, video, or a combination of the two. The default value of this property is MPMovieMediaTypeMaskNone. See the “MPMovieMediaTypeMask” enumeration for possible values of this property.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property(nonatomic, readonly) MPMovieMediaTypeMask movieMediaTypes;
/*!
 The playback type of the movie.
 
 @discussion The default value of this property is MPMovieSourceTypeUnknown. This property provides a clue to the playback system as to how it should download and buffer the movie content. If you know the source type of the movie, setting the value of this property before playback begins can improve the load times for the movie content. If you do not set the source type explicitly before playback, the movie player controller must gather this information, which might delay playback.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property(nonatomic) MPMovieSourceType movieSourceType;
/*!
 The width and height of the movie frame. (read-only)
 
 @discussion This property reports the clean aperture of the video in square pixels. Thus, the reported dimensions take into account anamorphic content and aperture modes.
 
 It is possible for the natural size of a movie to change during playback. This typically happens when the bit-rate of streaming content changes or when playback toggles between audio-only and a combination of audio and video.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property (nonatomic, readonly) CGSize naturalSize;
/*!
 Causes the movie player to enter or exit full-screen mode.
 
 @param fullscreen Specify YES to enter full-screen mode or NO to exit full-screen mode.
 @param animated Specify YES to animate the transition between modes or NO to switch immediately to the new mode.
 
 @availability Available in iOS 5.0 and later.
 
 */
- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated;
/*!
 The scaling mode to use when displaying the movie.
 
 @discussion Changing this property while the movie player is visible causes the current movie to animate to the new scaling mode.
 
 The default value of this property is MPMovieScalingModeAspectFit. For a list of available scaling modes, see “MPMovieScalingMode.”
 
 @availability Available in iOS 5.0 and later.
 
 */
@property(nonatomic) MPMovieScalingMode scalingMode;


/*!
 Shows or hides the scale mode button
 */
-(void) setScaledButtonHidden:(BOOL)hidden;

/*!
 True if the scale button is hidden
 */
-(BOOL) isScaledButtonHidden;

/*!
 @name Accessing the Movie Duration
 */
/*!
 The duration of the movie, measured in seconds. (read-only)
 
 @discussion If the duration of the movie is not known, the value in this property is 0.0. If the duration is subsequently determined, this property is updated and a MPMovieDurationAvailableNotification notification is posted.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property (nonatomic, readonly) NSTimeInterval duration;
/*!
 The amount of currently playable content. (read-only)
 
 @discussion For progressively downloaded network content, this property reflects the amount of content that can be played now.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property (nonatomic, readonly) NSTimeInterval playableDuration;



/*!
 @name Accessing the View
 */
/*!
 A customizable view that is displayed behind the movie content. (read-only)
 
 @discussion This view provides the backing content, on top of which the movie content is displayed. You can add subviews to the background view if you want to display custom background content.
 
 This view is part of the view hierarchy returned by the view property.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property(nonatomic, readonly) IBOutlet UIView *backgroundView;





/*!
 @name Controlling and Monitoring Playback
 */
/*!
 The end time (measured in seconds) for playback of the movie.
 
 @discussion The default value of this property is -1, which indicates the natural end time of the movie. This property is not applicable for streamed content.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property (nonatomic) NSTimeInterval endPlaybackTime;
/*!
 The time, specified in seconds within the video timeline, when playback should start.
 
 @discussion For progressively downloaded content, playback starts at the closest key frame prior to the provided time. For video-on-demand content, playback starts at the nearest segment boundary to the provided time. For live video streams, the playback start time is measured from the start of the current playlist and is rounded to the nearest segment boundary.
 
 The default value of this property is -1, which indicates the natural start time of the movie.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property (nonatomic) NSTimeInterval initialPlaybackTime;
/*!
 The network load state of the movie player. (read-only)
 
 @discussion See the “MPMovieLoadState” enumeration for possible values of this property. To be notified of changes to the load state of a movie player, register for the MPMoviePlayerLoadStateDidChangeNotification notification.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property(nonatomic, readonly) MPMovieLoadState loadState;
/*!
 The current playback state of the movie player. (read-only)
 
 @discussion The playback state is affected by programmatic calls to play, pause, or stop the movie player. It can also be affected by user interactions or by the network, in cases where streaming content cannot be buffered fast enough.
 
 See the “MPMoviePlaybackState” enumeration for possible values of this property. To be notified of changes to the playback state of a movie player, register for the MPMoviePlayerPlaybackStateDidChangeNotification notification.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property(nonatomic, readonly) MPMoviePlaybackState playbackState;
/*!
 A Boolean that indicates whether the first video frame of the movie is ready to be displayed.
 
 @discussion The default value of this property is NO. This property returns YES if the first video frame is ready to be displayed and returns NO if there are no video tracks associated. When the value of this property changes to YES, a MPMoviePlayerReadyForDisplayDidChangeNotification is sent.
 
 @availability Available in iOS 6.0 and later.
 
 */
@property(nonatomic, readonly) BOOL readyForDisplay NS_AVAILABLE_IOS(6_0);
/*!
 Determines how the movie player repeats the playback of the movie.
 
 @discussion The default value of this property is MPMovieRepeatModeNone. For a list of available repeat modes, see “MPMovieRepeatMode.”
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property(nonatomic) MPMovieRepeatMode repeatMode;
/*!
 A Boolean that indicates whether a movie should begin playback automatically.
 
 @discussion The default value of this property is YES. This property determines whether the playback of network-based content begins automatically when there is enough buffered data to ensure uninterrupted playback.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property(nonatomic) BOOL shouldAutoplay;
/*!
 Obtains the most recent time-based metadata provided by the streamed movie.
 
 @return An array of the most recent MPTimedMetadata objects provided by the streamed movie.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
- (NSArray *)timedMetadata;





/*!
 @name Generating Thumbnail Images
 */
/*!
 Cancels all pending asynchronous thumbnail image requests.
 
 @discussion This method cancels only requests made using the requestThumbnailImagesAtTimes:timeOption: method. It does not cancel requests made synchronously using the thumbnailImageAtTime:timeOption: method.
 
 @availability Available in iOS 5.0 and later.
 
 */
- (void)cancelAllThumbnailImageRequests;
/*!
 Captures one or more thumbnail images asynchronously from the current movie.
 
 @param playbackTimes An array of NSNumber objects containing the times at which to capture the thumbnail images. Each time value represents the number of seconds from the beginning of the current movie.
 @param option The option to use when determining which specific frame to use for each thumbnail image. For a list of possible values, see “MPMovieTimeOption.”
 
 @discussion This method processes each thumbnail request separately and asynchronously. When the results for a single image arrive, the movie player posts a MPMoviePlayerThumbnailImageRequestDidFinishNotification notification with the results for that image. Notifications are posted regardless of whether the image capture was successful or failed. You should register for this notification prior to calling this method.
 
 @availability Available in iOS 5.0 and later.
 
 */
- (void)requestThumbnailImagesAtTimes:(NSArray *)playbackTimes timeOption:(MPMovieTimeOption)option;

/*!
 Captures and returns a thumbnail image from the current movie.
 
 @param playbackTime The time at which to capture the thumbnail image. The time value represents the number of seconds from the beginning of the current movie.
 @param option The option to use when determining which specific frame to use for the thumbnail image. For a list of possible values, see “MPMovieTimeOption.”
 
 @return An image object containing the image from the movie or nil if the thumbnail could not be captured.
 
 @discussion This method captures the thumbnail image synchronously from the current movie (which is accessible from the MPMovieSourceTypeUnknown property).
 
 @availability Available in iOS 5.0 and later.
 
 */
- (UIImage *)thumbnailImageAtTime:(NSTimeInterval)playbackTime timeOption:(MPMovieTimeOption)option;





/*!
 @name Retrieving Movie Logs
 */
/*!
 A snapshot of the network playback log for the movie player if it is playing a network stream.
 
 @discussion Can be nil. For information about movie access logs, refer to MPMovieAccessLog Class Reference.
 
 @availability NOT ACTIVE AT THIS TIME.
 
 */
@property(nonatomic,readonly) MPMovieAccessLog *accessLog;
/*!
 A snapshot of the playback failure error log for the movie player if it is playing a network stream.
 
 @discussion Can be nil. For information about movie error logs, refer to MPMovieErrorLog Class Reference.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property (nonatomic, readonly) MPMovieErrorLog *errorLog;



/*!
 @name Unavailable Methods and Properties
 The following methods and properties must not be used.
 */

/*!
 The currently displayed message used to indicate an special playing circumstance, such as Audio Only or No Ads Available.
 
 @discussion The label is used to communicate special playback circumstances, for which the viewer may need additional information.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property(nonatomic, strong) IBOutlet UILabel *messageLabel;
/*!
 Display a special playback circumstance message.
 
 @param message The string currently displayed over the player
 
 @discussion The label is used to communicate special playback circumstances, for which the viewer may need additional information.
 
 @availability Available in iOS 5.0 and later.
 
 */
-(void) displayMessage:(NSString*)message;
/*!
 Clear the special playback circumstance message.
 
 @availability Available in iOS 5.0 and later.
 
 */
-(void) hideMessages;
/*!
 Informs the controller that the parent view controller did load and provides a reference for when the video is done to dismiss.
 
 @availability Available in iOS 5.0 and later.
 
 */
-(void) parentViewDidLoad:(id) pvc;
/*!
 Debug display of remaining time in an ad break.
 
 @availability Available in iOS 5.0 and later.
 
 */
@property(nonatomic,strong) IBOutlet UILabel *lblCount;

@end
