//
//  VVMediaListViewController.m

//
//  Created by Benjamin Askren on 9/20/12.
//  Copyright (c) 2012 Benjamin Askren. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "AppDelegate.h"
#import "VVMediaListViewController.h"
#import "VVMediaCell.h"
#import "Utils.h"
#import "iToast.h"
#import "PRPAlertView.h"

#import "UIImageView+WebCache.h"
#import <EventKit/EventKit.h>
#import "MBProgressHUD.h"

#define API_KEY @"<your api key>"

#define kRowHeight 110.0
#define kNoResultsRowHeight 424.0
#define kResultsPerPage 20

iToast *_VVMediaListViewControllerToast=nil;
CGRect _VVMediaListViewControllerHeaderFrame;
BOOL _VVMediaListViewFreshLoad=YES;
UIView *navBarTapView;

@interface VVMediaListViewController () {
    NSString *siteSlug;
    NSTimer *searchTimer;
    
    VVCMSAPI *api;
    IBOutlet B3SearchBar *searchBar;
    IBOutlet UISegmentedControl *filterSegmentControl;
    NSDate *fromDate, *toDate;
    VVCMSBroadcastStatus lastStatusRequested;
    int currPage,numPages,numResults;
    BOOL virginloading,_loading;
    int lastSelectedIndex;
    
    IBOutlet UITableView *tv;
    UIActivityIndicatorView *footerSpinner;
    AppDelegate *appDelegate;
    BOOL visible;
    NSTimer* myTimer;
    UIButton *backButton;
    
    UIImage *audioImage,*schedImage,*liveImage,*archImage;
    
    NSString *userName,*password;
    
    VVSectionPickerViewController *svc;
    VVDatePickerViewController *dpc;
    NSMutableArray *sections;
}

@property (nonatomic, strong) NSMutableArray *broadcasts;
@property (nonatomic, strong) VVMoviePlayerViewController *moviePlayer;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segCtrl;
@property(nonatomic, strong) UIPopoverController *svpovc, *dpcovc;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation VVMediaListViewController

@synthesize broadcasts,moviePlayer,svpovc,dpcovc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        api = [[VVCMSAPI alloc] initWithDomain:@"vcloud.volarvideo.com" apiKey:API_KEY];
//        api = [[VVCMSAPI alloc] initWithDomain:@"vcloud.volarvideo.com" username:@"john.doe@test.com" password:@"password"];
        
        virginloading = YES;
        _loading = NO;
        _VVMediaListViewFreshLoad=YES;
        lastSelectedIndex=-1;
        currPage=0;
        numPages=0;
        numResults=0;
        sections = [[NSMutableArray alloc] initWithCapacity:5];
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        fromDate=nil;
        toDate=nil;
        _segCtrl.selectedSegmentIndex = 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    tv.rowHeight = kRowHeight;
    tv.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Folder Wallpaper.JPG"]];
    tv.dataSource = self;
    
    UIButton *imgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 74.0, 27.0)];
    [imgButton setBackgroundImage:[UIImage imageNamed:@"app_logo"] forState:UIControlStateNormal];
    UIBarButtonItem *sourceButton = [[UIBarButtonItem alloc] initWithCustomView:imgButton];
    self.navigationItem.rightBarButtonItem = sourceButton;
	 
    [self makeRefreshButton];
    
    searchBar.barStyle = UIBarStyleBlackTranslucent;
    searchBar.showsCustomButton=NO;
    
    tv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    audioImage = [UIImage imageNamed:@"iconGenericAudio"];
    schedImage = [UIImage imageNamed:@"scheduledBroadcast"];
    liveImage = [UIImage imageNamed:@"iconLiveBroadcast"];
    archImage = [UIImage imageNamed:@"iconGenericVideo"];
    
    footerSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    // Thank god for Stack Overflow:
    // http://stackoverflow.com/questions/19081697/ios-7-navigation-bar-hiding-content
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
        self.edgesForExtendedLayout = UIRectEdgeNone; //layout adjustements
    }
    
    _segCtrl.selectedSegmentIndex=2;
    [self getSections:1];
    [self getBroadcasts:1 status:VVCMSBroadcastStatusArchived];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBarHidden)
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void) refreshButtonPress {
    [self reload];
}

