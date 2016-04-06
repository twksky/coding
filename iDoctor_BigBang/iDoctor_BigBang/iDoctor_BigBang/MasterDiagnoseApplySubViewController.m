//
//  MasterDiagnoseApplyViewController.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "MasterDiagnoseApplySubViewController.h"
#import "QuickDiagnoseManager.h"
#import "MasterDiagnoseCell.h"
#import "MasterDiagnose.h"
#import "MasterDiagnoseDetailViewController.h"

static NSString *const MasterDiagnoseCellIdentifier = @"7f5ea7f4-7210-4e22-bca7-fb3127b29e71";

@interface MasterDiagnoseApplySubViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *masterDiagnoseTableView;

@property (nonatomic, strong) NSArray *masterDiagnoses;

@end

@implementation MasterDiagnoseApplySubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupPullToRefresh];
    [self.masterDiagnoseTableView.header beginRefreshing];
}

- (void)setupViews {
    
    [self.view addSubview:self.masterDiagnoseTableView];
    [self.masterDiagnoseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -
- (void)getMasterDiagnosesWithPage:(NSInteger)page withSize:(NSInteger)size withIsPullToRefresh:(BOOL)isPullToRefresh {
    
    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    [[QuickDiagnoseManager sharedInstance] getMasterDiagnosesWithPage:page withSize:size withCompletionHandler:^(NSArray *masterDiagnoseList) {
        
        
        if (masterDiagnoseList.count == 0) {
            
            [self tipView];
        } else {
        
            self.masterDiagnoses = masterDiagnoseList;
            [self.masterDiagnoseTableView reloadData];
            
            if (isPullToRefresh) {
                
                [self.masterDiagnoseTableView.header endRefreshing];
            }
        
        }
  
    } withErrorHandler:^(NSError *error) {
        
        if (isPullToRefresh) {
            
            [self.masterDiagnoseTableView.header endRefreshing];
        }
        
        [self errorView];
        [self handleError:error];
    }];
}

- (void)getMasterDiagnosesWithPage:(NSInteger)page withSize:(NSInteger)size withIsPushToRefresh:(BOOL)isPushToRefresh {
    
    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    [[QuickDiagnoseManager sharedInstance] getMasterDiagnosesWithPage:page withSize:size withCompletionHandler:^(NSArray *masterDiagnoseList) {
        
        if (masterDiagnoseList.count == 0) {
            
            [self tipView];
            
        } else {
        
            NSMutableArray *masterDiagnosesMutableCopy = [self.masterDiagnoses mutableCopy];
            [masterDiagnosesMutableCopy addObjectsFromArray:masterDiagnoseList];
            self.masterDiagnoses = masterDiagnosesMutableCopy;
            [self.masterDiagnoseTableView reloadData];
            if (isPushToRefresh) {
                
                [self.masterDiagnoseTableView.footer endRefreshing];
                if (masterDiagnoseList.count != size) {
                    
                    [self.masterDiagnoseTableView.footer noticeNoMoreData];
                }
            }
        
        
        }

        
    } withErrorHandler:^(NSError *error) {
        
        if (isPushToRefresh) {
            
            [self.masterDiagnoseTableView.footer endRefreshing];
        }
        
        [self errorView];
        [self handleError:error];
    }];
    
}

- (void)tipView
{
    UIView *noMessage = [self tipViewWithName:@"目前会诊申请采取邀请制\n如愿意提供会诊小结服务的医生\n请和医生助手联系申请资格"];
    [self.view addSubview:noMessage];
    [noMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height));
        
    }];
    
}

- (void)errorView
{
    IDErrorView *errorView = [[IDErrorView alloc] init];
    errorView.block = ^(){
        
        [self setupPullToRefresh];
        
    };
    
    [self.view addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height));
        
    }];
}

#pragma mark - 
- (void)setupPullToRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSInteger page = 1;
        NSInteger size = 20;
        
        if (self.masterDiagnoses.count != 0) {
            
            size = self.masterDiagnoses.count;
        }
        
        [self getMasterDiagnosesWithPage:page withSize:size withIsPullToRefresh:YES];
        
    }];
    self.masterDiagnoseTableView.header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (self.masterDiagnoses.count != 0) {
            
            if (self.masterDiagnoses.count % 20 != 0) {
                
                [self.masterDiagnoseTableView.footer noticeNoMoreData];
                
                
            } else {
                
                NSInteger page = self.masterDiagnoses.count / 20;
                NSInteger size = 20;
                
                [self getMasterDiagnosesWithPage:page withSize:size withIsPushToRefresh:YES];
            }
        } else {
            
            [self.masterDiagnoseTableView.footer endRefreshing];
        }
        
        
        //TODO
    }];
    self.masterDiagnoseTableView.footer = footer;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MasterDiagnose *masterDiagnose = self.masterDiagnoses[indexPath.row];
    MasterDiagnoseDetailViewController *masterDiagnoseDetailVC = [[MasterDiagnoseDetailViewController alloc] initWithMasterDiagnose:masterDiagnose];
    [self.navigationController pushViewController:masterDiagnoseDetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [MasterDiagnoseCell cellHeight];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MasterDiagnose *masterDiagnose = self.masterDiagnoses[indexPath.row];
    MasterDiagnoseCell *cell = [tableView dequeueReusableCellWithIdentifier:MasterDiagnoseCellIdentifier];
    if (!cell) {
        
        cell = [[MasterDiagnoseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MasterDiagnoseCellIdentifier];
    }
    
    // 张丽改
    [cell loadDataWithMasterDiagnose:masterDiagnose ishiden:YES];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.masterDiagnoses count];
}

#pragma mark - Properties
- (UITableView *)masterDiagnoseTableView {
    
	if(_masterDiagnoseTableView == nil) {
        
		_masterDiagnoseTableView = [[UITableView alloc] init];
        _masterDiagnoseTableView.delegate = self;
        _masterDiagnoseTableView.dataSource = self;
        _masterDiagnoseTableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _masterDiagnoseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _masterDiagnoseTableView;
}

- (NSArray *)masterDiagnoses {
    
	if(_masterDiagnoses == nil) {
        
		_masterDiagnoses = [[NSArray alloc] init];
	}
	return _masterDiagnoses;
}

@end
