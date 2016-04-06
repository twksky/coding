//
//  IDselectSymptomViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/13.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDselectSymptomViewController.h"
#import "IDSymptomSearchViewController.h"

#import "IDSelectSymptomTableViewCell.h"

#import "IDDoctorIsGoodAtDiseaseModel.h"
@interface IDselectSymptomViewController ()<UITableViewDataSource, UITableViewDelegate,IDSelectSymptomTableViewCellDelegate>

{
    UIView * bgView;
}

// 一个放置东西的字典
@property (nonatomic, strong) NSMutableDictionary *dataDiction;

// 用于显示的表
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation IDselectSymptomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.dataDiction setDictionary:_diction];
    
    // 在顶部的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"请输入症状或体征搜索添加" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xa0ddde) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setImage:[UIImage imageNamed:@"myHavePatient_ellipse"] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 7.0f;
    button.layer.borderColor = UIColorFromRGB(0x21b3b5).CGColor;
    button.layer.borderWidth = 1;
    button.backgroundColor = UIColorFromRGB(0x2abec0);
    button.frame = CGRectMake(60, 0, App_Frame_Width - 15 - 80, 35);
    [button addTarget:self action:@selector(selectSymptom:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    [self initBackBarItemBtn];
    
    [self setupUI];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self newAlertView];
}

- (void)initBackBarItemBtn {
    
    if (self.navigationController.childViewControllers.count > 1) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        backButton.frame = CGRectMake(0.0f, 0.0f, 45.0f, 44.0f);
        [backButton setImage:[UIImage imageNamed:@"backBtnImg"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"backBtnImg"] forState:UIControlStateHighlighted];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        [backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
}

- (void)popSelf {
    
    if (self.block) {
        
        NSArray *diseaseArray = self.dataDiction[@"disease"];
        NSArray *symptomArray = self.dataDiction[@"symptom"];
        
        NSMutableArray *array = [NSMutableArray array];
        
        [diseaseArray enumerateObjectsUsingBlock:^(IDDoctorIsGoodAtDiseaseModel *model, NSUInteger idx, BOOL *stop) {
            
            [array addObject:@(model.disease_id)];
            
        }];
        
        [symptomArray enumerateObjectsUsingBlock:^(IDDoctorIsGoodAtDiseaseModel *model, NSUInteger idx, BOOL *stop) {
            
            [array addObject:@(model.disease_id)];
            
        }];
        
        
        
        _block(array, self.dataDiction);

    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 搜索按钮的点击事件
- (void)selectSymptom:(UIButton *)button
{
    [self pushToNextPage];
 
}

// 界面进行相应的跳转
- (void)pushToNextPage
{
    IDSymptomSearchViewController *search = [[IDSymptomSearchViewController alloc] init];
    
    search.diction = self.dataDiction;
    search.searchBlock = ^(NSDictionary *diction){
        
        if (diction.count != 0) { // 看传回来的数据是否为空
            
            [self.dataDiction removeAllObjects];
            
            [self.dataDiction setDictionary:diction];
            
            [self.tableView reloadData];
        }
        
    };
    
    [self.navigationController pushViewController:search animated:YES];
    
    
    
}





// 创建界面的相应元素
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}






#pragma mark - 表的数据源 和  代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger row = 0;
    
    
    if (section == 0) { // 疾病
        
        row = [self.dataDiction[@"disease"] count];
        
    } else { // 症状
        
        
        row = [self.dataDiction[@"symptom"] count];
    }
    
    if (row == 0) { // 证明还没有相应的数据
        
        row = 1;
    }
    
    return row;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    IDSelectSymptomTableViewCell *symptomCell = [IDSelectSymptomTableViewCell cellWithTable:tableView indexPath:indexPath];
    
    symptomCell.delegate = self;
    
    NSInteger section = indexPath.section;
    
    
    if (section == 0) { // 疾病
        
        if ([self.dataDiction[@"disease"] count] == 0) { // 证明没有相应的元素  直接显示"暂未添加"
            
            cell = [self noUserWithTableView:tableView indexPath:indexPath];
            
        } else { // 有相应的元素
            
            NSArray *array = self.dataDiction[@"disease"];
            IDDoctorIsGoodAtDiseaseModel *model = array[indexPath.row];
            
            [symptomCell createCellWithModel:model indexPath:indexPath];
            
            cell = symptomCell;
            
            
        }
        
    } else if (section == 1) { // 症状
        
        if ([self.dataDiction[@"symptom"] count] == 0) { // 证明没有相应的元素  直接显示"暂未添加"
            
            cell = [self noUserWithTableView:tableView indexPath:indexPath];
            
        } else { // 有相应的元素
            
            NSArray *array = self.dataDiction[@"symptom"];
            IDDoctorIsGoodAtDiseaseModel *model = array[indexPath.row];
            [symptomCell createCellWithModel:model indexPath:indexPath];
            cell = symptomCell;
            
        }
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


// 删除按钮被点击了
- (void)deleteButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) { // 疾病
        
        [self deleteObjectWithName:@"disease" row:row];
        
    } else if (section == 1) { // 体征
        
        [self deleteObjectWithName:@"symptom" row:row];
    }
    
}

- (void)deleteObjectWithName:(NSString *)name row:(NSInteger)row
{
    // 取出字典中 相对应的数组
    
    NSArray *array = self.dataDiction[name];
    
    // 删除数组中相应的元素
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:array];
    
    [array1 removeObjectAtIndex:row];
    
    // 更新字典中的数据
    [self.dataDiction setObject:array1 forKey:name];
    
    // 进行表的刷新
    [self.tableView reloadData];
}