-(void) makeRefreshButton {
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 22.0)];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"UIButtonBarRefresh"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = refreshBarButtonItem;
}

-(void) popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    broadcasts=nil;
}


BOOL _VVMediaListViewControllerLastReachableTestResult;
BOOL _VVMediaListViewControllerWaitingForReachabilityResult;
dispatch_queue_t _VVMediaListViewControllerBackgroundQueue;

-(void) viewDidAppear:(BOOL)animated {
    visible=YES;
    
	if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    }

}

-(void) dealloc {
    moviePlayer=nil;
}

-(void) viewWillDisappear:(BOOL)animated {
    [self performSelector:@selector(tellSuperThatViewWillDisappear) withObject:nil afterDelay:0.1];
    [myTimer invalidate];
    
    if (filterSegmentControl.selectedSegmentIndex != -1) {
        if (svpovc || svc)
            [self doneWithVVPickerViewController:svc];
        if (dpcovc || dpc)
            [self doneWithVVDatePicker:dpc];
    }
}

-(void) tellSuperThatViewWillDisappear {
    [super viewWillDisappear:YES];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    visible=NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void) setBackButtonOrientation:(UIInterfaceOrientation) orientation {    
    CGRect frame = backButton.frame;
    if (UI_USER_INTERFACE_IDIOM()!= UIUserInterfaceIdiomPad && UIInterfaceOrientationIsLandscape(orientation)) {
        [backButton setBackgroundImage:[[UIImage imageNamed:@"UINavigationBarMiniBlackOpaqueBack"] stretchableImageWithLeftCapWidth:11 topCapHeight:5] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[[UIImage imageNamed:@"UINavigationBarMiniBlackOpaqueBackPressed"] stretchableImageWithLeftCapWidth:11 topCapHeight:5] forState:UIControlStateSelected];
        frame.size.height= 24;
    } else {
        [backButton setBackgroundImage:[[UIImage imageNamed:@"UINavigationBarBlackOpaqueBack"] stretchableImageWithLeftCapWidth:15 topCapHeight:5] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[[UIImage imageNamed:@"UINavigationBarBlackOpaqueBackPressed"] stretchableImageWithLeftCapWidth:15 topCapHeight:5] forState:UIControlStateSelected];
        frame.size.height=31;
    }
    backButton.frame=frame;
    UIBarButtonItem *sourceButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = sourceButton;
}

CGPoint _VVMediaListViewControllerPointBeforeRotate;


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _VVMediaListViewControllerPointBeforeRotate = CGPointMake(tv.contentOffset.x, tv.contentOffset.y);
    tv.contentOffset = _VVMediaListViewControllerPointBeforeRotate;
    tv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    searchBar.hidden=YES;
    [self setBackButtonOrientation:toInterfaceOrientation];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    tv.contentOffset = _VVMediaListViewControllerPointBeforeRotate;
    searchBar.hidden=NO;
}

-(void) getBroadcasts:(int)page {
    VVCMSBroadcastStatus status;
    if (_segCtrl.selectedSegmentIndex == 0)
        status = VVCMSBroadcastStatusScheduled;
    else if (_segCtrl.selectedSegmentIndex == 1)
        status = VVCMSBroadcastStatusStreaming;
    else
        status = VVCMSBroadcastStatusArchived;
    [self getBroadcasts:page status:status];
}

-(void) getBroadcasts:(int)page status:(VVCMSBroadcastStatus)status {
    currPage = page;
    [self setLoading:YES];
    
    lastStatusRequested = status;
    BroadcastParams *params = [[BroadcastParams alloc] init];
    if (searchBar.text)
        params.title = searchBar.text;
    params.sites = siteSlug;
    params.status = status;
    if ([svc selectedSection])
        params.sectionID = [svc selectedSection].ID;
    if (fromDate)
        params.after = fromDate;
    if (toDate)
        params.before = toDate;
    params.page = [[NSNumber alloc] initWithInt:page];
    params.resultsPerPage = [[NSNumber alloc] initWithInt:kResultsPerPage];
    [api requestBroadcasts:params usingDelegate:self];
}

