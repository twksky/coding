//
//  DFDUrgentCallController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/20.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DFDUrgentCallController.h"
#import "UIView+AutoLayout.h"
#import "UrgentCallInfo.h"
#import "AccountManager.h"
#import "DFDUrgentCallCell.h"
#import "UIResponder+Router.h"
#import "ContactInfoViewController.h"
#import <MWPhotoBrowser.h>

@interface DFDUrgentCallController ()
<
UITableViewDelegate,
UITableViewDataSource,
DFDUrgentCallCellDelegate,
MWPhotoBrowserDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *urgentCallList;

@property (nonatomic, strong) UrgentCallInfo *selectedUrgentCallInfo;

@end

@implementation DFDUrgentCallController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    [self setNavigationBarWithTitle:@"紧急呼叫查看" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncGetUrgentCallListWithCompletionHandler:^(NSArray *urgentCallList) {
        [self dismissLoading];
        
        self.urgentCallList = [NSMutableArray arrayWithArray:urgentCallList];
        [self.tableView reloadData];
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        [self showHint:[error localizedDescription]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - router event 

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName isEqualToString:kUgentCallBtnClickEvent]) {
        UITableViewCell *cell = [userInfo objectForKey:kUrgentCallCell];
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
            
            [self showHint:[error localizedDescription]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else if ([eventName isEqualToString:kUserIconClickEvent]) {
        
        UITableViewCell *cell = [userInfo objectForKey:kUserIconClickEvent];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UrgentCallInfo *info = [self.urgentCallList objectAtIndex:indexPath.row];
        Patient *patient = info.patient;
        if (patient.userID != kDoctorAssistantID) {
            
            ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithPatient:patient];
            [self.navigationController pushViewController:infoViewController animated:YES];
        }
    }
    else if ([eventName isEqualToString:kUrgentCallCellDetailImageClickEvent]) {
        
        NSNumber *imageIndexNumber = [userInfo objectForKey:kUrgentCallCellImageIndexKey];
        self.selectedUrgentCallInfo = [userInfo objectForKey:kUrgentCallCellInfoKey];
        
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
    }
    else {
        [self.nextResponder routerEventWithName:eventName userInfo:userInfo];
    }
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.urgentCallList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UrgentCallInfo *urgentCallInfo = [self.urgentCallList objectAtIndex:indexPath.row];
    
    static NSString *reusedCellIdentifier = @"6954d683-78c2-485c-83c0-5f001bd7dfe0";
    DFDUrgentCallCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellIdentifier];
    if (!cell) {
        
        cell = [[DFDUrgentCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellIdentifier];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    [cell loadUrgentCallInfo:urgentCallInfo];
    
    return cell;
    
}


#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UrgentCallInfo *urgentCallInfo = [self.urgentCallList objectAtIndex:indexPath.row];
    return [DFDUrgentCallCell cellHeightWithUrgentCallInfo:urgentCallInfo];
    
}

#pragma mark - DFDUrgentCallCellDelegate Methods

- (void)reloadCellAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

- (void)changeExpandStateWithIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded {
    
    UrgentCallInfo *urgentCallInfo = [self.urgentCallList objectAtIndex:indexPath.row];
    urgentCallInfo.isExpanded = isExpanded;
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


#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (NSMutableArray *)urgentCallList {
    
    if (!_urgentCallList) {
        
        _urgentCallList = [[NSMutableArray alloc] init];
    }
    
    return _urgentCallList;
}

@end




