// 暂未添加
- (UITableViewCell *)noUserWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"noUserCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:11.0f];
    label.textColor = UIColorFromRGB(0xb7b7b7);
    label.backgroundColor = UIColorFromRGB(0xe5e5e5);
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 3.0f;
    label.text = @"暂未添加";
    label.textAlignment = NSTextAlignmentCenter;
    
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(cell.contentView);
        make.size.equalTo(CGSizeMake(69, 20));
    }];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (section == 0) {
        
        view = [self viewForHeaderInSection:section name:@"疾病(最多3个)"];
        
    } else if (section == 1) {
        
        view = [self viewForHeaderInSection:section name:@"症状或体征(最多3个)"];
        
    }
    
    return view;
    
}


// 根据名字创建一个相应的头部View
- (UIView *)viewForHeaderInSection:(NSInteger)section name:(NSString *)name
{
    // 1 计算View的宽度
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    // 左边的横线
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = UIColorFromRGB(0xeaeaea);
    [bgView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(bgView).with.offset(23);
        make.size.equalTo(CGSizeMake((App_Frame_Width - nameSize.width - 18) / 2, 1));
    }];
    
    // 中间的文字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12.0f];
    nameLabel.textColor = UIColorFromRGB(0xa8a8aa);
    nameLabel.text = name;
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(leftView.right).with.offset(9);
        make.top.equalTo(bgView).with.offset(23 - nameSize.height / 2);
    }];
    
    // 右边的横线
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = UIColorFromRGB(0xeaeaea);
    [bgView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(bgView).with.offset(0);
        make.top.equalTo(bgView).with.offset(23);
        make.size.equalTo(CGSizeMake((App_Frame_Width - nameSize.width - 18) / 2, 1));
    }];
    
    return bgView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([self.dataDiction[@"disease"] count] == 0 && indexPath.section == 0) || ([self.dataDiction[@"symptom"] count] == 0 && indexPath.section == 1)) { // 暂未添加任何的元素  [@"symptom"]:症状  [@"disease"]:疾病
        
        // [self pushToNextPage];
        
    }
    
}




#pragma mark - 懒加载
// 数据字典
- (NSMutableDictionary *)dataDiction
{
    if (_dataDiction == nil) {
        
        _dataDiction = [NSMutableDictionary dictionary];
    }
    
    return _dataDiction;
    
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _tableView;
}

#pragma mark - 自定义提示框

-(void)newAlertView {
    NSUserDefaults * uds = [NSUserDefaults standardUserDefaults];
    NSString * alerts = [uds objectForKey:@"IDSelectSymtom_alerts"];
    if ([alerts isEqualToString:@"agrees"]) {
        
    }else{
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.window.frame), CGRectGetHeight(self.view.window.frame))];
        [self.view.window addSubview:bgView];
        
        UIView * blackView = [[UIView alloc]initWithFrame:bgView.frame];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.5;
        [bgView addSubview:blackView];
        
        UIImageView * myAlertImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IDselectSystem_tips"]];
        myAlertImageView.frame = CGRectMake(50, CGRectGetHeight(self.view.frame)/2 - (CGRectGetWidth(self.view.frame)-80)/3 - 50, CGRectGetWidth(self.view.frame)-80, (CGRectGetWidth(self.view.frame)-80)/1.78);
        [bgView addSubview:myAlertImageView];
        
        UIButton * myBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, CGRectGetHeight(self.view.frame)/2 + (CGRectGetWidth(self.view.frame)-80)/3 - 50, (CGRectGetWidth(self.view.frame)-80)/2-30, ((CGRectGetWidth(self.view.frame)-80)/2-30)/2.67)];
        myBtn1.tag = 1;
        [myBtn1 setBackgroundImage:[UIImage imageNamed:@"ihavePatient_sayyes"] forState:0];
        [myBtn1 addTarget:self action:@selector(alertBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * myBtn2 = [[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-80)/2+50, CGRectGetHeight(self.view.frame)/2 + (CGRectGetWidth(self.view.frame)-80)/3 - 50,(CGRectGetWidth(self.view.frame)-80)/2-30, ((CGRectGetWidth(self.view.frame)-80)/2-30)/2.67)];
        myBtn2.tag = 2;
        [myBtn2 setBackgroundImage:[UIImage imageNamed:@"ihavePatient_notips"] forState:0];
        [myBtn2 addTarget:self action:@selector(alertBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [bgView addSubview:myBtn1];
        [bgView addSubview:myBtn2];
    }
}

-(void)alertBtn:(UIButton *)sender {
    NSUserDefaults * uds = [NSUserDefaults standardUserDefaults];
    if (sender.tag == 1) {
        
        
    }else {
        [uds setObject:@"agrees" forKey:@"IDSelectSymtom_alerts"];
        [uds synchronize];
    }
    
    bgView.hidden = YES;
}

@end