-(void) getSections:(int)page {
    SectionParams *params = [[SectionParams alloc] init];
    params.sites = siteSlug;
    params.page = [[NSNumber alloc] initWithInt:page];
    params.resultsPerPage = [[NSNumber alloc] initWithInt:kResultsPerPage];
    [api requestSections:params usingDelegate:self];
}

- (void)VVCMSAPI:(VVCMSAPI *)vvapi requestForSectionsResult:(NSArray *)results page:(int)page
      totalPages:(int)totalPages totalResults:(int)totalResults error:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (error) {
            return;
        }
        
        if (page == 1)
            [sections removeAllObjects];
        [sections addObjectsFromArray:results];
        
        if (page+1 <= totalPages) {
            [self getSections:page+1];
        }
    });
}

- (void)VVCMSAPI:(VVCMSAPI *)vvapi requestForBroadcastsResult:(NSArray *)events
      withStatus:(VVCMSBroadcastStatus)status page:(int)page totalPages:(int)totalPages
    totalResults:(int)totalResults error:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.spinner.hidden=YES;
        [self.spinner stopAnimating];
        virginloading=NO;
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Problem" message:[error.userInfo objectForKey:kKeyErrorMessage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        if (!error && ![events isKindOfClass:[NSNull class]]) {
            [self setpuBroadcasts:events status:status page:page totalPages:totalPages totalResults:totalResults];
        } else {
            [broadcasts removeAllObjects];
            [tv reloadData];
        }
        
        [self setLoading:NO];
        [self checkBroadcastPagination];
    });
}

-(void) setpuBroadcasts:(NSArray*)b status:(VVCMSBroadcastStatus)status page:(int)page totalPages:(int)totalPages totalResults:(int)totalResults {
    numPages = totalPages;
    numResults = totalResults;
    
    if (page == 1) {
        broadcasts = [b mutableCopy];
    }
    else {
        [broadcasts addObjectsFromArray:b];
    }
    
    [_segCtrl setTitle:@"Upcoming" forSegmentAtIndex:0];
    [_segCtrl setTitle:@"Live" forSegmentAtIndex:1];
    [_segCtrl setTitle:@"Archived" forSegmentAtIndex:2];
    
    if (_segCtrl.selectedSegmentIndex==0) {
        [_segCtrl setTitle:[NSString stringWithFormat:@"Upcoming (%d)",totalResults] forSegmentAtIndex:0];
    } else if (_segCtrl.selectedSegmentIndex==1) {
        [_segCtrl setTitle:[NSString stringWithFormat:@"Live (%d)",totalResults] forSegmentAtIndex:1];
    } else if (_segCtrl.selectedSegmentIndex==2) {
        [_segCtrl setTitle:[NSString stringWithFormat:@"Archived (%d)",totalResults] forSegmentAtIndex:2];
    }

    [tv reloadData];
}

- (void) reload {
    self.spinner.hidden=NO;
    [self.spinner startAnimating];
    [self getBroadcasts:1];
}

- (void) refreshVisibleCells {
    NSArray *visCells = [tv indexPathsForVisibleRows];
    [tv reloadRowsAtIndexPaths:visCells withRowAnimation:UITableViewRowAnimationNone];
}

BOOL _VVMediaListDragging=NO;


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _VVMediaListDragging=NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _VVMediaListDragging=YES;
}

