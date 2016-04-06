//
//  IDAddNewTemplateViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDAddNewTemplateViewController.h"
#import "IDAddTemplateTableViewCell.h"
#import "ChangeInfoManger.h"

#import "TemplateModel.h"

@interface IDAddNewTemplateViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,IDAddTemplateTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, strong) UITextField *questionField;

// 是否可上传图片
@property (nonatomic, assign) BOOL isUpPicture;

@end

@implementation IDAddNewTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isUpPicture = _model.images;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 32, 44);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    [self.dataArray addObjectsFromArray:_model.fields];
    
    [self setupUI];
   
}

// 保存按钮被点击
- (void)saveButtonClicked:(UIButton *)button
{
    NSDictionary *diction = @{@"name":self.nameField.text,@"age":@(YES),@"sex":@(YES),@"last_time":@(YES),@"description":@(YES),@"images":@(self.isUpPicture),@"fields":self.dataArray};
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    if (self.nameField.text.length == 0 && self.nameField.text == nil) {
        
        alert.message = @"模板名字不能为空";
        [alert show];
        
        return;
    }
    
    if (_model == nil) {
        
        [MBProgressHUD showMessage:@"正在保存..." toView:self.view isDimBackground:NO];
        [ChangeInfoManger addTemplatesWithDiction:diction CompletionHandler:^(TemplateModel *model) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:nil];
            
            // 跳回到第一个页面  进行相应的刷新
            _block();
            [self.navigationController popViewControllerAnimated:YES];
            
            
        } withErrorHandler:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
            
            
        }];
        
    } else {
    
       [MBProgressHUD showMessage:@"正在修改..." toView:self.view isDimBackground:NO];
        [ChangeInfoManger putTemplatesWithDiction:diction templateID:_model.templateId CompletionHandler:^(TemplateModel *model) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:nil];
            
            // 跳回到第一个页面  进行相应的刷新
            _block();
            [self.navigationController popViewControllerAnimated:YES];
            
        } withErrorHandler:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
            
        }];
        
    
    }
    
    
    
    
}

- (void)setupUI
{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
}

- (id)initWithTitle:(NSString *)title
{
    if ([super init]) {
       
        self.title = title;
 
    }
    
    return self;
}

#pragma mark - 表的数据源 和 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    
    if (section == 0) {
        
        row = 1;
    } else if (section == 1) {
    
        row = 2;
        
    } else if (section == 2) {
        
        row = 1;
        
    } else if (section == 3) {
    
        row = 1;
        
    } else if (section == 4) {
    
        row = self.dataArray.count;
    
    }
    
    return row;
}


- (UIView *)segmentView
{
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    return segment;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        
        UITableViewCell *nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        [nameCell.contentView addSubview:self.nameField];
        [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(nameCell.contentView).offset(15);
            make.size.equalTo(CGSizeMake(App_Frame_Width - 15 - 15, 60));
            make.top.equalTo(nameCell.contentView).offset(0);
            
        }];
        
        
        
        cell = nameCell;
        
    } else if (section == 1) {
        
        if (row == 0) {
            
          UITableViewCell *nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            nameCell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            nameCell.textLabel.text = @"问诊项目";
            nameCell.textLabel.textColor = UIColorFromRGB(0x353d3f);
            cell = nameCell;
            
        } else if (row == 1) {
        
            cell = [self getCellWithTableView:tableView indexpath:indexPath];
        
        }
    
    
    } else if (section == 2) {
        
        cell = [self cellWithTableView:tableView indexpath:indexPath];
    
    } else if (section == 3) { // 添加新的自定义问诊项目
        
        cell = [self addNewProjectcellWithTable:tableView indexpath:indexPath];
    
    
    } else if (section == 4) {
    
        IDAddTemplateTableViewCell *addCell = [IDAddTemplateTableViewCell cellWithTableView:tableView indexpath:indexPath];
        addCell.delegate = self;
        [addCell dataWithText:self.dataArray[indexPath.row]];
        cell = addCell;
    
    }
    
    cell.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
    cell.layer.borderWidth = 0.5;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

// 删除按钮的代理
- (void)closeButtonClicked:(UIButton *)button text:(NSString *)text
{
    [self.dataArray removeObject:text];
    [self.tableView reloadData];
}


// 是否可上传症状图
- (UITableViewCell *)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // 可上传图片、
    cell.textLabel.text = @"可上传症状图";
    cell.textLabel.textColor = UIColorFromRGB(0x353d3f);
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
    button.layer.borderWidth = 1;
    button.selected = self.isUpPicture;
    [button setImage:[UIImage imageNamed:@"service_price_right"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-15);
        make.size.equalTo(CGSizeMake(23, 23));
        
    }];
    
    return cell;

}

// 按钮被点击了
- (void)buttonClicked:(UIButton *)button
{
    button.selected = !self.isUpPicture;
    
    self.isUpPicture = button.selected;

}


// 添加新的自定义问诊项目
- (UITableViewCell *)addNewProjectcellWithTable:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [cell.contentView addSubview:self.questionField];
    [self.questionField makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(cell.contentView).offset(15.0f);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 23 - 30, 60));
        
    }];
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setImage:[UIImage imageNamed:@"service_price_add"] forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(newButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:newButton];
    [newButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(cell.contentView).offset(-15);
        make.centerY.equalTo(cell.contentView);
        make.size.equalTo(CGSizeMake(23, 23));
        
    }];
    
    return cell;
    
}

- (void)newButtonClick:(UIButton *)button
{
    if (self.questionField.text.length == 0 && self.questionField == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"自定义问诊项目为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [self.dataArray addObject:self.questionField.text];
    self.questionField.text = nil;
    [self.tableView reloadData];
    
}


// 问诊项目下面的四个条目
- (UITableViewCell *)getCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"service_price_item"];
    [cell.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(App_Frame_Width - 30);
        
    }];
    
    
    return cell;
    
}


- (UILabel *)labelWithName:(NSString *)name
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.layer.masksToBounds = YES;
    nameLabel.layer.cornerRadius = 15.0f;
    nameLabel.text = name;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = UIColorFromRGB(0xc6cbcb);
    
    return nameLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    NSInteger row = indexPath.row;
    CGFloat height = 0;
    
    if (section == 1) {
        if (row == 0) {
            
            height = 50;
            
        } else {
        
            height = 80;
        }
    } else {
        
        height = 60;
        
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.1;
        
    } else {
    
         return 10;
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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


- (UITextField *)nameField
{
    if (_nameField == nil) {
        
        _nameField = [[UITextField alloc] init];
        _nameField.placeholder = @"请给模板起个名称吧";
        _nameField.font = [UIFont systemFontOfSize:14.0f];
        _nameField.delegate = self;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.text = _model.name;
        _nameField.tag = 101;
        
    }
    
    return _nameField;

}

- (UITextField *)questionField
{
    if (_questionField == nil) {
        
        _questionField = [[UITextField alloc] init];
        _questionField.placeholder = @"添加新的自定义问诊模板";
        _questionField.font = [UIFont systemFontOfSize:15.0f];
        _questionField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _questionField.delegate = self;
        _questionField.tag = 102;
    }
    
    return _questionField;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
