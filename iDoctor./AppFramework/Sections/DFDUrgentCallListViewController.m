//
//  DFDUrgentCallListViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDUrgentCallListViewController.h"
#import "SkinManager.h"
#import "AccountManager.h"
#import "DFDUrgentCallListTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "UIImageView+WebCache.h"
#import "ManagerUtil.h"
#import "UIResponder+Router.h"
#import "ContactInfoViewController.h"
#import "MWPhotoBrowser.h"
#import "MBProgressHUD.h"

@interface DFDUrgentCallListViewController ()
<
UITableViewDataSource, UITableViewDelegate,
MWPhotoBrowserDelegate
>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray       *urgentCallList;
@property (nonatomic, weak)   UrgentCallInfo        *selectedUrgentCallInfo;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation DFDUrgentCallListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"紧急呼叫查看";
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    [[AccountManager sharedInstance] asyncGetUrgentCallListWithCompletionHandler:^(NSArray *urgentCallList) {
        self.urgentCallList = [NSMutableArray arrayWithArray:urgentCallList];
        [self.tableView reloadData];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Method

- (void)setupSubviews
{
    [self.view addSubview:self.tableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    // Autolayout
    [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
}


#pragma mark - Property

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)urgentCallList
{
    if (nil == _urgentCallList) {
        _urgentCallList = [[NSMutableArray alloc] init];
    }
    return _urgentCallList;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.urgentCallList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedIdentity = @"680172D1-E48F-4027-944D-853B5C0DCFE6";
    DFDUrgentCallListTableViewCell *urgentCallCell = (DFDUrgentCallListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reusedIdentity];
    if (nil == urgentCallCell) {
        urgentCallCell = [[DFDUrgentCallListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIdentity];
    }
    
    UrgentCallInfo *info = [self.urgentCallList objectAtIndex:indexPath.row];
    [urgentCallCell loadUrgentCallInfo:info];
    
    return urgentCallCell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrgentCallInfo *info = [self.urgentCallList objectAtIndex:indexPath.row];
    return [DFDUrgentCallListTableViewCell cellHeightWithUrgentCallInfo:info];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Event

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName isEqualToString:kCallButtonClickEvent]) {
        UITableViewCell *cell = [userInfo objectForKey:kTableViewCell];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UrgentCallInfo *info = [self.urgentCallList objectAtIndex:indexPath.row];
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.labelText = @"请稍候...";
        [[AccountManager sharedInstance] asyncAcceptUrgentCall:info.callID withCompletionHandler:^(UrgentCallInfo *urgentCallInfo) {
            for (NSInteger index = 0; index < self.urgentCallList.count; index++) {
                UrgentCallInfo *info = [self.urgentCallList objectAtIndex:index];
                if (info.callID == urgentCallInfo.callID) {
                    self.urgentCallList[index] = urgentCallInfo;
                    [self.tableView beginUpdates];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                    break;
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请等待4008105790免费电话的回呼" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alertView show];
        } withErrorHandler:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } else if ([eventName isEqualToString:kAvatarClickEvent]) {
        UITableViewCell *cell = [userInfo objectForKey:kTableViewCell];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UrgentCallInfo *info = [self.urgentCallList objectAtIndex:indexPath.row];
        Patient *patient = info.patient;
        if (patient.userID != kDoctorAssistantID) {
            ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithPatient:patient];
            [self.navigationController pushViewController:infoViewController animated:YES];
        }
    } else if ([eventName isEqualToString:kUrgentCallInfoThumbnailImageClickedEvent]) {
        NSNumber *imageIndexNumber = [userInfo objectForKey:kImageIndexKey];
        self.selectedUrgentCallInfo = [userInfo objectForKey:kUrgentCallInfoKey];
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        // Set options
        browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        browser.wantsFullScreenLayout = YES; // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
        
        // Optionally set the current visible photo before displaying
        [browser setCurrentPhotoIndex:[imageIndexNumber integerValue]];
        
        // Present
        [self.navigationController pushViewController:browser animated:YES];
    } else {
        [self.nextResponder routerEventWithName:eventName userInfo:userInfo];
    }
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.selectedUrgentCallInfo.imagesURLStrings count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.selectedUrgentCallInfo.imagesCount) {
        NSString *imageURLString = [self.selectedUrgentCallInfo.imagesURLStrings objectAtIndex:index];
        return [MWPhoto photoWithURL:[NSURL URLWithString:imageURLString]];
    }
    return nil;
}

@end