-(void) setLoading:(BOOL)l {
    _loading = l;
    
    if (l && currPage > 1) {
        tv.tableFooterView = footerSpinner;
        [footerSpinner startAnimating];
    }
    else {
        [footerSpinner stopAnimating];
        tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_VVMediaListDragging) {
        if (scrollView.contentOffset.y<10)
            [tv setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        else if (scrollView.contentOffset.y>44)
            [tv setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [self checkBroadcastPagination];
}

-(void) checkBroadcastPagination {
    NSArray *visCells = [tv indexPathsForVisibleRows];
    if (visCells.count) {
        NSIndexPath *firstPath = [visCells objectAtIndex:0];
        if (!_loading && (broadcasts.count-visCells.count) <= (firstPath.row+kResultsPerPage)) {
            if (currPage+1 <= numPages) {
                [self getBroadcasts:currPage+1 status:lastStatusRequested];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [broadcasts count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"mediaCell";
    VVMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VVMediaCell" owner:self options:nil];
        cell = (VVMediaCell *)[nib objectAtIndex:0];
        cell.backgroundView = [[UIImageView alloc] init];
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"Cell Wallpaper.JPG"];
    }

    if (!broadcasts || [broadcasts isKindOfClass:[NSNull class]])
        return cell;
    VVCMSBroadcast *broadcast = [broadcasts objectAtIndex:indexPath.row];

    
    cell.disabled=NO;
    cell.tag = indexPath.row;
    cell.type = VVMediaCellTypeBroadcast;
    
    if (broadcast.title && ![broadcast.title isKindOfClass:[NSNull class]])
        cell.title = broadcast.title;
    else
        cell.title = @"";
    
    if (broadcast.description && ![broadcast.description isKindOfClass:[NSNull class]])
        cell.description = broadcast.description;
    else
        cell.description = @"";
    
    NSDate *itemDate = broadcast.startDate;
    if (itemDate)
        cell.meta1 = [Utils stringFromDate:itemDate withFormat:@"M-d-yy"];
    else
        cell.meta1 = nil;
    
    switch (broadcast.status) {
    case VVCMSBroadcastStatusStopped:
    case VVCMSBroadcastStatusStreaming:
        if (broadcast.isStreaming) {
            cell.meta2 = @"streaming";
        }
        else {
            cell.meta2 = @"stopped";
        }
        break;
    default:
        cell.meta2 = nil;
        break;
    }
    
    UIImage *placeholder;
    if (broadcast.audioOnly)
        placeholder = audioImage;
    else if (_segCtrl.selectedSegmentIndex==0)
        placeholder = schedImage;
    else if (_segCtrl.selectedSegmentIndex==1) {
        if (broadcast.isStreaming)
            placeholder = liveImage;
        else
            placeholder = archImage;
    }
    else if (_segCtrl.selectedSegmentIndex==2)
        placeholder = archImage;
    
    if (broadcast.thumbnailURL && ![broadcast.thumbnailURL isEqual:[NSNull null]] && ![broadcast.thumbnailURL isEqualToString:@""] ) {
        [cell.imgThumb setImageWithURL:[NSURL URLWithString:broadcast.thumbnailURL]placeholderImage:placeholder];
    } else {
        [cell.imgThumb setImage:placeholder];
    }

    cell.read = YES;
    cell.favorite = NO;
    return cell;
}

VVCMSBroadcast *_VVMediaListViewSelectedBroadcast;

-(void) delayedStartVMAP:(NSString*)vmapString {
    moviePlayer = nil;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidChange:) name:VVVmapPlayerDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    moviePlayer = [[VVMoviePlayerViewController alloc] initWithExtendedVMAPURIString:vmapString withAPI:api];
    if (!self.moviePlayer) {
        [self hideHUD];
    }
}

-(void) dismissActiveMoviePlayer {
    if (moviePlayer)
        [appDelegate.navController dismissViewControllerAnimated:NO completion:nil];
    moviePlayer=nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (filterSegmentControl.selectedSegmentIndex != -1) {
        if (svpovc || svc)
            [self doneWithVVPickerViewController:svc];
        if (dpcovc || dpc)
            [self doneWithVVDatePicker:dpc];
    }
    [self showHUD];
    NSDictionary *objects = @{@"tableView":tableView, @"indexPath":indexPath};
    [self performSelector:@selector(didSelectRowAtIndexPath:) withObject:objects afterDelay:0.1];
}

- (void) didSelectRowAtIndexPath:(NSDictionary *)objects {
    NSIndexPath *indexPath = [objects objectForKey:@"indexPath"];
    VVCMSBroadcast *bcast = [broadcasts objectAtIndex:indexPath.row];
    _VVMediaListViewSelectedBroadcast = bcast;
    [self delayedStartVMAP:bcast.vmapURL];
}

-(void) playerDidChange:(NSNotification*)notification {
    // Movie player changed and is ready to play
    if ([moviePlayer.moviePlayer loadState] == MPMovieLoadStatePlayable) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:VVVmapPlayerDidChangeNotification object:nil];
        
        // Hide hud and push view controller
        [self hideHUD];
        [appDelegate.navController presentViewController:moviePlayer animated:YES completion:nil];
    }
}

-(void) playbackFinished:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)s {
    [s resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)s{
    [s resignFirstResponder];
    if ([s.text length] > 0) {
        [s setText:@""];

        // If you change the text, you would think it would spark
        // a UITextFieldTextDidChangeNotification. Nope.
        [self searchBar:s textDidChange:s.text];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchTimer invalidate];
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(doDelayedSearch:)
                                                 userInfo:searchText
                                                  repeats:NO];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)sb {
    sb.showsCancelButton=YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)sb {
    sb.showsCancelButton=NO;
}

-(void)doDelayedSearch:(NSTimer *)t {
    assert(t == searchTimer);
    searchTimer = nil;
    [self getBroadcasts:1];
}

MBProgressHUD *progressHUD;

- (void)showHUD {
    [self showHUDWithMessage:@"Loading..."];
}

- (void)showHUDWithMessage:(NSString *) msg {
    UIView *theView = self.view;
    progressHUD = [MBProgressHUD showHUDAddedTo:theView animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = msg;
}

- (void)hideHUD {
    [progressHUD hide:YES];
}

-(IBAction) filterSegmentValueChanged:(id)sender {
    if (sender==filterSegmentControl) {
        switch(filterSegmentControl.selectedSegmentIndex) {
            case 0: // From Date
            case 1: // To Date
                [self displayDatePicker];
                break;
            case 2: // Section
                [self displaySectionPicker];
                break;
        }
    }
    else if (sender==_segCtrl) {
        self.spinner.hidden=NO;
        [self.spinner startAnimating];
        [self getBroadcasts:1];
    }
}

-(void) doneWithVVPickerViewController:(VVSectionPickerViewController *)vvPCV {
    if (vvPCV==svc) {
        if (![svc selectedSection]) {
            [filterSegmentControl setTitle:@"Section" forSegmentAtIndex:2];
        } else
            [filterSegmentControl setTitle:svc.selectedSection.title forSegmentAtIndex:2];
        [self getBroadcasts:1];
        filterSegmentControl.selectedSegmentIndex=-1;
        [self retractSectionPicker];
    }
}

-(void) displaySectionPicker {
	CGRect keypadFrame;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        keypadFrame = CGRectMake(0, 0, 320, 260);
        if (svc==nil) {
            svc = [[VVSectionPickerViewController alloc] initWithNibName:nil bundle:nil];
            svc.contentSizeForViewInPopover = keypadFrame.size;
        }
        if (svpovc==nil) {
            svpovc = [[UIPopoverController alloc] initWithContentViewController:svc];
            if (svpovc)
                svpovc.delegate = self;
        }
    } else {
        keypadFrame = CGRectMake(0, self.view.frame.size.height,320, 260);
        if (svc==nil) {
            svc = [[VVSectionPickerViewController alloc] initWithNibName:nil bundle:nil];
            [self.view.window addSubview:svc.view];
        }
    }
    svc.sections = [NSArray arrayWithArray:sections];
    svc.viewDelegate = self;
    [svc.pv reloadAllComponents];
    
    svc.view.hidden = NO;
	svc.view.frame = keypadFrame;
	
	[UIView beginAnimations:@"PresentKeypad" context:nil];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        svpovc.passthroughViews = nil;
        CGRect rect = [self popOverFrame];
        UIPopoverArrowDirection dir = UIPopoverArrowDirectionDown | UIPopoverArrowDirectionUp;
        [svpovc presentPopoverFromRect:rect inView:self.view permittedArrowDirections:dir animated:YES];
    } else {
        keypadFrame = CGRectMake(0, self.view.window.frame.size.height-260, 320, 260);
        svc.view.frame = keypadFrame;
        tv.contentInset = UIEdgeInsetsMake(0, 0, 224, 0);
    }

	[UIView commitAnimations];
}

