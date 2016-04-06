//
//  IDPatientMessageViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientMessageViewController.h"

#import "IDMedicaledModel.h"
#import "IDGetPatientInformation.h"

#import "IDpatientMsgTopTableViewCell.h"
#import "IDpatientMsgBottomTableViewCell.h"


#import "IDIHavePatientManager.h"
#import "PatientsModel.h"

@interface IDPatientMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

// 用一个表来显示相应的信息
@property (nonatomic, strong) UITableView *tableView;

// 用一个 数组  来装相应的数据
@property (nonatomic, strong) NSMutableArray *dataArray;

// 患者的基本信息
@property (nonatomic, strong) IDGetPatientInformation *patient_informationModel;



@property (nonatomic, strong) UIView *topView;

@end

@implementation IDPatientMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0x36cacc);
    
        
    
    if (!self.patient_id) {
        
        if (_model == nil) {
            self.patient_id = _medicalModel.patient_id;
        } else if(_medicalModel == nil) {
            
            self.patient_id = _model.patient_id;
            
        }
        
    }
    
    
    
    [self setupUI];

}

// 创建相应的UI
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);

    }];
    
    [self getData];

}

// 得到相应的数据
- (void)getData
{
    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
        
            break;
        }
        
    }
    
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view isDimBackground:NO];
    // 获取患者的基本信息
    [[IDIHavePatientManager sharedInstance] getPatientsInformationWithPatientID:(int)self.patient_id withCompletionHandelr:^(IDGetPatientInformation *model) {
        
        self.patient_informationModel = model;
 
        
        [self.tableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        

    }];
    
    
    
    // 获取患者的病例
    [[IDIHavePatientManager sharedInstance] getPatientCaseWithPatientID:(int)self.patient_id withCompletionHandelr:^(NSArray *arr) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.dataArray addObjectsFromArray:arr];
        
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
        
        [self getData];
        
    };
    
    [self.view addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
}

#pragma mark - 表的数据源  和  代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.patient_informationModel == nil) {
        
        return 0;
        
    } else if (self.dataArray.count == 0) {
        
        return 1;
        
    } else {
        
       return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) { // 基本资料
        
        return 5;
        
    } else if (section == 1) { // 患者的病例
    
        return self.dataArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSArray *itemArray = @[@"姓名",@"性别",@"出生日期",@"身高",@"体重"];
    
    if (indexPath.section == 0) { // 基本资料
        
        IDpatientMsgTopTableViewCell *topCell = [IDpatientMsgTopTableViewCell cellWithTableView:tableView indexPath:indexPath];
        
        [topCell dataWithName:itemArray[indexPath.row] patientInfo:self.patient_informationModel IndexPath:indexPath];
        
        cell = topCell;
        
    } else if (indexPath.section == 1) { // 病例
    
        IDpatientMsgBottomTableViewCell *bottomCell  = [IDpatientMsgBottomTableViewCell cellWithTab:tableView indexpath:indexPath];
        [bottomCell dataWithMedicalDoctorModel:self.dataArray[indexPath.row] indexPath:indexPath];
        cell = bottomCell;
    }
    
    
    cell.selected = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if (indexPath.section == 0) { // 基本资料
        
        height = 46.0f;
        
    } else {
    
        height = [IDpatientMsgBottomTableViewCell height];
    
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.patient_informationModel == nil) {
        return 0.1f;
    }
    
    
    if (section == 0) { // 基本资料
        
        return 211;
        
    } else {
    
        return 10;
    }
}


// 头部的View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    
    if (self.patient_informationModel == nil) {
        
        return headerView;
    }
    
    if (section == 0) { // 基本资料
        
        headerView = [self ViewWithModel:self.patient_informationModel];
        
    } else if (section == 1) { // 病例
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf8f8f8);
        
        headerView = view;
    }
    
    
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = self.tableView.contentOffset.y;
    //向上偏移量变正  向下偏移量变负
    if (yOffset < 0) {
        CGFloat factor = ABS(yOffset)+156;
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake([[UIScreen mainScreen] bounds].size.width*factor/156, factor));
            make.left.equalTo(-([[UIScreen mainScreen] bounds].size.width*factor/156-[[UIScreen mainScreen] bounds].size.width)/2);
            make.top.equalTo(-ABS(yOffset));
        }];
    }
//    else {
//        CGRect f = self.topView.frame;
//        f.origin.y = 0;
//        self.topView.frame = f;
//        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake([[UIScreen mainScreen] bounds].size.width, 156));
//            make.left.equalTo(0);
//            make.top.equalTo(f.origin.y);
//        }];
//    }
}

// 顶部的患者个人资料
- (UIView *)ViewWithModel:(IDGetPatientInformation *)model
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = UIColorFromRGB(0x36cacc);
    [bgView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(bgView).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 156));
        
    }];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.layer.masksToBounds = YES;
    iconImage.layer.cornerRadius = 75.0/2;
    [iconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"wantP_avatar"]];
    [self.topView addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.topView);
        make.size.equalTo(CGSizeMake(75.0f, 75.0f));

    }];

    // 姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = model.realname;
    [self.topView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.topView);
        make.top.equalTo(iconImage.bottom).with.equalTo(18.0f);
        
    }];
   
    // 性别的图标
    UIImageView *sexImage = [[UIImageView alloc] init];
    if ([model.sex isEqualToString:@"男"]) {
        
        sexImage.image = [UIImage imageNamed:@"man"];
    } else {
    
        sexImage.image = [UIImage imageNamed:@"myHavePatient_fmale"];
    }
    [self.topView addSubview:sexImage];
    [sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(nameLabel.right).with.offset(5);
        make.top.equalTo(iconImage.bottom).with.offset(18);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    // 来自哪个地方
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.selected = NO;
    [button setImage:[UIImage imageNamed:@"白位置"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"来自%@",model.full_region_path] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    [self.topView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.topView);
        make.top.equalTo(nameLabel.bottom).with.offset(10.0f);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 15.0f));
        
    }];
    
    
    // 基本资料前面的小块
    UIView *litterView = [[UIView alloc] init];
    litterView.backgroundColor = UIColorFromRGB(0x36cacc);
    [bgView addSubview:litterView];
    [litterView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(self.topView.bottom).with.offset(15);
        make.size.equalTo(CGSizeMake(5, 18));
    }];
    
    // 基本资料
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.text = @"基本资料";
    label.textColor = UIColorFromRGB(0x36cacc);
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(litterView.right).with.offset(5);
        make.top.equalTo(self.topView.bottom).with.offset(15);
    }];
    
    
    
    return bgView;
}



#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = UIColorFromRGB(0x36cacc);
    [self hidNavBarBottomLine];
    
}

@end
