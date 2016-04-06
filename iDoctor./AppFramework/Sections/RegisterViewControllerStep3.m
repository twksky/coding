//
//  RegisterViewControllerStep3.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "RegisterViewControllerStep3.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "EXUILabel.h"
#import "UIImagePickerController+Util.h"
#import "AccountManager.h"
#import "ApiManager.h"
#import <EaseMob.h>
#import "LoginManager.h"
#import <MBProgressHUD.h>

@interface RegisterViewControllerStep3 ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UITextFieldDelegate
>

@property (nonatomic, strong) UIScrollView  *contentScrollView;
@property (nonatomic, strong) EXUITextField *idNumTextField;
@property (nonatomic, strong) EXUILabel     *idImageLabel;
@property (nonatomic, strong) UIImageView       *addIDImageView;
@property (nonatomic, strong) EXUITextField *mobileTextField;
@property (nonatomic, strong) EXUILabel     *avatarLabel;
@property (nonatomic, strong) UIImageView       *avatarImageView;
@property (nonatomic, strong) UIButton      *submitButton;
@property (nonatomic, assign) NSInteger     imagePickerIndex;

@property (nonatomic, strong) Account       *accountCache;

// Selector
- (void)addIDImageViewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)avatarImageViewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)submitButtonClicked:(UIButton *)sender;
- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;

// Private Method
- (void)setupSubviews;
- (void)setupConstraints;
- (void)presentImagePickerControllerFrom:(NSInteger)sourceType withIndex:(NSInteger)index;

@end

@implementation RegisterViewControllerStep3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAccount:(Account *)regAccount
{
    self = [super init];
    if (self) {
        self.accountCache = regAccount;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithTitle:@"完善资料" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    self.view.backgroundColor = UIColorFromRGB(0xeef1f2);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
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

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
    }
    return _contentScrollView;
}

- (EXUITextField *)idNumTextField
{
    if (!_idNumTextField) {
        _idNumTextField = [[EXUITextField alloc] init];
        _idNumTextField.backgroundColor = [UIColor whiteColor];
        _idNumTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _idNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _idNumTextField.delegate = self;
        _idNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_idNumTextField setPlaceholder:@"请输入您的执业医师证号"];
#ifdef DEBUG_TEST
        [_idNumTextField setText:@"1234567890"];
#endif
    }
    return _idNumTextField;
}

- (EXUILabel *)idImageLabel
{
    if (!_idImageLabel) {
        _idImageLabel = [[EXUILabel alloc] init];
        _idImageLabel.textEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 14.0f);
        _idImageLabel.backgroundColor = [UIColor whiteColor];
        _idImageLabel.layer.masksToBounds = YES;
        _idImageLabel.textColor = UIColorFromRGB(0xbfbfbf);
        _idImageLabel.textAlignment = NSTextAlignmentRight;
        [_idImageLabel setText:@"(上传工作证/工作胸牌或\n其他体现医师身份的照片)"];
        _idImageLabel.numberOfLines = 0;
        _idImageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _idImageLabel.userInteractionEnabled = YES;
    }
    return _idImageLabel;
}

- (UIImageView *)addIDImageView
{
    if (!_addIDImageView) {
        _addIDImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add_newImage"]];
        _addIDImageView.layer.cornerRadius = 3.0f;
        _addIDImageView.layer.masksToBounds = YES;
        _addIDImageView.clipsToBounds = YES;
        _addIDImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addIDImageViewTapGestureFired:)];
        [_addIDImageView addGestureRecognizer:tapGestureRecognizer];
    }
    return _addIDImageView;
}

- (EXUITextField *)mobileTextField
{
    if (!_mobileTextField) {
        _mobileTextField = [[EXUITextField alloc] init];
        _mobileTextField.backgroundColor = [UIColor whiteColor];
        _mobileTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _mobileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _mobileTextField.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
        _mobileTextField.layer.borderWidth = 0.7;
        _mobileTextField.delegate = self;
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_mobileTextField setPlaceholder:@"请输入单位联系电话"];
#ifdef DEBUG_TEST
        [_mobileTextField setText:@"010-21990149"];
#endif
    }
    return _mobileTextField;
}

