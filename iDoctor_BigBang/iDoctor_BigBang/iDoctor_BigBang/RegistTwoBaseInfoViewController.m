//
//  RegistTwoBaseInfoViewController.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/9/29.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "RegistTwoBaseInfoViewController.h"
#import "ProvinceController.h"
#import "HospitalController.h"
#import "DepartmentController.h"
#import "TitleCheckController.h"

#import "IDThreeSelfViewController.h"
#import "AccountManager.h"

@interface RegistTwoBaseInfoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *baseInfoTableView;

// 输入姓名的输入框
@property (nonatomic, strong) UITextField *nameField;

// 创建一个临时的按钮
@property (nonatomic, strong) UIButton *tempButton;

// 电话号码的输入框
@property (nonatomic, strong) UITextField *phoneField;


// 地区
@property (nonatomic, strong) NSString *regin;
// 医院
@property (nonatomic, strong) NSString *hospital;
// 科室
@property (nonatomic, strong) NSString *department;
// 职称
@property (nonatomic, strong) NSString *profession;

// 地区id
@property (nonatomic, assign) NSInteger regin_id;
// 医院id
@property (nonatomic, assign) NSInteger hospital_id;


@end

@implementation RegistTwoBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

#pragma mark - 
- (void)setupViews {
    
    self.navigationItem.title = @"基本资料";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.regin = @"";
    self.hospital = @"";
    self.department = @"";
    self.profession = @"";
    
    
    [self.view addSubview:self.baseInfoTableView];
    [self.baseInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 50 - 30 - 44));
        
    }];
    
    
    // 添加 还剩下一步的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColorFromRGB(0x36cacc);
    [button setTitle:@"还剩一步" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).with.offset(15);
        make.top.equalTo(self.baseInfoTableView.bottom).with.offset(15);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 50));
        
    }];
    
 
}

// 跳到下一个界面
- (void)nextVC
{
    
    IDThreeSelfViewController *threeSelf = [[IDThreeSelfViewController alloc] init];

    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:_oneDiction];
    
    // 姓名
    NSString *name = self.nameField.text;
    
    // 性别
    NSString *sex = self.tempButton.titleLabel.text;
    
    // 办公室电话
    NSString *phone = self.phoneField.text;
    
    if (name.length == 0 || name == nil || sex.length == 0 || sex == nil || self.regin_id == 0 || self.hospital_id == 0 || self.department.length == 0 || self.department == nil || self.profession.length == 0 || self.profession == nil || phone.length == 0 || phone == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息填写不全，请填写完全!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    

    [mutableDic setObject:name forKey:@"realname"];
    [mutableDic setObject:sex forKey:@"sex"];
    [mutableDic setObject:@(self.regin_id) forKey:@"region_id"];
    [mutableDic setObject:@(self.hospital_id) forKey:@"hospital_id"];
    [mutableDic setObject:self.department forKey:@"department"];
    [mutableDic setObject:phone forKey:@"office_phone"];
    [mutableDic setObject:self.profession forKey:@"title"];
    
    threeSelf.twoDiction = mutableDic;
    
    [self.navigationController pushViewController:threeSelf animated:YES];


}

#pragma mark -
- (UILabel *)commonLabel {
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:UIColorFromRGB(0xa8a8aa)];
    label.font = [UIFont systemFontOfSize:15.0f];
    
    return label;
}

- (UITextField *)commonFiled {
    
    UITextField *field = [[UITextField alloc] init];
    field.font = [UIFont systemFontOfSize:15.0f];
    field.textColor = UIColorFromRGB(0x353d3f);
    field.delegate = self;
    return field;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (UIView *)commonLine {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xeaeaea);
    return view;
}


- (UIButton *)commonButtontitle:(NSString *)title
{
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [Button setImage:[UIImage imageNamed:@"myHavePatient_active"] forState:UIControlStateSelected];
    [Button setImage:[UIImage imageNamed:@"myHavePatient_inactive"] forState:UIControlStateNormal];
    [Button setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
    [Button setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateSelected];
    Button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [Button setTitle:title forState:UIControlStateNormal];
    [Button setTitle:title forState:UIControlStateSelected];
    Button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [Button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return Button;
}

// 按钮的点击事件
- (void)buttonClicked:(UIButton *)button
{
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    
    if (self.tempButton == button) // 现在点击的是同一个按钮
        return;
    
    // 点击的不是同一个button的时候进行的相应的操作
    self.tempButton.selected = NO;
    button.selected = YES;
    self.tempButton = button;
    
}


#pragma mark - Properties
- (UITableView *)baseInfoTableView
{
    if (_baseInfoTableView == nil) {
        
        _baseInfoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _baseInfoTableView.delegate = self;
        _baseInfoTableView.dataSource = self;
        _baseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _baseInfoTableView;
}

- (UITextField *)nameField
{
    if (_nameField == nil) {
        
        _nameField = [self commonFiled];
    }
    
    return _nameField;
}

- (UITextField *)phoneField
{
    if (_phoneField == nil) {
        
        _phoneField = [self commonFiled];
    }
    
    return _phoneField;
}


#pragma mark - tableView 的数据源 和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case 0: {// 姓名
          
            cell = [self nameTableViewCellWithTab:tableView row:row];
            
        }break;
            
        case 1:{ // 性别
            
            cell = [self sexTableViewCellWithTab:tableView row:row];
            
        } break;
            
        case 2: case 3: case 4:case 5: { // 地区 医院 科室 职称
        
            cell = [self threeTableViewCellWithTab:tableView row:row];
        
        } break;
            
        case 6: { // 办公室电话
        
            cell = [self phoneTableViewCellWithTab:tableView row:row];
        
        } break;
            
            
        default:
            break;
    }
    
    
    UIView *segment = [self commonLine];
    [cell.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell).with.offset(15);
        make.right.equalTo(cell).with.offset(-15);
        make.bottom.equalTo(cell.contentView).with.offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 1));
        
    }];
    

    return cell;

}

