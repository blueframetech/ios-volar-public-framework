# DemoApp
This iOS project is a demo application using the VolarVideo iOS SDK.  To view your content you have to authenticate using the `VVCMSAPI` class. To get the demo application to authenticate, open the `MediaListViewController.m` file.  Find the following line:

```
#define API_KEY @"<insert api key>"
```

Replace the string `<insert api key>` with your API key.  If you don't have an API key, you can get one by following the steps [here](https://github.com/volarvideo/cms-client-sdk/wiki/Creating-api-credentials).  You can also use your Volar account credentials to instantiate the `VVCMSAPI` class.  Here's an example that's commented out in `MediaListViewController.m`.

```objective-c
api = [[VVCMSAPI alloc] initWithDomain:@"vcloud.volarvideo.com" username:@"john.doe@test.com" password:@"password"];
```

## Included Libraries

### iToast

	Copyright (c) 2012 Guru Software
	https://github.com/ecstasy2/toast-notifications-ios

### SDWebImage

	Copyright (c) 2009 Olivier Poitrey
	https://github.com/rs/SDWebImage

### MBProgressHUD

	Copyright (c) 2013 Matej Bukovinski
	https://github.com/jdg/MBProgressHUD

### libPusher

	Copyright (c) 2010 Luke Redpath
	https://github.com/lukeredpath/libPusher

### PRPAlertView

	Copyright 2011 Bookhouse Software LLC.