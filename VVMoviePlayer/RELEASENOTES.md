### v2.0.6
* Spinner no longer endlessly spins at the end of a live broadcast
* Play/pause but is now disabled when there is no active player

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