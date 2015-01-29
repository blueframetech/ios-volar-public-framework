### v2.0.9
* Fixed crash seen when starting live broadcasts
* Fixed UI problems with broadcasts greater than 24 hours in duration

### v2.0.8
* Pusher and its dependencies are bundled with the distributed libVVMoviePlayer.a
* The control bar now shows/hides in a more user-friendly way
* Fixed a crash seen on some devices
* Fixed a case where a preroll ad could be cut short
* Fixed UI bug during live midrolls

### v2.0.7
* Fixed bug with geoblocked broadcasts not loading on iOS 8
  - NOTE: There is a new required key/value that must be set in your app's
    Info.plist called `NSLocationWhenInUseUsageDescription`.  View the
    section titled *Configuring your app for GPS on iOS 8* in the
    [README](https://github.com/volarvideo/ios-volar-public-framework/blob/master/README.md)
    for more details.
* Adds real-time player analytics

### v2.0.6
* Spinner no longer endlessly spins at the end of a live broadcast
* Play/pause button is now disabled when there is no active player

### v2.0.5
* Fixed bug where iOS 8 would end live broadcasts with endless spinner
* Fixed bug with duration-based prerolls
* Entering a stopped broadcast properly starts when broadcasts starts

### v2.0.4
* Fixed linking problems in Xcode 5

### v2.0.3
* Added the `armv7s` architecture to the universal binary
* NOTE: Only works in Xcode 6

### v2.0.2
* Fixed problem on iOS 8 where video would play only audio
* Fixed miscellaneous ad logic bugs

### v2.0.1
* Added section ID to VVCMSBroadcast model
* You can now hide/show the scale mode button via VVMoviePlayerController
* Fixed podspec to correctly include library for xcode