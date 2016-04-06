//
//  IDPatientCaseDetailViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientCaseDetailViewController.h"
#import "IDIHavePatientManager.h"
#import "IDGetAllCommentsViewController.h"
#import "IDPatientMessageViewController.h"
#import "IDPatientCommentDetailViewController.h"
#import "ChatViewController.h"

#import "IDPatientCaseDetailTableViewCell.h"
#import "IDPatientCaseCommentTableViewCell.h"

#import "IDMedicalDoctorModel.h"
#import "IDPatientMedicalsModel.h"
#import "IDPatientMedicalsCommentsModel.h"
#import "IDMedicaledModel.h"
#import "PatientsModel.h"
#import "IDGetPatientInformation.h"
#import "IDGetDoctorPatient.h"

#import "IDIHavePatientManager.h"

#import <WebViewJavascriptBridge.h>
#import <MWPhotoBrowser.h>

#import "NoChatBottomView.h"
#import "ChatBottomView.h"
#import "GDComposeView.h"

#import "ContactManager.h"
#import "IDErrorView.h"



@interface IDPatientCaseDetailViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
MWPhotoBrowserDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

// 用来存储数据的数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IDPatientMedicalsModel *medicalsModel;

// patient_medical_id
@property (nonatomic, strong) NSString *patient_medical_id;
@property (nonatomic, strong) UIWebView *caseWebView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, weak) NSObject<UIWebViewDelegate> *webViewDelegate;

@property (nonatomic, strong) NSString *currentImgURL;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;


@property (nonatomic, strong) NoChatBottomView *noChat;
@property (nonatomic, strong) ChatBottomView *chat;


@property (nonatomic, strong) UIView *clickedBottomView;
@property (nonatomic, assign) BOOL isClicked;

@end

@implementation IDPatientCaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isClicked = NO;
    
    
    if (_model == nil) {
        
        self.title = _patientModel.medical_name;
        self.patient_medical_id = _patientModel.ID;
        
    } else if (_patientModel == nil) {
        
        self.title = _model.medical_name;
        self.patient_medical_id = _model.patient_medical_id;
    }
    
    [self setupUI];
    
    
}



// 得到数据
- (void)getDatas
{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view isDimBackground:NO];
    
   [[IDIHavePatientManager sharedInstance] getPatientMedicalsWithPatientMedicalID:self.patient_medical_id withCompletionHandelr:^(IDPatientMedicalsModel *model) {
       [MBProgressHUD hideHUDForView:self.view];
       
       for (UIView *view in self.view.subviews) {
           
           if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
               
               [view removeFromSuperview];
               
               break;
           }
           
       }
       
       
       self.medicalsModel = model;
    
       // 判断当前医生有没有接收  取出当前登陆ID跟现有的进行相应的比较
       for (NSNumber *doctorIDNumber in self.medicalsModel.patient_medical.receive_doctor_list) {
           
           
           NSInteger doctorID = [doctorIDNumber integerValue];
           
           if (doctorID == kAccount.doctor_id) { // 如果跟当前的医生ID相同 则变成取消接收
               
               self.isClicked = YES;
               
               break;
           }
           
       }
       
       
       
       // 是否已经接收了患者
       if (self.isChat) { // 带有聊天
           
           self.chat.isIncepted = self.isClicked;
           
       } else { // 不带聊天
           
           self.noChat.isIncepted = self.isClicked;

       }
       
       [self.tableView reloadData];
       
   } withErrorHandler:^(NSError *error) {
       
       [self errorView];
       [MBProgressHUD hideHUDForView:self.view];
       [MBProgressHUD showError:error.localizedDescription toView:self.view];
       
   }];
 
}

