//
//  VVVmapDelegate.h
//  mobileapidev
//
//  Created by Benjamin Askren on 1/26/13.
//  Copyright (c) 2013 42nd Parallel. All rights reserved.
//

#ifndef mobileapidev_VVVmapDelegate_h
#define mobileapidev_VVVmapDelegate_h

@class VVVmap;
@class VVCMSAPI;

@protocol VVVmapDelegate
-(VVCMSAPI*) authedAPI;
-(void) authenticateLocation:(VVVmap*)vmap;
@end


#endif
