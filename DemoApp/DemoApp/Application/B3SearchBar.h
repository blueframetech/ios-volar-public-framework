//
//  B3SearchBar.h
//  mobileclient
//
//  Created by Benjamin Askren on 10/26/12.
//  Copyright (c) 2012 42nd Parallel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class B3SearchBar;

@protocol B3SearchBarDelegate <NSObject,UISearchBarDelegate>
-(void) customButtonPressedInSearchBar:(B3SearchBar *)searchBar;
@end


@interface B3SearchBar : UISearchBar {
    @private
    UIButton *customBtn;
}

@property (nonatomic, assign) BOOL showsCustomButton;
@property (nonatomic, strong) NSString *customButtonTitle;

@end

