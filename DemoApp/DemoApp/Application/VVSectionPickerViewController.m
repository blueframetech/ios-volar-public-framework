//
//  MultiValuePickerViewController.m
//
//  Created by Benjamin Askren on 2/1/13.
//  Copyright 2013 VolarVideo. All rights reserved.
//

#import "VVSectionPickerViewController.h"


@implementation VVSectionPickerViewController

@synthesize pv;
@synthesize viewDelegate;
@synthesize sections,selectedSection;


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    [super viewWillAppear:animated];
	pv.exclusiveTouch=NO;
}

#pragma mark Table view methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [sections count] + 1;
}


// Customize the appearance of table view cells.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)subRow forComponent:(NSInteger)component {
    if (subRow == 0)
        return @"none";
    if (sections) {
        VVCMSSection *section = [sections objectAtIndex:subRow-1];
        return section.title;
    }
	return nil;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)subRow inComponent:(NSInteger) component {
    currentSelectedIndex = subRow;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 30;
}

-(IBAction) svcDone: (id) sender {
    if (currentSelectedIndex == 0)
        selectedSection = nil;
    else
        selectedSection = [sections objectAtIndex:currentSelectedIndex-1];
    [viewDelegate doneWithVVPickerViewController:self];
}


@end

