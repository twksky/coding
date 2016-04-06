//
//  TemplateController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyTemplateController.h"
#import "ChangeInfoManger.h"
#import "TemplateModel.h"
#import "IDAddNewTemplateViewController.h"
#import "ChatViewController.h"
//@class ChatViewController;

@interface MyTemplateController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 新增模板的按钮
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation MyTemplateController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getData];
    
}



- (void)getData
{
    [self.dataArray removeAllObjects];
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view isDimBackground:NO];
    
    [ChangeInfoManger asyncGetMyTemplatesWithCompletionHandler:^(NSArray *array) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (array.count == 0) {
            
            [self noDataView];
            
        } else {
            
            [self setupUI];
            
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        
        }
 
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(0.0f);
        make.top.equalTo(self.view).with.offset(0.0f);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 30 - 50 - 40));
        
    }];
    
    
    [self.view addSubview:self.addButton];
    [self.addButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).with.offset(15.0f);
        make.bottom.equalTo(self.view).offset(- 15 );
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 50));
        
    }];
    
    
}

// 没有数据的时候显示的view
- (void)noDataView
{
    [self.tableView removeFromSuperview];
    [self.addButton removeFromSuperview];
    
    // 您还没有我的模板的字样
    UILabel *noTemplateLabel = [[UILabel alloc] init];
    noTemplateLabel.font = [UIFont systemFontOfSize:12.0f];
    noTemplateLabel.textColor = UIColorFromRGB(0xa8a8aa);
    noTemplateLabel.textAlignment = NSTextAlignmentCenter;
    noTemplateLabel.text = @"您还没有模板";
    [self.view addSubview:noTemplateLabel];
    [noTemplateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(60 + 20);
        make.width.equalTo(App_Frame_Width);
    }];
    
    // 图片
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@"service_price_litterIcon"];
    [self.view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(60 + 31);
        make.size.equalTo(CGSizeMake(217, 149));
        
    }];
    
    
    // 新增模板的按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.layer.borderColor = UIColorFromRGB(0x36cacc).CGColor;
    addButton.layer.borderWidth = 1;
    [addButton setTitle:@"新增模板" forState:UIControlStateNormal];
    [addButton setTitleColor:UIColorFromRGB(0x36cacc) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addTemplate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(60 + 160);
        make.size.equalTo(CGSizeMake(105, 40));
        
    }];

}


- (void)addTemplate:(UIButton *)button
{
    IDAddNewTemplateViewController *add = [[IDAddNewTemplateViewController alloc] initWithTitle:@"新增问诊模板"];
    
    add.block = ^(){

        [self getData];
        
    };
    
    [self.navigationController pushViewController:add animated:YES];
    
    
}


#pragma mark - 表的数据源  和 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"TemplateControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = UIColorFromRGB(0x353d3f);
    
    TemplateModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [cell.contentView addSubview:segment];
    [segment makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(cell.contentView).with.offset(0);
         make.bottom.equalTo(cell.contentView).with.offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
        
    }];
    
    if([self.delegate isKindOfClass:[ChatViewController class]]){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        
        return nil;
    }
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我的模板";
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = UIColorFromRGB(0xa8a8aa);

    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bgView).offset(15);
        make.centerY.equalTo(bgView);
        
    }];
    
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [bgView addSubview:segment];
    [segment makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView).with.offset(0);
        make.bottom.equalTo(bgView).with.offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
        
    }];
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TemplateModel *model = self.dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectTemplate:)]) {
        
        [self.delegate didSelectTemplate:model];
    }

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (UIButton *)addButton
{
    if (_addButton == nil) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"新增模板" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setBackgroundColor:UIColorFromRGB(0x36cacc)];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_addButton addTarget:self action:@selector(addTemplate:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addButton;
}


@end
