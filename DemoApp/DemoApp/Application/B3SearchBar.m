//
//  B3SearchBar.m
//  mobileclient
//
//  Created by Benjamin Askren on 10/26/12.
//  Copyright (c) 2012 42nd Parallel. All rights reserved.
//

#import "B3SearchBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation B3SearchBar

#define inset 5

@synthesize customButtonTitle,showsCustomButton;

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initCustomBtn];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder  {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initCustomBtn];
        
    }
    return self;
}


-(void) initCustomBtn {
    customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customBtn.titleLabel.textColor = [UIColor whiteColor];
    
    UIImage *upImg = [[UIImage imageNamed:@"UISearchBarBlackTranslucentButton"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *downImg = [[UIImage imageNamed:@"UISearchBarBlackTranslucentButtonPressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    //[customBtn setImage:upImg forState:UIControlStateNormal];
    //[customBtn setImage:downImg forState:UIControlStateSelected];
    [customBtn setBackgroundImage:upImg forState:UIControlStateNormal];
    [customBtn setBackgroundImage:downImg forState:UIControlStateSelected];
    
    customBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    customBtn.titleLabel.shadowColor = [UIColor lightGrayColor];
    
    [customBtn setContentEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];
    
    
    [self addSubview:customBtn];
}

-(void) setDelegate:(id<B3SearchBarDelegate>)d {
    [super setDelegate:d];
    if ([self.delegate respondsToSelector:@selector(customButtonPressedInSearchBar:)])
        [customBtn addTarget:self.delegate action:@selector(customButtonPressedInSearchBar:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setCustomButtonTitle:(NSString *)title {
    customButtonTitle=title;
    [customBtn setTitle:customButtonTitle forState:UIControlStateNormal];
    [self layoutSubviews];
}

-(void) setShowsCustomButton:(BOOL)show {
    if (show!=showsCustomButton) {
        showsCustomButton = show;
        [self layoutSubviews];
    }
}

BOOL _B3SearchBarLayingOut=NO;

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (_B3SearchBarLayingOut)
        return;
    if (self.showsCancelButton)
        _B3SearchBarLayingOut=YES;
 
    double height = 31 * self.frame.size.height/44.0;
    
    double customButtonWidth = [customBtn.titleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]].width+2*inset;
    
    customBtn.hidden=(height<10);
    
    if (!customButtonTitle || !customButtonTitle.length)
        customButtonWidth = 0;
    
    
    float cancelButtonWidth = 65.0;
    
    UITextField *searchField = nil;
    
    // In iOS 6.1 and earlier, the subviews of a UISearchBar were all of the
    // elements within it
    // As of iOS 7.0, there is only one subview - a UIView elements - whose
    // subviews are all of the elements within the search bar
    if([[[UIDevice currentDevice]systemVersion]floatValue] < 7 && [self.subviews count]>1){
        // Before iOS 7.0
        searchField = [self.subviews objectAtIndex:1];
    } else if ([self.subviews count]==1) {
        // After iOS 7.0
        if ( [self.subviews.firstObject subviews].count > 1 )
            searchField = [[self.subviews.firstObject subviews] objectAtIndex:1];
    }
    
    if ( searchField != nil ) {
        if (self.showsCancelButton == YES) {
            [searchField setFrame:CGRectMake(0, 6, self.frame.size.width - cancelButtonWidth, height)];
            [customBtn setFrame:CGRectMake(-customButtonWidth-20, 6, customButtonWidth, height)];
            [customBtn setHidden:YES];
        } else if (self.showsCustomButton && customButtonWidth>0) {
            [searchField setFrame:CGRectMake(customButtonWidth+10, 6, self.frame.size.width - customButtonWidth - 10, height)];
            [customBtn setFrame:CGRectMake(5, 6, customButtonWidth, height)];
            [customBtn setHidden:NO];
        } else {
            [searchField setFrame:CGRectMake(0, 6, self.frame.size.width, height)];
            [customBtn setFrame:CGRectMake(-customButtonWidth-20, 6, customButtonWidth, height)];
            [customBtn setHidden:YES];
        }
        if (self.showsCancelButton)
            [self performSelector:@selector(layoutDone) withObject:nil afterDelay:0.1];
    }
}

-(void) layoutDone {
    _B3SearchBarLayingOut=NO;
}

@end