- (EXUILabel *)avatarLabel
{
    if (!_avatarLabel) {
        _avatarLabel = [[EXUILabel alloc] init];
        _avatarLabel.textEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 64.0f);
        _avatarLabel.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        _avatarLabel.layer.cornerRadius = 3.0f;
        _avatarLabel.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
        _avatarLabel.layer.borderWidth = 0.7f;
        _avatarLabel.textAlignment = NSTextAlignmentRight;
        [_avatarLabel setText:@"上传头像照片"];
        _avatarLabel.textColor = UIColorFromRGB(0xbfbfbf);
        _avatarLabel.userInteractionEnabled = YES;
    }
    return _avatarLabel;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add_newImage"]];
        _avatarImageView.layer.cornerRadius = 3.0f;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewTapGestureFired:)];
        [_avatarImageView addGestureRecognizer:tapGestureRecognizer];
    }
    return _avatarImageView;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        _submitButton.backgroundColor = UIColorFromRGB(0x34d3b4);
        _submitButton.layer.cornerRadius = 6.0f;
        [_submitButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_submitButton setTitle:@"完成，请等待工作人员审核" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}


#pragma mark - Selector

- (void)addIDImageViewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从照片库中选择" otherButtonTitles:@"拍照", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

- (void)avatarImageViewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从照片库中选择" otherButtonTitles:@"拍照", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (void)submitButtonClicked:(UIButton *)sender
{
    
    //TODO 没有检测空
    self.accountCache.credentialsID = [self.idNumTextField text];
    self.accountCache.officePhone   = [self.mobileTextField text];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AccountManager sharedInstance] asyncUploadAccount:self.accountCache withCompletionHandler:^(Account *account) {
        self.accountCache = account;
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"资料已上传，请等待审核后登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
        
        NSString *easemobLoginName = [NSString stringWithFormat:@"%ld", self.accountCache.accountID];
        NSString *easemobPassword = [self.accountCache.easemobPassword uppercaseString];
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:easemobLoginName password:easemobPassword completion:^(NSDictionary *loginInfo, EMError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (loginInfo && !error) {
                DLog(@"%@ %@ 成功登录环信服务器!", easemobLoginName, easemobPassword);
                //[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                [LoginManager sharedInstance].loginStatus = LOGINSTATUS_ONLINE;
            }else {
                NSString *errorText = @"";
                switch (error.errorCode) {
                    case EMErrorServerNotReachable:
                        errorText = @"连接服务器失败!";
                        break;
                    case EMErrorServerAuthenticationFailure:
                        errorText = @"用户名或密码错误";
                        break;
                    case EMErrorServerTimeout:
                        errorText = @"连接服务器超时!";
                        break;
                    default:
                        errorText = @"登录失败";
                        break;
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:errorText delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        } onQueue:nil];
        
        
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:NO];
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentScrollView];
    
    UIView *line1 = [self generateLineView];
    UIView *line2 = [self generateLineView];
    UIView *line3 = [self generateLineView];

    [self.contentScrollView addSubview:self.idNumTextField];
    [self.contentScrollView addSubview:self.idImageLabel];
    [self.contentScrollView addSubview:self.addIDImageView];
    [self.contentScrollView addSubview:self.mobileTextField];
    [self.contentScrollView addSubview:self.avatarLabel];
    [self.contentScrollView addSubview:self.avatarImageView];
    [self.contentScrollView addSubview:self.submitButton];
    
    [self.contentScrollView addSubview:line1];
    [self.contentScrollView addSubview:line2];
    [self.contentScrollView addSubview:line3];
    

    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    
    [self.contentScrollView addConstraints:[self.idNumTextField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.idImageLabel autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 100.0f)]];
    [self.contentScrollView addConstraints:[self.mobileTextField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.avatarLabel autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 100.0f)]];
    [self.contentScrollView addConstraints:[self.submitButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 30.0f, 50.0f)]];
    
    [self.contentScrollView addConstraints:[line1 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[line2 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95, 0.7f)]];
    [self.contentScrollView addConstraints:[line3 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    

    [self.contentScrollView addConstraint:[self.idNumTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.idNumTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:20.0f]];
    [self.contentScrollView addConstraint:[self.idNumTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.idImageLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.avatarLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.submitButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-15.0f]];
    [self.contentScrollView addConstraint:[self.submitButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:15.0f]];
    [self.contentScrollView addConstraint:[self.avatarLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.idImageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    
    [self.contentScrollView addConstraint:[self.idImageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.idNumTextField]];
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.idImageLabel withOffset:9.0f]];
    [self.contentScrollView addConstraint:[self.avatarLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mobileTextField withOffset:9.0f]];
    [self.contentScrollView addConstraint:[self.submitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarLabel withOffset:20.0f]];
    
    [self.contentScrollView addConstraints:[self.addIDImageView autoSetDimensionsToSize:CGSizeMake(80.0f, 80.0f)]];
    [self.contentScrollView addConstraint:[self.addIDImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.idImageLabel withOffset:15.0f]];
    [self.contentScrollView addConstraint:[self.addIDImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.idImageLabel withOffset:10.0f]];
        
    [self.contentScrollView addConstraints:[self.avatarImageView autoSetDimensionsToSize:CGSizeMake(80.0f, 80.0f)]];
    [self.contentScrollView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.avatarLabel withOffset:15.0f]];
    [self.contentScrollView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarLabel withOffset:10.0f]];
    
    [self.contentScrollView addConstraint:[line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.idNumTextField]];
    [self.contentScrollView addConstraint:[line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.idImageLabel]];
    [self.contentScrollView addConstraint:[line2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.idImageLabel]];
    [self.contentScrollView addConstraint:[line3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.idImageLabel]];
}

