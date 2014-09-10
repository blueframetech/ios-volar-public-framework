//
//  VVDatePickerViewController.h
//  mobileapidev
//
//  Created by Benjamin Askren on 9/8/13.
//  Copyright (c) 2013 42nd Parallel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVDatePickerDelegate.h"

@interface VVDatePickerViewController : UIViewController {
    
}

@property(nonatomic,weak) id <VVDatePickerDelegate> delegate;
@property(nonatomic,strong) IBOutlet UIDatePicker *dp;

-(IBAction)datePickerDone:(id)sender;
-(IBAction)datePickerClear:(id)sender;

@end
