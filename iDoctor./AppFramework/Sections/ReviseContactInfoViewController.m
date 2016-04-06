//
//  ReviseContactInfoViewController.m
//  AppFramework
//
//  Created by ABC on 8/19/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ReviseContactInfoViewController.h"
#import "UIView+AutoLayout.h"
#import "UIViewController+Util.h"
#import "SkinManager.h"
#import "Patient.h"

@interface ReviseContactInfoViewController ()
<
UITextViewDelegate,
UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, strong) UITableView       *contentTableView;
@property (nonatomic, strong) UITextField           *nameTextField;
@property (nonatomic, strong) Patient           *patientCopy;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)saveButtonClicked:(id)sender;

@end

@implementation ReviseContactInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPatient:(Patient *)patient
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.patientCopy = patient;
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
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClicked:)];
    [leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[SkinManager sharedInstance].defaultWhiteColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[SkinManager sharedInstance].defaultWhiteColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self setNavigationBarWithTitle:@"修改备注名" leftBarButtonItem:leftBarButtonItem rightBarButtonItem:rightBarButtonItem];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
    
    [self.contentTableView setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.nameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.nameTextField resignFirstResponder];
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReusableCellIdentifier = @"8CF5A73B-CF14-456C-8F85-ED7010B97B51";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.contentView addSubview:self.nameTextField];
        [cell.contentView addConstraints:[self.nameTextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    
}


#pragma mark - Selector

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    
}

- (void)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonClicked:(id)sender
{
//    if (!self.nameTextField.text || [self.nameTextField.text length] == 0) {
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"备注名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    }
    
    if ([self.delegate respondsToSelector:@selector(reviseContactInfoViewController:didChangeNoteNameWithText:)]) {
        
        [self.delegate reviseContactInfoViewController:self didChangeNoteNameWithText:self.nameTextField.text];
    }
}

@end