- (void)errorView
{
    IDErrorView *errorView = [[IDErrorView alloc] init];
    errorView.block = ^(){
        
        [self getDatas];
        
    };
    
    [self.view addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
}


- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
    __weak typeof(self) wkSelf = self;
    
    if (self.isChat) { // 带有聊天
        
        self.chat = [[ChatBottomView alloc] init];
        
        [_chat setChatBtnClickBlock:^{
            
            // 取出本地缓存的患者数据
            NSArray *modelArray = [ContactManager sharedInstance].searchArr;
            
            // 取出当前患者的id
            NSString *patient_id = wkSelf.medicalsModel.patient_info.patient_id;
            
            // 遍历查找  看是否于该患者是好友
            
            
            for (IDGetDoctorPatient *model in modelArray) {
                
                if ([model.patient_id isEqualToString:patient_id]) { // 这个医生和患者是好友关系
    
                    
                    ChatViewController *chartController = [[ChatViewController alloc] initWithUserID:model.patient_id];
                    [wkSelf.navigationController pushViewController:chartController animated:YES];
                    
                    return ;
                    
                }
                
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您和该患者暂时不是好友关系，不能聊天" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
 
        }];
        
        [_chat setRevertBtnClickBlock:^{
            
            [wkSelf alertComposeView];
        }];
        [_chat setInceptBtnClickBlock:^{
            
            [wkSelf inceptPatientWithBottomView:wkSelf.chat];
            
        }];
        [self.view addSubview:_chat];
        
    } else { // 不带聊天
        
        self.noChat = [[NoChatBottomView alloc] init];
        
        [_noChat setRevertBtnClickBlock:^{
            
            [wkSelf alertComposeView];
        }];
        [_noChat setInceptBtnClickBlock:^{
            
            [wkSelf inceptPatientWithBottomView:wkSelf.noChat];
        }];
        
        
        [self.view addSubview:_noChat];

    }
   
    [self getDatas];
}
- (void)alertComposeView
{
    GDComposeView *compose = [[GDComposeView alloc] init];
    [compose setSendBtnClickBlock:^(NSString *text) {
        
        [MBProgressHUD showMessage:@"正在提交..." toView:self.view isDimBackground:NO];
        [[IDIHavePatientManager sharedInstance] doctorPubilshCommentWithPatientMedicalID:_patient_medical_id description:text WithCompletionHandelr:^(IDPatientMedicalsCommentsModel *model) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [self getDatas];
            
            
        } withErrorHandler:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
            
        }];

    }];
    [compose show];
}

- (void)inceptPatientWithBottomView:(UIView *)bottomView
{

    self.clickedBottomView = bottomView;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    if (self.isClicked == NO) { // 接收患者
        
        alert.message = @"接收患者?";
        
    } else { // 取消接收
    
        alert.message = @"取消接收患者?";
    
    }

    [alert show];
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // 确定按钮
 
        
        if (self.isClicked == NO) { // 接收患者
            
            [MBProgressHUD showMessage:@"正在接收..." toView:self.view isDimBackground:NO];
            [[IDIHavePatientManager sharedInstance] receivePatientWithPatientMedicalID:self.medicalsModel.patient_medical.patient_medical_id WithCompletionHandelr:^(IDMedicaledModel *model) {
               
                [MBProgressHUD hideHUDForView:self.view];
                if (model) {
                    
                    [MBProgressHUD showSuccess:@"接收成功" toView:self.view];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:KaddOrRemoveAPatient object:nil];
                    
                }
                
                self.isClicked = YES;
                
                if (self.clickedBottomView == self.noChat) {
                    
                    self.noChat.isIncepted = self.isClicked;
                }

                if (self.clickedBottomView == self.chat) {
                    
                    self.chat.isIncepted = self.isClicked;
                    
                }
                
            } withErrorHandler:^(NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:error.localizedDescription toView:self.view];
                
                
            }];
            
        } else { // 取消接收
            
            [MBProgressHUD showMessage:@"取消接收..." toView:self.view isDimBackground:NO];
            [[IDIHavePatientManager sharedInstance] registerPatientWithPatientMedicalID:self.medicalsModel.patient_medical.patient_medical_id WithCompletionHandelr:^(IDMedicaledModel *model) {
                
                [MBProgressHUD hideHUDForView:self.view];
                if (model != nil) {
                    
                    [MBProgressHUD showSuccess:@"取消接收成功" toView:self.view];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KaddOrRemoveAPatient object:nil];
                    
                }
                
                self.isClicked = NO;
                
                if (self.clickedBottomView == self.noChat) {
                    
                    self.noChat.isIncepted = self.isClicked;
                }
                
                if (self.clickedBottomView == self.chat) {
                    
                    self.chat.isIncepted = self.isClicked;
                    
                }
                
            } withErrorHandler:^(NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:error.localizedDescription toView:self.view];
                
                
            }];
   
        }
 
    }
    
    
   
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        
    }
    
    return _tableView;
}

// 行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.medicalsModel == nil) {
        
        return 0;
    }
    
    return 3;
}