// 姓名
- (UITableViewCell *)nameTableViewCellWithTab:(UITableView *)tableView row:(NSInteger)row
{
    
    UITableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (nameCell == nil) {
        
        nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    UIView *contentVeiw = nameCell.contentView;
    
    // 姓名两个字
    UILabel *nameLabel = [self commonLabel];
    nameLabel.text = @"姓名";
    [contentVeiw addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentVeiw).with.offset(15);
        make.top.equalTo(contentVeiw).with.offset(0);
        make.size.equalTo(CGSizeMake(75, 59));

    }];
    
    // 输入框
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contentVeiw addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(nameLabel.right).with.offset(0);
        make.top.equalTo(contentVeiw).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30 - 75, 60));

    }];
    
     nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return nameCell;


}


// 性别
- (UITableViewCell *)sexTableViewCellWithTab:(UITableView *)tableView row:(NSInteger)row
{
    UITableViewCell *sexCell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (sexCell == nil) {
        
        sexCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    UIView *contentVeiw = sexCell.contentView;
    
    // 性别两个字
    UILabel *sexLabel = [self commonLabel];
    sexLabel.text = @"性别";
    [contentVeiw addSubview:sexLabel];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentVeiw).with.offset(15);
        make.top.equalTo(contentVeiw).with.offset(0);
        make.size.equalTo(CGSizeMake(75, 59));
        
    }];
    
    // 男  实心的
    UIButton *maleButton = [self commonButtontitle:@"男"];
    maleButton.selected = YES;
    self.tempButton = maleButton;
    [contentVeiw addSubview:maleButton];
    [maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(sexLabel.right).with.offset(0);
        make.top.equalTo(contentVeiw).with.offset(19);
        make.size.equalTo(CGSizeMake(41.0f, 22.0f));
        
    }];
    
    // 女  空心的
    UIButton *fmaleButton = [self commonButtontitle:@"女"];
    [contentVeiw addSubview:fmaleButton];
    [fmaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(maleButton.right).with.offset(45);
        make.top.equalTo(contentVeiw).with.offset(19);
        make.size.equalTo(CGSizeMake(41.0f, 22.0f));
        
    }];
    
     sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return sexCell;


}

// 地区 医院 科室 职称
- (UITableViewCell *)threeTableViewCellWithTab:(UITableView *)tableView row:(NSInteger)row
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    
    UIView *contentView = cell.contentView;
    
    
    NSArray *array = @[@"地区",@"医院",@"科室",@"职称"];
    NSArray *detailArray = @[self.regin, self.hospital, self.department,self.profession];
    
    
    UILabel *Label = [self commonLabel];
    Label.text = array[row - 2];
    [contentView addSubview:Label];
    [Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15);
        make.top.equalTo(contentView).with.offset(0);
        make.size.equalTo(CGSizeMake(75, 59));
        
    }];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.detailTextLabel.textColor = UIColorFromRGB(0xa8a8aa);
    cell.detailTextLabel.text = detailArray[row - 2];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;


}


// 办公电话
- (UITableViewCell *)phoneTableViewCellWithTab:(UITableView *)tableView row:(NSInteger)row
{

    UITableViewCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (phoneCell == nil) {
        
        phoneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    UIView *contentVeiw = phoneCell.contentView;
    
    // 姓名两个字
    UILabel *nameLabel = [self commonLabel];
    nameLabel.text = @"办公室电话";
    [contentVeiw addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentVeiw).with.offset(15);
        make.top.equalTo(contentVeiw).with.offset(0);
        make.size.equalTo(CGSizeMake(80, 59));
        
    }];
    
    // 输入框
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contentVeiw addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(nameLabel.right).with.offset(0);
        make.top.equalTo(contentVeiw).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30 - 75, 60));
        
    }];

    phoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return phoneCell;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0 && indexPath.row != 6) {
        
        [self.nameField resignFirstResponder];
        [self.phoneField resignFirstResponder];
        
    }
    
   
    NSInteger row = indexPath.row;
    
    switch (row) {
        case 2:{ // 地区
            
            ProvinceController *province = [[ProvinceController alloc] init];
            [province setXxBlock:^(NSString *fullPath, NSInteger ID) {
                
                self.regin = fullPath;
                self.regin_id = ID;
                [self.baseInfoTableView reloadData];

            }];
            [self.navigationController pushViewController:province animated:YES];
        
        }break;
        case 3:{ // 医院
            
            HospitalController *hospital = [[HospitalController alloc] init];
            hospital.regionId = self.regin_id;
            [hospital setXxBlock:^(NSString *hospatalName, NSInteger ID) {
              
                self.hospital = hospatalName;
                self.hospital_id = ID;
                [self.baseInfoTableView reloadData];
                
            }];
            
            [self.navigationController pushViewController:hospital animated:YES];
            
        }break;
        case 4:{ // 科室
            
            DepartmentController *department = [[DepartmentController alloc] init];
            [department setXxxxBlock:^(NSString *dpName) {
               
                self.department = dpName;
                [self.baseInfoTableView reloadData];
                
                
            }];
            [self.navigationController pushViewController:department animated:YES];
            
        }break;
        case 5:{ // 职称
            TitleCheckController *titleCheck = [[TitleCheckController alloc] init];
            [titleCheck setXxxBlock:^(NSString *title) {
               
                self.profession = title;
                [self.baseInfoTableView reloadData];
                
            }];
            
            [self.navigationController pushViewController:titleCheck animated:YES];
            
        }break;
        default:
            break;
    }
 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
