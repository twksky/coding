//
//  SiteSecondViewController.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/21.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "SiteSecondViewController.h"
#import "HomeViewController.h"
#import "HomeManager.h"

@interface SiteSecondViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) HomeManager *manager;//网络请求
@property (nonatomic, strong) NSMutableArray *regionArr;
@property (nonatomic, strong) NSMutableArray *regionIdArr;
@end

@implementation SiteSecondViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.title = self.title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabelView];
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0.0f));
        make.bottom.equalTo(@(0.0f));
        make.right.equalTo(@(0.0f));
        make.top.equalTo(@(0.0f));
    }];
    [self getData];
}

-(void)getData{
    [self.manager getRegionWithDic:@{@"deepth":[NSString stringWithFormat:@"%ld",(long)self.regionId]} withCompletionHandelr:^(NSArray *arr) {
        NSLog(@"%@",arr);
        for (NSDictionary *dic in arr) {
            if ([[dic objectForKey:@"name"] isEqualToString:@""]) {
                //第一个是个空的，就过滤掉
            }else{
                [self.regionArr addObject:[dic objectForKey:@"name"]];
                [self.regionIdArr addObject:[dic objectForKey:@"id"]];
            }
        }
        [self.tabelView reloadData];
    } withErrorHandler:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}


#pragma mark tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.regionArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indent = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indent];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indent];
        [cell setAccessoryType:UITableViewCellAccessoryNone];//后面小三角形
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, (60-24)/2, self.view.bounds.size.width - 100, 24)];
        label.tag = 101;
        label.textColor = UIColorFromRGB(0x353d3f);
        [cell.contentView addSubview:label];
    }
    ((UILabel *)[cell viewWithTag:101]).text = self.regionArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HomeViewController class]]) {
            [((HomeViewController*)controller).firstHeadView.siteBtn setTitle:self.regionArr[indexPath.row] forState:UIControlStateNormal];
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:self.view.bounds];
        self.tabelView.delegate = self;
        self.tabelView.dataSource = self;
    }
    return _tabelView;
}

-(HomeManager *)manager{
    if (!_manager) {
        _manager = [HomeManager sharedInstance];
    }
    return _manager;
}

-(NSMutableArray *)regionArr{
    if (!_regionArr) {
        _regionArr = [NSMutableArray array];
    }
    return _regionArr;
}

-(NSMutableArray *)regionIdArr{
    if (!_regionIdArr) {
        _regionIdArr = [NSMutableArray array];
    }
    return _regionIdArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
