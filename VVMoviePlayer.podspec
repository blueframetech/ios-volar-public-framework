Pod::Spec.new do |s|
  s.name         = "VVMoviePlayer"
  s.version      = "2.0.7"
  s.summary      = "iOS library for playback of VolarVideo.com content"
  s.homepage     = "http://volarvideo.com"
  s.author       = { "VolarVideo, Inc" => "appledev@volarvideo.com" }
  s.platform     = :ios 
  s.source       = { :git => "https://github.com/volarvideo/ios-volar-public-framework.git", :tag => "v2.0.7" }
  s.source_files =  'VVMoviePlayer/Headers/*.h'
  s.preserve_paths = 'VVMoviePlayer/libVVMoviePlayer.a'
  s.vendored_libraries = 'VVMoviePlayer/libVVMoviePlayer.a'
  s.ios.deployment_target = '6.0'
  s.frameworks = 'CoreLocation', 'Security', 'CFNetwork', 'MapKit', 'EventKitUI', 'EventKit', 'CoreData', 'CoreMedia', 'AVFoundation', 'SystemConfiguration', 'MediaPlayer', 'ImageIO', 'MessageUI', 'QuartzCore', 'UIKit', 'Foundation', 'CoreGraphics'
  s.dependency 'libPusher', '1.4'
  s.libraries = 'icucore', 'z', 'xml2', 'VVMoviePlayer'
  s.resource = 'VVMoviePlayer/VVMoviePlayerResources.bundle'
  s.requires_arc = true
  s.xcconfig  =  { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/VVMoviePlayer"',
                   'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/VVMoviePlayer/Headers"' }
  s.license = {
    :type => 'Apache 2.0',
    :text => 'VVMoviePlayer/LICENSE'
  }
end