// 列数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    
    switch (section) {
        case 0:{
            
            row = 2;
        
        }break;
            
        case 1:{
            
            row = 1;
            
        }break;
            
        case 2:{
           
            row = self.medicalsModel.comments.count;
            
        }break;
            
        default:
            break;
    }

    return row;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section != 2) {
       
        static NSString *ident = @"PatientCaseDetailTableViewCell";
        IDPatientCaseDetailTableViewCell *caseCell = [tableView dequeueReusableCellWithIdentifier:ident];
        
        if (caseCell == nil) {
            
            caseCell = [[IDPatientCaseDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            self.caseWebView = caseCell.webView;
            self.webViewDelegate = caseCell;
            [self initBridge];
        }
        
        [caseCell setupUIWithIndexPath:indexPath];
        
        [caseCell dataCellWithModel:self.medicalsModel indexpath:indexPath];
        
        caseCell.block = ^(){
            
            [self.tableView reloadData];
            
        };
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            caseCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell = caseCell;
        
    } else  if(indexPath.section == 2 ){
        
        static NSString *ident = @"IDPatientCaseCommentTableViewCell";
        IDPatientCaseCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:ident];
        if (commentCell == nil) {
            
            commentCell = [[IDPatientCaseCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        
        [commentCell dataCellCommentWithModel:self.medicalsModel row:indexPath.row];
        
        cell = commentCell;
    
    }
    
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    CGFloat height = 0;
    
    if (section == 0) {
        
        if (row == 0) { // 患者
            
            height = 91;
            
        } else { // 医生
            
            height = 90;
            
        }
        
    } else if (section == 1) {
        
        height = [IDPatientCaseDetailTableViewCell height];
            
        
    } else if (section == 2) {
        
        if (self.medicalsModel.comments.count != 0) {
            
              height = 157;
            
        }
        
    }
    
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        return 10;
        
    } else {
    
        return 0.1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        return 10;
        
    } else if (section == 2) {
    
        return 50;
        
    } else {
    
        return 0.1;
    
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    if (self.medicalsModel == nil) {
        
        return nil;
    }
    
    if (self.medicalsModel.comments.count == 0) {
        
        return nil;
    }
    
    
    if (section == 2) {

        headerView = [self getCommentsView];
        
    }
    
    return headerView;

}

#pragma mark -
- (void)initBridge {
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.caseWebView webViewDelegate:self.webViewDelegate handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"Received message from javascript: %@", data);
        self.currentImgURL = data;
        
        [self.photoBrowser reloadData];
        UINavigationController *photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:photoNavigationController animated:YES completion:nil];
    }];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    return [MWPhoto photoWithURL:[NSURL URLWithString:self.currentImgURL]];
}

- (UIView *)getCommentsView
{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    // 绿色的条
    UIView *greeView = [[UIView alloc] init];
    greeView.backgroundColor = UIColorFromRGB(0x36cacc);
    [bgView addSubview:greeView];
    [greeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(bgView).with.offset(0);
        make.size.equalTo(CGSizeMake(5, 50));
        
    }];
    
    // 字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.textColor = UIColorFromRGB(0x36cacc);
    nameLabel.text = @"回复意见";
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bgView);
        make.left.equalTo(greeView.right).with.offset(10);
        
    }];
    
    // 全部评论的字样
    UILabel *allLabel = [[UILabel alloc] init];
    allLabel.font = [UIFont systemFontOfSize:13.0f];
    allLabel.textColor = UIColorFromRGB(0xa8a8aa);
    allLabel.text = @"全部评论";
    [bgView addSubview:allLabel];
    [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView).with.offset(- (15 + 7 + 5));
        
    }];
    
    // 箭头
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"next"];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(allLabel.right).with.offset(5);
        make.centerY.equalTo(bgView);
        make.size.equalTo(CGSizeMake(7, 12));
        
    }];
    
    // 分割线
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [bgView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView).with.offset(0);
        make.right.equalTo(bgView).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
        
    }];
    
    // 给背景添加相应的手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getAllComments:)];
    tap.numberOfTapsRequired = 1; // 点击一次
    tap.numberOfTouchesRequired = 1; // 一只手指点击
    [bgView addGestureRecognizer:tap];
    
    
    return bgView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) { // 患者信息
        
        IDPatientMessageViewController *messageViewController = [[IDPatientMessageViewController alloc] init];
        
        if (_model == nil) {
            
            messageViewController.model = _patientModel;
            
        } else if (_patientModel == nil) {
        
        messageViewController.medicalModel = _model;
        }
        
        
        [self.navigationController pushViewController:messageViewController animated:YES];

    } else if (indexPath.section == 2) {
    
        IDPatientCommentDetailViewController *detail = [[IDPatientCommentDetailViewController alloc] init];
        NSInteger row = indexPath.row;
        
        NSArray *array = self.medicalsModel.comments;
        
        IDPatientMedicalsCommentsModel *commentsModel = array[row];
        
        detail.comment_descreption = commentsModel.comment_descreption;
        [self.navigationController pushViewController:detail animated:YES];
        
    
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// 手势的点击事件
- (void)getAllComments:(UITapGestureRecognizer *)recogniz
{
    IDGetAllCommentsViewController *allComments = [[IDGetAllCommentsViewController alloc] init];
    
    if (_model == nil) {
        
       allComments.patient_medical_id = _patientModel.ID;
        
    } else if (_patientModel == nil) {
    
        allComments.patient_medical_id = _model.patient_medical_id;
       
    
    }
    
    
    [self.navigationController pushViewController:allComments animated:YES];

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

@end
