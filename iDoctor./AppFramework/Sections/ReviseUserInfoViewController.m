//
//  ReviseUserInfoViewController.m
//  AppFramework
//
//  Created by ABC on 8/13/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ReviseUserInfoViewController.h"
#import "UIView+AutoLayout.h"
#import "UIViewController+Util.h"
#import "SkinManager.h"
#import "Account.h"
#import "AppUtil.h"

@interface ReviseUserInfoViewController ()
<
UITextViewDelegate,
UITableViewDataSource, UITableViewDelegate
>
{
    NSInteger               userInfoType;
    Account                 *accountCopy;
}

@property (nonatomic, strong) UITableView       *contentTableView;
@property (nonatomic, strong) UITextField           *nameTextField;
@property (nonatomic, strong) UIView            *moodContainerView;
@property (nonatomic, strong) UITextView            *moodTextView;
@property (nonatomic, strong) UILabel               *moodTextCountLabel;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)saveButtonClicked:(id)sender;

@end

@implementation ReviseUserInfoViewController

const NSInteger MaxInputTextCount = 800;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUserInfoType:(NSInteger)type withAccount:(Account *)account
{
    self = [super init];
    if (self) {
        // Custom initialization
        userInfoType = type;
        accountCopy = account;
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
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[SkinManager sharedInstance].defaultWhiteColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
    
    if (userInfoType == UIT_Mobile || userInfoType == UIT_Realname || userInfoType == UIT_OfficePhone) {
        [self.contentTableView setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    } else {
        [self.moodContainerView setFrame:CGRectMake(5.0f, 5.0f, self.view.frame.size.width - 10.0f, 100.0f)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (userInfoType == UIT_Mobile || userInfoType == UIT_Realname || userInfoType == UIT_OfficePhone) {
        if (userInfoType == UIT_Mobile || userInfoType == UIT_OfficePhone) {
            self.nameTextField.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            self.nameTextField.keyboardType = UIKeyboardTypeDefault;
        }
        [self.nameTextField becomeFirstResponder];
    } else {
        [self.moodTextView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (userInfoType == UIT_Mobile || userInfoType == UIT_Realname || userInfoType == UIT_OfficePhone) {
        [self.nameTextField resignFirstResponder];
    } else {
        [self.moodTextView resignFirstResponder];
    }
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

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _nameTextField;
}

- (UIView *)moodContainerView
{
    if (!_moodContainerView) {
        _moodContainerView = [[UIView alloc] init];
        _moodContainerView.layer.borderColor = [[UIColor redColor] CGColor];
        _moodContainerView.layer.borderWidth = 1.0f;
        _moodContainerView.layer.cornerRadius = 5.0f;
        _moodContainerView.layer.masksToBounds = YES;
        
        [_moodContainerView addSubview:self.moodTextView];
        [_moodContainerView addSubview:self.moodTextCountLabel];
        {
            // Autolayout
            [_moodContainerView addConstraint:[self.moodTextView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_moodContainerView withOffset:0.0f]];
            [_moodContainerView addConstraint:[self.moodTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_moodContainerView withOffset:0.0f]];
            [_moodContainerView addConstraint:[self.moodTextView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_moodContainerView withOffset:0.0f]];
            [_moodContainerView addConstraint:[self.moodTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_moodContainerView withOffset:0.0f]];
            
            [_moodContainerView addConstraints:[self.moodTextCountLabel autoSetDimensionsToSize:CGSizeMake(30.0f, 15.0f)]];
            [_moodContainerView addConstraint:[self.moodTextCountLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_moodContainerView withOffset:0.0f]];
            [_moodContainerView addConstraint:[self.moodTextCountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_moodContainerView withOffset:0.0f]];
        }
    }
    return _moodContainerView;
}

- (UITextView *)moodTextView
{
    if (!_moodTextView) {
        _moodTextView = [[UITextView alloc] init];
        _moodTextView.delegate = self;
        _moodTextView.font = [UIFont systemFontOfSize:15.0f];
    }
    return _moodTextView;
}


- (UILabel *)moodTextCountLabel
{
    if (!_moodTextCountLabel) {
        _moodTextCountLabel = [[UILabel alloc] init];
        _moodTextCountLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _moodTextCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moodTextCountLabel;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (userInfoType == UIT_Mobile || userInfoType == UIT_Realname || userInfoType == UIT_OfficePhone) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReusableCellIdentifier = @"8CF5A73B-CF14-456C-8F85-ED7010B97B51";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (userInfoType == UIT_Mobile || userInfoType == UIT_Realname || userInfoType == UIT_OfficePhone) {
        [cell.contentView addSubview:self.nameTextField];
        [cell.contentView addConstraints:[self.nameTextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)]];
        if (userInfoType == UIT_Mobile) {
            [self.nameTextField setText:[AppUtil parseString:accountCopy.mobile]];
        } else if (userInfoType == UIT_Realname) {
            [self.nameTextField setText:[AppUtil parseString:accountCopy.realName]];
        } else if (userInfoType == UIT_OfficePhone) {
            [self.nameTextField setText:[AppUtil parseString:accountCopy.officePhone]];
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self.moodTextCountLabel setText:[NSString stringWithFormat:@"%lu", MaxInputTextCount - [textView.text length]]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return range.location < MaxInputTextCount;
}


#pragma mark - Private Method

- (void)setupSubviews
{
    if (userInfoType == UIT_Mobile || userInfoType == UIT_Realname || userInfoType == UIT_OfficePhone) {
        [self.view addSubview:self.contentTableView];
    } else if (userInfoType == UIT_Schedule || userInfoType == UIT_Brief) {
        [self.view addSubview:self.moodContainerView];
        NSString *moodText = nil;
        if (userInfoType == UIT_Schedule) {
            moodText = accountCopy.schedule;
        } else if (userInfoType == UIT_Brief) {
            moodText = accountCopy.brief;
        }
        if (!moodText || [moodText isEqual:[NSNull null]]) {
            moodText = @"";
        }
        [self.moodTextView setText:moodText];
        [self.moodTextCountLabel setText:[NSString stringWithFormat:@"%ld", MaxInputTextCount - [moodText length]]];
    }
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    
}


#pragma mark - Selector

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:NO];
}

- (void)saveButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(reviseUserInfoViewController:didChangeType:withText:)]) {
        if (userInfoType == UIT_Mobile || userInfoType == UIT_Realname || userInfoType == UIT_OfficePhone) {
            NSString *text = [self.nameTextField text];
            [self.delegate reviseUserInfoViewController:self didChangeType:userInfoType withText:text];
        } else {
            NSString *text = [self.moodTextView text];
            [self.delegate reviseUserInfoViewController:self didChangeType:userInfoType withText:text];
        }
    }
}

@end
