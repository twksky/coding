//
//  IWantRecruitController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/17/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "IWantRecruitController.h"
#import "IWantPatientDataManger.h"
@interface IWantRecruitController ()

@property (nonatomic, strong) RecruitRequest *request;

@property (nonatomic, strong) UITextView *descTV;

@end

@implementation IWantRecruitController

- (void)viewDidLoad {
    
    self.request = [[RecruitRequest alloc] init];
    
    [super viewDidLoad];
    [self setupFootBtn];
    [self addTableView];
        // 设置数据
    [self setUpData];
    
}
- (void)setupFootBtn
{
    UIButton *footBtn = [[UIButton alloc] init];
    footBtn.backgroundColor = kNavBarColor;
    footBtn.layer.cornerRadius = 2;
    [footBtn addTarget:self action:@selector(footBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footBtn setTitle:@"发布" forState:UIControlStateNormal];
    [self.view addSubview:footBtn];
    [footBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(15);
        make.bottom.right.equalTo(self.view).offset(-15);
        make.height.equalTo(50);
    }];

}
- (void)footBtnClick
{
    
    self.request.desc = self.descTV.text;
    
    
    
    [IWantPatientDataManger addRecruitWithRecruitRequest:self.request success:^(NSString *msg) {
        
        [self showTips:msg];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
- (void)addTableView
{
    [self.view addSubview:self.tbv];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 200)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.text = @"具体描述";
    lb.textColor = kDefaultFontColor;
    [footer addSubview:lb];
    [lb makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footer).offset(23);
        make.left.equalTo(footer).offset(15);
    }];
    // hack 手段 遮挡横线
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [footer addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footer).offset(-2);
        make.left.equalTo(footer);
        make.height.equalTo(4);
        make.width.equalTo(15);
    }];//end
    
    self.descTV = [[UITextView alloc] init];
    self.descTV .layer.borderWidth = 1;
    self.descTV .layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
    self.descTV .layer.cornerRadius = 2;
    [footer addSubview:self.descTV ];
    [self.descTV  makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lb.bottom).offset(11);
        make.left.equalTo(footer).offset(15);
        make.bottom.right.equalTo(footer).offset(-15);
    }];
    self.tbv.backgroundColor = [UIColor whiteColor];
    self.tbv.tableFooterView = footer;
    [self.tbv makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-80);
    }];
}
- (void)setUpData
{
    [self setUpSection0];
    [self setUpSection1];
}
- (void)setUpSection0
{
    RecruitTitleRowModel *recruit = [RecruitTitleRowModel recruitTitleRowModelWithTitle:@"标题" placeholder:@"标题15字内" keyboardType:UIKeyboardTypeDefault];
    [recruit setTextFieldDidEndEditingBlock:^(NSString *text) {
       
    self.request.title = text;
       
        
    }];

    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[recruit]];
    [self.sectionModelArray addObject:sectionModel];
}
- (void)setUpSection1
{
    
    CheckBoxRowModel *sex = [CheckBoxRowModel checkBoxRowModelWithTitle:@"性别" CheckboxTitleArray:@[@"男", @"女", @"不限"]];
    [sex setCheckBoxCheckedBlock:^(NSString *text) {
    
        self.request.sex = text;
        
        
    }];

    CheckBoxRowModel *age = [CheckBoxRowModel checkBoxRowModelWithTitle:@"年龄" CheckboxTitleArray:@[@"老", @"中", @"幼儿",@"不限"]];
    [age setCheckBoxCheckedBlock:^(NSString *text) {
        
        
        self.request.age = text;
    }];
    RecruitTitleRowModel *people = [RecruitTitleRowModel recruitTitleRowModelWithTitle:@"需要人数" placeholder:@"在此输入人数值" keyboardType:UIKeyboardTypeNumberPad];
    
    [people setTextFieldDidEndEditingBlock:^(NSString *text) {
      
        self.request.need_people = @([text integerValue]);

    }];

   
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[sex, age, people]];
    [self.sectionModelArray addObject:sectionModel];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0.1 : 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIButton *headBtn = [[UIButton alloc] init];
        headBtn.bounds = CGRectMake(0, 0, App_Frame_Width, 20);
        headBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
        headBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        headBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        headBtn.titleLabel.font = GDFont(14);
        [headBtn setTitle:@"想招募的病人的类型" forState:UIControlStateNormal];
        [headBtn setTitleColor:UIColorFromRGB(0xc8c8c8) forState:UIControlStateNormal];
        return headBtn;
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIView *tool = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 44)];
    tool.backgroundColor = GDRandomColor;
    
    GDLog(@"%@",self.view.subviews);
    
    for (UIView *child in self.view.subviews) {
        
        if ([child isKindOfClass:[UITableView class]]) {
            GDLog(@"xxxxx");
            GDLog(@"%@",child.subviews);
            return;
        }
    }
    
}
@end