-(void) retractSectionPicker {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [svpovc dismissPopoverAnimated:YES];
    } else {
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];

        CGRect keypadFrame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
        svc.view.frame = keypadFrame;
        tv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

        [UIView commitAnimations];
    }
	svc.view.hidden = YES;
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)pc {
    filterSegmentControl.selectedSegmentIndex=-1;
}

-(void) displayDatePicker {
    CGRect keypadFrame;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        keypadFrame = CGRectMake(0, 0, 320, 260);
        if (dpc==nil) {
            dpc = [[VVDatePickerViewController alloc] initWithNibName:nil bundle:nil];
            dpc.contentSizeForViewInPopover = keypadFrame.size;
        }
        if (dpcovc==nil) {
            dpcovc = [[UIPopoverController alloc] initWithContentViewController:dpc];
            if (dpcovc) dpcovc.delegate = self;
        }
    } else {
        keypadFrame = CGRectMake(0, self.view.frame.size.height,320, 260);
        if (dpc==nil) {
            dpc = [[VVDatePickerViewController alloc] initWithNibName:nil bundle:nil];
            [self.view.window addSubview:dpc.view];
        }
    }
    dpc.view.hidden=NO;
    dpc.delegate=self;
    dpc.view.frame=keypadFrame;

	[UIView beginAnimations:@"PresentKeypad" context:nil];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        dpcovc.passthroughViews = nil;
        CGRect rect = [self popOverFrame];
        UIPopoverArrowDirection dir = UIPopoverArrowDirectionDown | UIPopoverArrowDirectionUp;
        [dpcovc presentPopoverFromRect:rect inView:self.view permittedArrowDirections:dir animated:YES];
    } else {
        keypadFrame = CGRectMake(0, self.view.window.frame.size.height-260, 320, 260);
        dpc.view.frame = keypadFrame;
        tv.contentInset = UIEdgeInsetsMake(0, 0, 224, 0);
    }

	[UIView commitAnimations];

}

