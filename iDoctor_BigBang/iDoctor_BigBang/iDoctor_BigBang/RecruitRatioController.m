//
//  RecruitRatioController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/17/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "RecruitRatioController.h"
#import "RatioView.h"
#import "RecruitDetailCell.h"
#import "IWantPatientDataManger.h"


@interface RecruitRatioController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) RatioView *ratioView;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) RecruitDetail *recruitDetail;

@end

@implementation RecruitRatioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self getDatas];
}

- (void)getDatas
{
    [IWantPatientDataManger getRecruitDetailWithRecruitId:self.recId success:^(RecruitDetail *recruitDetail) {
        
        self.recruitDetail = recruitDetail;
        [self.ratioView setDataWithRecruitDetail:recruitDetail];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecruitDetailCell *cell = [RecruitDetailCell cellWithTableView:tableView];
    [cell setDataWithRecruitDetail:self.recruitDetail];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RecruitDetailCell height];
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 400)];
        [footer addSubview:self.ratioView];
        [self.ratioView makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(footer);
            make.width.equalTo(250);
            make.height.equalTo(footer);
        }];

        _tableView.tableFooterView = footer;
    }
    return _tableView;
}
- (RatioView *)ratioView
{
    if (_ratioView == nil) {
        _ratioView = [[RatioView alloc] init];
        
         __weak typeof(self) wkSelf = self;
        
        
        [_ratioView setCloseBtnClickBlock:^(NSInteger recruitId) {
            
            [IWantPatientDataManger closeRecruitWithRecruitId:recruitId success:^(NSString *msg) {
                
                
                [wkSelf showTips:msg];
                
                [wkSelf getDatas];
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD showError:error.localizedDescription];
            }];
        }];
    }
    return _ratioView;
}


@end
