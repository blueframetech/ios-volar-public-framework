//
//  VVDatePickerDelegate.h
//  mobileapidev
//
//  Created by Benjamin Askren on 9/9/13.
//  Copyright (c) 2013 42nd Parallel. All rights reserved.
//

@class VVDatePickerViewController;

#ifndef mobileapidev_VVDatePickerDelegate_h
#define mobileapidev_VVDatePickerDelegate_h

@protocol VVDatePickerDelegate <NSObject>

-(void) doneWithVVDatePicker:(VVDatePickerViewController*)dpvc;
-(void) clearCalledFromVVDatePicker:(VVDatePickerViewController*)dpvc;

@end

#endif
