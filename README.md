# Volar Video iOS SDK
This SDK includes a widget for playing live/archived broadcasts managed by a VolarVideo CMS as well as a wrapper for the API to access the content the Volar system manages.  Detailed documentation about the SDK can be found [here](http://volarvideo.github.io/ios-volar-public-framework).  *For a working implementation of this project see the `DemoApp` folder.*


### Including the SDK
The easiest way to include the SDK is to use CocoaPods.  It takes care of all the required frameworks and third party dependencies:
```ruby
pod 'VVMoviePlayer'
```

Alternatively, you can install it manually by following these steps:

1. Copy the <b>VVMoviePlayer</b> directory into your project directory.
2. Open your project settings and go to the "Build Phases" tab. In the Link library with binaries section click "+". In the popup window click "add another" at the bottom and select the <b>libVVMoviePlayer.a</b> library file.

   In addition, VVMoviePlayer requires the following native iOS frameworks:
    * CoreLocation.framework
    * Security.framework
    * CFNetwork.framework
    * libicucore.lib
    * MapKit.framework
    * libxml2.dylib
    * EventKitUI.framework
    * EventKit.framework
    * CoreMedia.framework
    * AVFoundation.framework
    * libz.dylib
    * SystemConfiguration.framework
    * MediaPlayer.framework
    * ImageIO.framework
    * MessageUI.framework
    * QuartzCore.framework
    * UIKit.framework
    * Foundation.framework
    * CoreGraphics.framework
    ![Example](http://volarvideo.github.io/ios-volar-public-framework/frameworks.png)
5. Add the following to your Other Linker Flags in the "Build Settings" for your app: `-all_load -ObjC`

The above <b>libVVMoviePlayer.a</b> includes `libPusher-1.6` and its dependencies (`SocketRocket` and `ReactiveCocoa`).  If you are already using one of these dependencies, you'll need to use <b>libVVMoviePlayer-no-deps.a</b> and link to any missing libraries:

   * [libPusher-combined.a](http://volarvideo.github.io/ios-volar-public-framework/files/libPusher-combined.a)
   * [SocketRocket](https://github.com/square/SocketRocket)
   * [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)

### Configuring your app for GPS on iOS 8
The SDK needs access to the device's GPS to display content that might be blocked for certain regions of the world.  Starting in iOS 8, it is required to specify some verbage to be displayed when asking the user for permission to access their location.  Unfortunately, the only way to specify it is in your app's `Info.plist` file.  The SDK requests permission to get the device's location when the app is in the foreground.  This *requires* a string value set for the key `NSLocationWhenInUseUsageDescription`.  Additionally, if you would like the same message to be displayed on previous versions of iOS, you can set a string value for the key `NSLocationUsageDescription`.  More information can be found [here](https://developer.apple.com/library/IOs/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW18).  Here's a preferred example:

![Example](http://volarvideo.github.io/ios-volar-public-framework/gps-setup.png)

### Using the SDK
It's quick and easy to spawn an instance of `VVMoviePlayerViewController`.  Here's an example:

```objective-c
VVMoviePlayerViewController *mpvc;
mpvc = [[VVMoviePlayerViewController alloc] initWithExtendedVMAPURIString:vmapURI];
```

### Querying for Content
To query content on a VolarVideo CMS, you'll need to use the `VVCMSAPI` class. There are two ways to instantiate this class for authenticated querying. The first and more desired method is with an API key. You can find a detailed description of how to create an API user [here](https://github.com/volarvideo/cms-client-sdk/wiki/Creating-api-credentials). Here's an example in code:

```objective-c
NSString *API_KEY = @"<your api key>";
VVCMSAPI *api = [[VVCMSAPI alloc] initWithDomain:@"vcloud.volarvideo.com" apiKey:API_KEY];
```

The second method of instantiation is with a username and password as shown below:

```objective-c
VVCMSAPI *api = [[VVCMSAPI alloc] initWithDomain:@"vcloud.volarvideo.com" username:@"john.doe@test.com" password:@"password"];
```

Now that you have an instance of `VVCMSAPI`, it's easy to query for data.  Simply provide an instance of `VVCMSAPIDelegate`to any of the methods to handle responses.  Here's an example of querying for the 3rd page of archived broadcasts with 20 results per page:

```objective-c
BroadcastParams *params = [[BroadcastParams alloc] init];
params.status = VVCMSBroadcastStatusArchived;
params.page = [[NSNumber alloc] initWithInt:3];
params.resultsPerPage = [[NSNumber alloc] initWithInt:20];
[api requestBroadcasts:params usingDelegate:delegate];
```

The corresponding delegate method would look like this:

```objective-c
- (void)VVCMSAPI:(VVCMSAPI *)vvapi requestForBroadcastsResult:(NSArray *)broadcasts
    withStatus:(VVCMSBroadcastStatus)status page:(int)page totalPages:(int)totalPages
    totalResults:(int)totalResults error:(NSError *)error {
    
    // We're not guaranteed to be called on the thread the request was made from
    dispatch_async(dispatch_get_main_queue(), ^(void){
          if(error) {
              // handle error
              return;
          }

          // process data
    });
}
```

### Mobile Web Launch
The VolarVideo CMS allows you to register your mobile app to be launched from a mobile browser.  Just follow the steps <a href="https://github.com/volarvideo/cms-client-sdk/wiki/Creating-your-own-Mobile-app">here</a> to get set up.  In this process, you'll choose a custom URL token.  Open your project settings and go to the "Info" tab.  In the URL Types section, click "+".  Choose an identifier (usually your bundle ID) and set your URL scheme to the URL token from the previous step.  Below is an example where the token is set to `mytoken`.

![Example](http://volarvideo.github.io/ios-volar-public-framework/custom-scheme.png)

In your <b>AppDelegate</b>, you can detect the web launch and retreive the video URL by adding the following method:

```objective-c
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *vmapURI = [url description];

    // Use vmapURI when creating your VVMoviePlayerViewController
    
    return YES;
}
```