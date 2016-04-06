//
//  IDThreeSelfViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/12.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDThreeSelfViewController.h"
#import "IDSelectTimeViewController.h"
#import "IDselectSymptomViewController.h"
#import "IDRegistSuccessView.h"

#import "AccountManager.h"

#import "IDTabBarController.h"

@interface IDThreeSelfViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

// 相应的tableView
@property (nonatomic, strong) UITableView *tableView;

// textView 进行相应的多行输入
@property (nonatomic, strong) UITextView *textView;

// 创建一个已选和未选的标识
@property (nonatomic, assign) BOOL isTimeSelected;

// 擅长疾病
@property (nonatomic, assign) BOOL isProfessionSelected;


// 用一个字典来保存  相应的个性选择的疾病和体征
@property (nonatomic, strong) NSMutableDictionary *diction;

// 设置一个全局的字典来保存相应的信息
@property (nonatomic, strong) NSMutableDictionary *allDiction;

@end

@implementation IDThreeSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.allDiction setObject:[NSArray array] forKey:@"work_time_list"];
    [self.allDiction setObject:self.textView.text forKey:@"brief"];
    [self.allDiction setObject:[NSArray array] forKey:@"good_disease_list"];
    
    // 可选填
    _isTimeSelected = NO;
    _isProfessionSelected = NO;
    
    self.title = @"个性资料";
    
    [self setupUI];
}

// 创建UI
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 30 - 50 - 44));
        
    }];
    
    // 添加 还剩下一步的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColorFromRGB(0x36cacc);
    [button setTitle:@"完成注册" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(15);
        make.top.equalTo(self.tableView.bottom).with.offset(15);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 50));
        
    }];
}

// 跳到下一个界面
- (void)nextVC
{
    [self.allDiction setObject:self.textView.text forKey:@"brief"];
    
    
    [MBProgressHUD showMessage:@"注册中..." toView:self.view isDimBackground:NO];
    [[AccountManager sharedInstance] registTwoWithDiction:self.allDiction withCompletionHandler:^(Account *account) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [self saveNSUserDefaultsWithLoginName:self.allDiction[@"mobile"] password:self.allDiction[@"password"]];
        
        UIWindow *windown = [UIApplication sharedApplication].keyWindow;
        
        IDRegistSuccessView *successView = [[IDRegistSuccessView alloc] init];
        successView.frame = windown.bounds;
        [windown addSubview:successView];
        
        [UIView animateWithDuration:3.0f animations:^{
            
            successView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [successView removeFromSuperview];
            IDTabBarController *tabBar = [[IDTabBarController alloc] init];
            windown.rootViewController = tabBar;
        }];
        
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
    
    
}


// 将数据存储到相应的地方
- (void)saveNSUserDefaultsWithLoginName:(NSString *)loginName password:(NSString *)password
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:loginName forKey:@"loginName"];
    [userDefault setObject:password forKey:@"password"];
    
    // 同步到磁盘
    [userDefault synchronize];
}


#pragma mark - 表的数据源  和  代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"门诊时间",@"您最擅长的疾病症状(最多3个)"];
    
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0: case 1:{ // 门诊时间   擅长的疾病症状(最多3个)
            static NSString *ident = @"ThreeSelfTableVieCell";
            UITableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:ident];
            if (timeCell == nil) {
                
                timeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
            }
            
            timeCell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            timeCell.textLabel.textColor = UIColorFromRGB(0xa8a8aa);
            timeCell.textLabel.text = array[section];
            
            timeCell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
            timeCell.detailTextLabel.textColor = UIColorFromRGB(0xa8a8aa);
            
            if ((_isTimeSelected == YES && section == 0) || (_isProfessionSelected == YES && section == 1)) { // 已选
                
                timeCell.detailTextLabel.text = @"已选";
                
            } else if(_isTimeSelected == NO && _isProfessionSelected == NO) { // 选填状态
                
                timeCell.detailTextLabel.text = @"选填";
                
            }
            
            timeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell = timeCell;
            
            
        }break;
            
        case 2: { // 简介
            
            cell = [self introCellWithTableView:tableView section:section];
            
        }break;
            
        default:
            break;
    }
    
    
    cell.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
    return cell;
}


// 简介
- (UITableViewCell *)introCellWithTableView:(UITableView *)tableView section:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    UIView *contentView = cell.contentView;
    // 简介两个字
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.text = @"简介";
    label.textColor = UIColorFromRGB(0xa8a8aa);
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15);
        make.top.equalTo(contentView).with.offset(25);
    }];
    
    [contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15);
        make.top.equalTo(label.bottom).with.offset(18);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 150));
        
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        
        
        return 258.0f;
        
        
    } else {
        
        
        return 60;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.1;
        
    } else {
        
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    return bgView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:{ // 门诊时间
            
            IDSelectTimeViewController *selectTime = [[IDSelectTimeViewController alloc] init];
            
            selectTime.selectTimeArray = [self.allDiction objectForKey:@"work_time_list"];
            
            selectTime.block = ^(NSArray *timeArray){
                
                if (timeArray.count != 0) { // 真正意义上的选择了
                    
                    _isTimeSelected = YES;
                    
                    [self.allDiction setObject:timeArray forKey:@"work_time_list"];
                    
                    [self.tableView reloadData];
                }
                
                
            };
            
            [self.navigationController pushViewController:selectTime animated:YES];
            
        } break;
            
        case 1:{ // 您最擅长的疾病症状(最多3个)
            
            IDselectSymptomViewController *selectSympton = [[IDselectSymptomViewController alloc] init];
            
            selectSympton.diction = self.diction;
            
            selectSympton.block = ^(NSArray *array, NSDictionary *diction){
                
                if (diction.count != 0) {
                    
                    _isProfessionSelected = YES;
                    
                    [self.diction setDictionary:diction];
                    
                    [self.allDiction setObject:array forKey:@"good_disease_list"];
    
                    [self.tableView reloadData];
                    
                } else {
                    
                    _isProfessionSelected = NO;
                }
                
            };
            
            [self.navigationController pushViewController:selectSympton animated:YES];
            
            
            
        } break;
            
        default:
            break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}


- (UITextView *)textView
{
    if (_textView == nil) {
        
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15.0f];
        _textView.textColor = UIColorFromRGB(0x353d3f);
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 1.5;
        _textView.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        _textView.layer.borderWidth = 1.0f;
        
    }
    
    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    } else {
        
        return YES;
        
    }
}



- (NSMutableDictionary *)diction
{
    if (_diction == nil) {
        
        
        _diction = [NSMutableDictionary dictionary];
    }
    
    return _diction;
}

- (NSMutableDictionary *)allDiction
{
    if (_allDiction == nil) {
        
        _allDiction = [NSMutableDictionary dictionaryWithDictionary:_twoDiction];
    }
    
    return _allDiction;
}


@end
