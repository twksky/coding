//
//  ContactDetailInfoViewController.m
//  AppFramework
//
//  Created by ABC on 8/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ContactDetailInfoViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "CaseHistoryInfoTableViewCell.h"
#import "AccountManager.h"
#import "MWPhotoBrowser.h"
#import "GGFullscreenImageViewController.h"

@interface ContactDetailInfoViewController ()
<
UITableViewDataSource, UITableViewDelegate,
CaseHistoryInfoTableViewCellDelegate,
MWPhotoBrowserDelegate
>

@property (nonatomic, strong) UITableView       *contentTableView;
@property (nonatomic, strong) MedicalRecord     *medicalRecordCopy;
@property (nonatomic, strong) MWPhotoBrowser    *photoBrowser;
@property (nonatomic, strong) UINavigationController *photoNavigationController;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation ContactDetailInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"详情";
    }
    return self;
}

- (id)initWithMedicalRecord:(MedicalRecord *)medicalRecordData
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[AccountManager sharedInstance] asyncGetMedicalRecordWithID:medicalRecordData.recordID withCompletionHandler:^(MedicalRecord *medicalRecord) {
            self.medicalRecordCopy = medicalRecord;
            [self.contentTableView beginUpdates];
            NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
            [self.contentTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.contentTableView endUpdates];
        } withErrorHandler:^(NSError *error) {
            
        }];
        
    }
    return self;
}

- (id)initWithMedicalRecordID:(NSInteger)medicalRecordID
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[AccountManager sharedInstance] asyncGetMedicalRecordWithID:medicalRecordID withCompletionHandler:^(MedicalRecord *medicalRecord) {
            self.medicalRecordCopy = medicalRecord;
            [self.contentTableView beginUpdates];
            NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
            [self.contentTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.contentTableView endUpdates];
        } withErrorHandler:^(NSError *error) {
            
        }];
    }
    return self;
}

- (void)viewDidLoad
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Property

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
    }
    return _contentTableView;
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

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraints:[self.contentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReusableCellIdentifier = @"8CF5A73B-CF14-456C-8F85-ED7010B97B51";
    CaseHistoryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReusableCellIdentifier];
    if (!cell) {
        cell = [[CaseHistoryInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.delegate = self;
    }
    if (self.medicalRecordCopy) {
        [cell setMedicalRecord:self.medicalRecordCopy];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CaseHistoryInfoTableViewCell defaultCellHeightWithMedicalRecord:self.medicalRecordCopy];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - CaseHistoryInfoTableViewCellDelegate

- (void)caseHistoryInfoTableViewCell:(CaseHistoryInfoTableViewCell *)cell didSelectMedicalRecordImageIndex:(NSInteger)index withImageView:(UIImageView *)imageView withMedicalRecord:(MedicalRecord *)medicalRecord
{
    //[self.navigationController presentViewController:self.photoNavigationController animated:YES completion:nil];
    /*
    GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
    vc.liftedImageView = imageView;
    [self presentViewController:vc animated:YES completion:nil];
     */
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
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
    [browser setCurrentPhotoIndex:index];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.medicalRecordCopy.imagesURLs count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.medicalRecordCopy.imagesURLs.count) {
        NSString *imageURLString = [self.medicalRecordCopy.imagesURLs objectAtIndex:index];
        return [MWPhoto photoWithURL:[NSURL URLWithString:imageURLString]];
    }
    return nil;
}
@end
