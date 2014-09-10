//
//  VVMediaListViewController.h

//
//  Created by Benjamin Askren on 9/20/12.
//  Copyright (c) 2012 Benjamin Askren. All rights reserved.
//

#import "VVCMSAPI.h"

#import <UIKit/UIKit.h>
#import "VVMediaCell.h"
#import <QuickLook/QuickLook.h>
#import "B3SearchBar.h"

#import "VVMoviePlayerViewController.h"
#import "VVSectionPickerViewController.h"
#import "VVDatePickerDelegate.h"
#import "VVDatePickerViewController.h"


@interface VVMediaListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
    UISearchBarDelegate, UINavigationBarDelegate, VVCMSAPIDelegate, \
    VVSectionPickerViewDelegate, UIPopoverControllerDelegate, \
    VVDatePickerDelegate, UIAlertViewDelegate> {
}

@end