- (UIView *)generateLineView {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xd4d4d4);
    return line;
}

- (void)presentImagePickerControllerFrom:(NSInteger)sourceType withIndex:(NSInteger)index;
{
    // 判断有摄像头，并且支持拍照功能
    if ([UIImagePickerController isCameraAvailable] && [UIImagePickerController doesCameraSupportTakingPhotos]){
        self.imagePickerIndex = index;
        // 初始化图片选择控制器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.navigationBar.barStyle = UIBarStyleBlackOpaque; // Or whatever style.
        // or
        //controller.navigationBar.tintColor = [UIColor whateverColor];
        [controller setSourceType:sourceType];
        // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType, nil];
        [controller setMediaTypes:arrMediaTypes];
        [controller setAllowsEditing:YES];           // 设置是否可以管理已经存在的图片或者视频
        [controller setDelegate:self];              // 设置代理
        controller.navigationController.delegate = self;
        [self.navigationController presentViewController:controller animated:YES completion:^{
            
        }];
    } else {
        DLog(@"Camera is not available.");
    }
}


#pragma mark - UIImagePickerControllerDelegate 代理方法

// 保存图片后到相册后，调用的相关方法，查看是否保存成功
- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo
{
    if (paramError == nil) {
        DLog(@"Image was saved successfully.");
    } else {
        DLog(@"An error happened while saving the image.");
        DLog(@"Error = %@", paramError);
    }
}

// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog(@"Picker returned successfully.");
    DLog(@"%@", info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]) {
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        // 保存图片到相册中
        //SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        //UIImageWriteToSavedPhotosAlbum(theImage, self, selectorToCall, NULL);
        if (0 == self.imagePickerIndex) {
            [self.addIDImageView setImage:theImage];
            [[AccountManager sharedInstance] asyncUploadImage:theImage withCompletionHandler:^(ImageHandle *imageHandle) {
                self.accountCache.certificateImageURLString = imageHandle.imageURLString;
            } withErrorHandler:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }];
        } else if (1 == self.imagePickerIndex) {
            [self.avatarImageView setImage:theImage];
            [[AccountManager sharedInstance] asyncUploadImage:theImage withCompletionHandler:^(ImageHandle *imageHandle) {
                self.accountCache.avatarImageURLString = imageHandle.imageURLString;
            } withErrorHandler:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^(void) {
        
    }];
}

// 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(void) {
        
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //[controller setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
    //[controller setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    if (0 == buttonIndex) {
        [self presentImagePickerControllerFrom:UIImagePickerControllerSourceTypeSavedPhotosAlbum withIndex:actionSheet.tag];
    } else if (1 == buttonIndex) {
        [self presentImagePickerControllerFrom:UIImagePickerControllerSourceTypeCamera withIndex:actionSheet.tag];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.idNumTextField == textField || self.mobileTextField == textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        navigationController.navigationBar.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        if (IOS_VERSION >= 7.0f) {
            navigationController.navigationBar.barTintColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        }
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
