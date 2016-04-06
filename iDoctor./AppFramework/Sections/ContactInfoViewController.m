//
//  ContactInfoViewController.m
//  AppFramework
//
//  Created by ABC on 7/30/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "EXUILabel.h"
#import "Patient.h"
#import "ContactSettingViewController.h"
#import "CaseHistoryRecordTableViewCell.h"
#import "AccountManager.h"
#import "ReviseContactInfoViewController.h"
#import "ContactDetailInfoViewController.h"
#import "ContactManager.h"
#import "SendGiftViewController.h"
#import "ContactInfoHeaderView.h"
#import <UIImageView+WebCache.h>

@interface ContactInfoViewController ()
<
UITableViewDataSource, UITableViewDelegate,
ReviseContactInfoViewControllerDelegate,
ContactInfoHeaderViewDelegate
>

@property (nonatomic, strong) Patient *patientCopy;
@property (nonatomic, strong) NSArray *medicalRecordArray;

@property (nonatomic, strong) UITableView   *contentTableView;
@property (nonatomic, strong) UISwitch      *starSwitch;
@property (nonatomic, strong) UISwitch      *blockSwitch;
@property (nonatomic, strong) UIButton      *sendGiftButton;

@property (nonatomic, strong) ContactInfoHeaderView *headerView;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)contactSettingItemClicked:(id)sender;
- (void)onStarSwitchChanged:(id)sender;
- (void)onBlockSwitchChanged:(id)sender;
- (void)sendGiftButtonClicked:(id)sender;

@end

@implementation ContactInfoViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        [self setHidesBottomBarWhenPushed:YES];
//    }
//    return self;
//}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}

- (id)initWithPatient:(Patient *)patient
{
    self = [self init];
    if (self) {
        self.patientCopy = patient;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentTableView.tableHeaderView = self.headerView;
    self.contentTableView.backgroundColor = UIColorFromRGB(0xedf2f1);

//    [self.headerView setAvatarWithImage:[UIImage imageNamed:@"icon_photo"]];
//    [self.headerView setName:[self.patientCopy getDisplayName]];
//    [self.headerView setRecordID:[NSString stringWithFormat:@"%ld", self.patientCopy.userID]];
    
    [self setNavigationBarWithTitle:nil leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self.headerView loadDataWithPatient:self.patientCopy];
    
    
    self.view.backgroundColor = UIColorFromRGB(0xd4d4d4);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AccountManager sharedInstance] asyncGetMedicalRecordWithUserID:self.patientCopy.userID withCompletionHandler:^(NSArray *medicalRecordArray) {
        self.medicalRecordArray = medicalRecordArray;
        [self.contentTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        
    }];
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


#pragma mark - Property

- (NSArray *)medicalRecordArray
{
    if (!_medicalRecordArray) {
        _medicalRecordArray = [[NSArray alloc] init];
    }
    return _medicalRecordArray;
}

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
    }
    return _contentTableView;
}

