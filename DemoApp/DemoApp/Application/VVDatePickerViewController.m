//
//  VVDatePickerViewController.m
//  mobileapidev
//
//  Created by Benjamin Askren on 9/8/13.
//  Copyright (c) 2013 42nd Parallel. All rights reserved.
//

#import "VVDatePickerViewController.h"

@interface VVDatePickerViewController ()

@end

@implementation VVDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)datePickerDone:(id)sender {
    if (self.delegate)
        [self.delegate doneWithVVDatePicker:self];
}

-(IBAction)datePickerClear:(id)sender {
    if (self.delegate)
        [self.delegate clearCalledFromVVDatePicker:self];
}

@end
