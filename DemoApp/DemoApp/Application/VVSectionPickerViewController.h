//
//  VVPickerViewController.h
//
//  Created by Benjamin Askren on 2/1/13.
//  Copyright 2013 VolarVideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVSectionPickerViewDelegate.h"
#import "VVCMSSection.h"

@interface VVSectionPickerViewController : UIViewController <UIPickerViewDelegate> {
	UIPickerView *pv;
    __weak id <VVSectionPickerViewDelegate> viewDelegate;
    int currentSelectedIndex;
}

@property (nonatomic, strong) IBOutlet UIPickerView *pv;
@property (nonatomic, weak) id <VVSectionPickerViewDelegate> viewDelegate;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) VVCMSSection *selectedSection;

-(IBAction) svcDone: (id) sender;

@end