- (UISwitch *)starSwitch
{
    if (!_starSwitch) {
        _starSwitch = [[UISwitch alloc] init];
        [_starSwitch addTarget:self action:@selector(onStarSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _starSwitch;
}

- (UISwitch *)blockSwitch
{
    if (!_blockSwitch) {
        _blockSwitch = [[UISwitch alloc] init];
        [_blockSwitch addTarget:self action:@selector(onBlockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _blockSwitch;
}

- (UIButton *)sendGiftButton
{
    if (!_sendGiftButton) {
        _sendGiftButton = [[SkinManager sharedInstance] createDefaultButton];
        _sendGiftButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        [_sendGiftButton setTitle:@"送花记录" forState:UIControlStateNormal];
        [_sendGiftButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_sendGiftButton addTarget:self action:@selector(sendGiftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendGiftButton;
}

- (ContactInfoHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[ContactInfoHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, App_Frame_Width, 150.0f);
        _headerView.delegate = self;
    }
    
    return _headerView;
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (3 == section) {
        
        return self.medicalRecordArray.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 > [indexPath section]) {
        
        static NSString *reusableCellIdentifier = @"8F76A3E0-E46E-4ABA-94DD-22FDDB712CD8";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusableCellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if (0 == [indexPath section]) {
            [cell.textLabel setText:@"设为标星患者"];
            cell.accessoryView = self.starSwitch;
            [self.starSwitch setOn:self.patientCopy.isStarted];
        } else if (1 == [indexPath section]) {
            [cell.textLabel setText:@"加入黑名单"];
            cell.accessoryView = self.blockSwitch;
            [self.blockSwitch setOn:self.patientCopy.isBlocked];
        } else if (2 == [indexPath section]) {
            [cell.textLabel setText:@"送花记录"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld朵", self.patientCopy.flowerAcceptance]];
        }
        return cell;
    }
    else if (3 == [indexPath section]) {
        static NSString *reusableCellIdentifier = @"E2ADC1B6-FCF8-4913-979B-E1ABFE55F236";
        CaseHistoryRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
        if (!cell) {
            cell = [[CaseHistoryRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
        }
        MedicalRecord *medicalRecord = [self.medicalRecordArray objectAtIndex:[indexPath row]];
        [cell setMedicalRecord:medicalRecord];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 == [indexPath section]) {
        
        return [CaseHistoryRecordTableViewCell defaultCellHeight];
    }
    
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    static NSString *HeaderFooterViewIdentifier = @"6BF8F90C-C960-44AB-9908-1C472F17392D";
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderFooterViewIdentifier];
//    if (!headerView) {
//        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderFooterViewIdentifier];
//        
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
//        titleLabel.font = [UIFont systemFontOfSize:16.0f];
//        titleLabel.tag = 1;
//        [headerView addSubview:titleLabel];
//        [headerView addConstraint:[titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView withOffset:0.0f]];
//        [headerView addConstraint:[titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:15.0f]];
//        [headerView addConstraint:[titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headerView withOffset:0.0f]];
//    }
//    if (0 == section) {
//        
//    } else if (1 ==  section) {
//        UILabel *titleLabel = (UILabel *)[headerView viewWithTag:1];
//        [titleLabel setText:@"患者病历"];
//    }
//    return headerView;
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    UITableViewHeaderFooterView *footerView = nil;
//    if (0 == section) {
//        static NSString *FooterHeaderViewIdentifier = @"0F9C3669-06A8-406E-809C-22923A18CFE9";
//        footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FooterHeaderViewIdentifier];
//        if (!footerView) {
//            footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:FooterHeaderViewIdentifier];
//            [footerView addSubview:self.sendGiftButton];
//            {
//                // Autolayout
//                [footerView addConstraints:[self.sendGiftButton autoSetDimensionsToSize:CGSizeMake(180.0f, 25.0f)]];
//                [footerView addConstraint:[self.sendGiftButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:footerView withOffset:10.0f]];
//                [footerView addConstraint:[self.sendGiftButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerView withOffset:-10.0f]];
//            }
//        }
//    }
//    return footerView;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        
        return 32.0f;
    }
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (2 == indexPath.section) {
        
        [self sendGiftButtonClicked:nil];
    }
    
    
//    if (0 == [indexPath section] && 3 == [indexPath row]) {
//        ReviseContactInfoViewController *vc = [[ReviseContactInfoViewController alloc] initWithPatient:self.patientCopy];
//        vc.delegate = self;
//        UINavigationController *navigationController = [[SkinManager sharedInstance] createDefaultNavigationControllerWithRootView:vc];
//        [self.navigationController presentViewController:navigationController animated:YES completion:^{
//            
//        }];
//    } else if (1 == [indexPath section]) {
//        MedicalRecord *medicalRecord = [self.medicalRecordArray objectAtIndex:[indexPath row]];
//        ContactDetailInfoViewController *vc = [[ContactDetailInfoViewController alloc] initWithMedicalRecord:medicalRecord];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Selector

- (void)contactSettingItemClicked:(id)sender
{
    
}

- (void)onStarSwitchChanged:(id)sender
{
    BOOL isPushOn = [self.starSwitch isOn];
    self.patientCopy.isStarted = isPushOn;
    [[AccountManager sharedInstance] asyncUploadPatient:self.patientCopy withCompletionHandler:^(Patient *updatedPatient) {
        [[ContactManager sharedInstance] updateContact:self.patientCopy withNewContact:updatedPatient];
    } withErrorHandler:^(NSError *error) {
        self.patientCopy.isStarted = !self.patientCopy.isStarted;
    }];
}

- (void)onBlockSwitchChanged:(id)sender
{
    BOOL isPushOn = [self.blockSwitch isOn];
    self.patientCopy.isBlocked = isPushOn;
    [[AccountManager sharedInstance] asyncUploadPatient:self.patientCopy withCompletionHandler:^(Patient *updatedPatient) {
        [[ContactManager sharedInstance] updateContact:self.patientCopy withNewContact:updatedPatient];
    } withErrorHandler:^(NSError *error) {
        self.patientCopy.isBlocked = !self.patientCopy.isBlocked;
    }];
}

- (void)sendGiftButtonClicked:(id)sender
{
    SendGiftViewController *vc = [[SendGiftViewController alloc] initWithUserID:self.patientCopy.userID];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - ReviseContactInfoViewControllerDelegate

- (void)reviseContactInfoViewController:(ReviseContactInfoViewController *)viewController didChangeNoteNameWithText:(NSString *)text
{
    [viewController.navigationController popViewControllerAnimated:YES];
    
    NSString *oldNoteName = self.patientCopy.noteName;
    self.patientCopy.noteName = text;
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncUploadPatient:self.patientCopy withCompletionHandler:^(Patient *updatedPatient) {
        
        [self dismissLoading];
        [[ContactManager sharedInstance] updateContact:self.patientCopy withNewContact:updatedPatient];
        [self.headerView loadDataWithPatient:self.patientCopy];
    } withErrorHandler:^(NSError *error) {
        
        [self dismissLoading];
        self.patientCopy.noteName = oldNoteName;
        [self showHint:[error localizedDescription]];
    }];
}

#pragma mark - ContactInfoHeaderViewDelegate Methods

- (void)changeDisplayNameButtonClicked {
    
    ReviseContactInfoViewController *vc = [[ReviseContactInfoViewController alloc] initWithPatient:self.patientCopy];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