-(CGRect) popOverFrame {
    float x = filterSegmentControl.frame.origin.x+filterSegmentControl.frame.size.width*((float)filterSegmentControl.selectedSegmentIndex)/((float)filterSegmentControl.numberOfSegments);
    float y = filterSegmentControl.frame.origin.y;
    float w = filterSegmentControl.frame.size.width/((float)filterSegmentControl.numberOfSegments);
    float h = filterSegmentControl.frame.size.height;
    return CGRectMake(x, y, w, h);
    
}

-(void) doneWithVVDatePicker:(VVDatePickerViewController *)dpvc {
    if (dpc==dpvc) {
        NSString *dateString = [self stringFromDate:dpc.dp.date withFormat:@"MM/dd/yy"];
        if (filterSegmentControl.selectedSegmentIndex==0) {
            fromDate = dpc.dp.date;
            [filterSegmentControl setTitle:dateString forSegmentAtIndex:0];
        } else {
            toDate = dpc.dp.date;
            [filterSegmentControl setTitle:dateString forSegmentAtIndex:1];
        }
        [self getBroadcasts:1];
        filterSegmentControl.selectedSegmentIndex=-1;
        [self retractDatePicker];
    }
}

-(void) clearCalledFromVVDatePicker:(VVDatePickerViewController*)dpvc {
    if (dpc==dpvc) {
        if (filterSegmentControl.selectedSegmentIndex==0) {
            fromDate=nil;
            [filterSegmentControl setTitle:@"From Date" forSegmentAtIndex:0];
        } else {
            toDate=nil;
            [filterSegmentControl setTitle:@"To Date" forSegmentAtIndex:1];
        }
        [self getBroadcasts:1];
        filterSegmentControl.selectedSegmentIndex=-1;
        [self retractDatePicker];
    }
}

-(void) retractDatePicker {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [dpcovc dismissPopoverAnimated:YES];
    } else {
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];

        CGRect keypadFrame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
        dpc.view.frame = keypadFrame;
        tv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

        [UIView commitAnimations];
    }
	dpc.view.hidden = YES;
}

- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	[outputFormatter setTimeZone:[NSTimeZone localTimeZone]];			//display time in local time zone
	NSString *timestamp_str = [outputFormatter stringFromDate:date];
	return timestamp_str;
}
@end
