//
//  DFDFollowUpDetailViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDFollowUpDetailViewController.h"
#import "SkinManager.h"
#import "AccountManager.h"
#import "UIView+AutoLayout.h"
#import "FollowUpItem.h"
#import "FollowUpReport.h"
#import "DFDFollowUpReportTableViewCell.h"
#import "DFDFollowUpItemTableViewCell.h"
#import "UIResponder+Router.h"
#import "MWPhotoBrowser.h"
#import "ChatViewController.h"
#import "UINavigationController+CompletionBlock.h"
#import "ContactInfoViewController.h"

@interface DFDFollowUpDetailViewController ()
<
UITableViewDataSource, UITableViewDelegate,
MWPhotoBrowserDelegate
>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) MWPhotoBrowser    *photoBrowser;
@property (nonatomic, assign) BOOL              isBrowseReportImage;
@property (nonatomic, weak)   FollowUpItem      *imageBrowsingFollowUpItem;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation DFDFollowUpDetailViewController

static NSString *FollowUpReportTableViewCellReusedIdentifier = @"27F36154-3452-4DDB-970D-4F8513644593";
static NSString *FollowUpItemTableViewCellReusedIdentifier = @"4EBCD7FE-F0B4-4945-9622-524E5859B0CF";

enum FollowUpReportTableViewSection
{
    Report_Section = 0,
    Items_Section
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
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
    [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
}


#pragma mark - Property

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (Report_Section == section) {
        return 1;
    } else if (Items_Section == section) {
        return self.followUpReport.reportItems.count;
    }
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (Report_Section == indexPath.section) {
        DFDFollowUpReportTableViewCell *reportTableViewCell = (DFDFollowUpReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FollowUpReportTableViewCellReusedIdentifier];
        if (nil == reportTableViewCell) {
            reportTableViewCell = [[DFDFollowUpReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FollowUpReportTableViewCellReusedIdentifier];
        }
        [reportTableViewCell loadFollowUpReport:self.followUpReport];
        cell = reportTableViewCell;
    } else if (Items_Section == indexPath.section) {
        DFDFollowUpItemTableViewCell *itemTableViewCell = (DFDFollowUpItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FollowUpItemTableViewCellReusedIdentifier];
        if (nil == itemTableViewCell) {
            itemTableViewCell = [[DFDFollowUpItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FollowUpItemTableViewCellReusedIdentifier];
        }
        FollowUpItem *followUpItem = [self.followUpReport.reportItems objectAtIndex:indexPath.row];
        [itemTableViewCell loadFollowUpItem:followUpItem];
        cell = itemTableViewCell;
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Report_Section == indexPath.section) {
        return [DFDFollowUpReportTableViewCell cellHeightWithFollowUpReport:self.followUpReport];
    } else if (Items_Section == indexPath.section) {
        FollowUpItem *followUpItem = [self.followUpReport.reportItems objectAtIndex:indexPath.row];
        return [DFDFollowUpItemTableViewCell cellHeightWithFollowUpItem:followUpItem];
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Event

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName isEqualToString:kAvatarClickEvent]) {
        FollowUpReport *report = [userInfo objectForKey:kFollowUpReportKey];
        Patient *patient = report.patient;
        if (patient.userID != kDoctorAssistantID) {
            ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithPatient:patient];
            [self.navigationController pushViewController:infoViewController animated:YES];
        }
    } else if ([eventName isEqualToString:kFollowUpItemThumbnailImageClickedEvent]) {
        self.isBrowseReportImage = NO;
        NSNumber *imageIndexNumber = [userInfo objectForKey:kImageIndexKey];
        UITableViewCell *cell = [userInfo objectForKey:kFollowUpItemTableViewCellKey];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        self.imageBrowsingFollowUpItem = [self.followUpReport.reportItems objectAtIndex:indexPath.row];
        
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
    } else if ([eventName isEqualToString:kReplyButtonClickedEvent]) {
        FollowUpItem *followUpItem = [userInfo objectForKey:kFollowUpItemKey];
        followUpItem.isReceived = YES;
        UITableViewCell *cell = [userInfo objectForKey:kFollowUpItemTableViewCellKey];
        __block NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        ChatViewController *chatViewController = [[ChatViewController alloc] initWithUserID:self.followUpReport.patient.userID];
        [self.navigationController pushViewController:chatViewController animated:YES withCompletionBlock:^{
            UITableViewCell *cell = [userInfo objectForKey:kFollowUpItemTableViewCellKey];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            FollowUpItem *followUpItem = [self.followUpReport.reportItems objectAtIndex:indexPath.row];
            NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
            //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [chatViewController sendTextMessage:[NSString stringWithFormat:@"医生已经阅读你的报告，报告提交时间为：%@", [dateFormatter stringFromDate:followUpItem.createTime]]];
        }];
        
        [[AccountManager sharedInstance] asyncReceiveFollowUpItemWithItemID:followUpItem.itemID withCompletionHandler:^(FollowUpItem *followUpItem) {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            BOOL oldReportReceiveStatus = self.followUpReport.isReceive;
            BOOL isReportReceived = NO;
            for (FollowUpItem *item in self.followUpReport.reportItems) {
                if (item.isReceived) {
                    isReportReceived = YES;
                } else {
                    break;
                }
            }
            self.followUpReport.isReceive = isReportReceived;
            indexPath = [NSIndexPath indexPathForItem:0 inSection:Report_Section];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            if (oldReportReceiveStatus != self.followUpReport.isReceive) {
                if ([self.delegate respondsToSelector:@selector(followUpDetailViewController:didChangedFollowUpReportStatus:)]) {
                    [self.delegate followUpDetailViewController:self didChangedFollowUpReportStatus:self.followUpReport];
                }
            }
        } withErrorHandler:^(NSError *error) {
            
        }];
    } else if ([eventName isEqualToString:kFollowUpReportThumbnailImageClickedEvent]) {
        self.isBrowseReportImage = YES;
        NSNumber *imageIndexNumber = [userInfo objectForKey:kImageIndexKey];
        
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
        [super routerEventWithName:eventName userInfo:userInfo];
    }
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    if (self.isBrowseReportImage) {
        return self.followUpReport.imagesCount;
    }
    return [self.imageBrowsingFollowUpItem.imagesURLStrings count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (self.isBrowseReportImage) {
        if (index < self.followUpReport.imagesCount) {
            NSString *imageURLString = [self.followUpReport.imagesURLStrings objectAtIndex:index];
            return [MWPhoto photoWithURL:[NSURL URLWithString:imageURLString]];
        }
    } else {
        if (index < self.imageBrowsingFollowUpItem.imagesURLStrings.count) {
            NSString *imageURLString = [self.imageBrowsingFollowUpItem.imagesURLStrings objectAtIndex:index];
            return [MWPhoto photoWithURL:[NSURL URLWithString:imageURLString]];
        }
    }
    return nil;
}

@end
