//
//  DiagnoseReplyRecordSubViewController.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "DiagnoseReplyRecordSubViewController.h"
#import "RepliedQuickDiagnoseCell.h"
#import "QuickDiagnose.h"
#import "QuickDiagnoseManager.h"
#import "QuickDiagnoseDetailViewController.h"

static NSString *const RepliedQuickDiagnoseCellIdentifier = @"fe68b0a1-1b6b-47a1-9454-742bb905916e";

@interface DiagnoseReplyRecordSubViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSArray *repliedQuickDiagnoses;

@property (nonatomic, strong) UITableView *repliedQuickDiagnoseTableView;

@end

@implementation DiagnoseReplyRecordSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupPullToRefresh];
    [self.repliedQuickDiagnoseTableView.header beginRefreshing];
}


#pragma mark - 
- (void)setupViews {
    
    [self.view addSubview:self.repliedQuickDiagnoseTableView];
    [self.repliedQuickDiagnoseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

- (void)setupPullToRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSInteger page = 1;
        NSInteger size = 20;
        
        if (self.repliedQuickDiagnoses.count != 0) {
            
            size = self.repliedQuickDiagnoses.count;
        }
        
        [self getRepliedQuickDiagnoseWithPage:page withSize:size withIsPullToRefresh:YES];
        
    }];
    self.repliedQuickDiagnoseTableView.header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (self.repliedQuickDiagnoses.count != 0) {
            
            if (self.repliedQuickDiagnoses.count % 20 != 0) {
                
                [self.repliedQuickDiagnoseTableView.footer noticeNoMoreData];
            } else {
                
                NSInteger page = self.repliedQuickDiagnoses.count / 20;
                NSInteger size = 20;
                
                [self getRepliedQuickDiagnoseWithPage:page withSize:size withIsPushToRefresh:YES];
            }
        } else {
            
            [self.repliedQuickDiagnoseTableView.footer endRefreshing];
        }
        
        
        //TODO
    }];
    self.repliedQuickDiagnoseTableView.footer = footer;
}

#pragma mark - PullToRefresh
- (void)getRepliedQuickDiagnoseWithPage:(NSInteger)page withSize:(NSInteger)size withIsPullToRefresh:(BOOL)isPullToRefresh {

    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) ||[view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    
    [[QuickDiagnoseManager sharedInstance] getRepliedQuickDiagnosesWithPage:page withSize:size withCompletionHandler:^(NSArray *quickDiagnoseList) {
        
        if (quickDiagnoseList.count == 0) {
            
            [self tipView];
        } else {
        
            self.repliedQuickDiagnoses = quickDiagnoseList;
            [self.repliedQuickDiagnoseTableView reloadData];
        
            if (isPullToRefresh) {
                
                [self.repliedQuickDiagnoseTableView.header endRefreshing];
            }
        
        }

    } withErrorHandler:^(NSError *error) {
        
        if (isPullToRefresh) {
            
            [self.repliedQuickDiagnoseTableView.header endRefreshing];
        }
        
        [self errorView];
        [self handleError:error];
    }];
}

- (void)getRepliedQuickDiagnoseWithPage:(NSInteger)page withSize:(NSInteger)size withIsPushToRefresh:(BOOL)isPushToRefresh {
    
    
    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    [[QuickDiagnoseManager sharedInstance] getRepliedQuickDiagnosesWithPage:page withSize:size withCompletionHandler:^(NSArray *quickDiagnoseList) {
        
        
        if (quickDiagnoseList.count == 0) {
            
            [self tipView];
        } else {
        
            NSMutableArray *repliedQuickDiagnosesMutableCopy = [self.repliedQuickDiagnoses mutableCopy];
            [repliedQuickDiagnosesMutableCopy addObjectsFromArray:quickDiagnoseList];
            self.repliedQuickDiagnoses = repliedQuickDiagnosesMutableCopy;
            [self.repliedQuickDiagnoseTableView reloadData];
            if (isPushToRefresh) {
                
                [self.repliedQuickDiagnoseTableView.footer endRefreshing];
                if (quickDiagnoseList.count != size) {
                    
                    [self.repliedQuickDiagnoseTableView.footer noticeNoMoreData];
                }
            }

        }
  
    } withErrorHandler:^(NSError *error) {
        
        if (isPushToRefresh) {
            
            [self.repliedQuickDiagnoseTableView.footer endRefreshing];
        }
        
        [self errorView];
        [self handleError:error];
    }];
}



- (void)tipView
{
    UIView *noMessage = [self tipViewWithName:@"您还没有回复记录"];
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

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuickDiagnose *quickDiagnose = self.repliedQuickDiagnoses[indexPath.row];
    RepliedQuickDiagnoseCell *cell = [tableView dequeueReusableCellWithIdentifier:RepliedQuickDiagnoseCellIdentifier];
    if (!cell) {
        
        cell = [[RepliedQuickDiagnoseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepliedQuickDiagnoseCellIdentifier];
    }
    
    
    // 张丽改
    [cell loadData:quickDiagnose];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.repliedQuickDiagnoses count];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [RepliedQuickDiagnoseCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuickDiagnose *quickDiagnose = self.repliedQuickDiagnoses[indexPath.row];
    QuickDiagnoseDetailViewController *quickDiagnoseDetailVC = [[QuickDiagnoseDetailViewController alloc] initWithQuickDiagnose:quickDiagnose];
    [self.navigationController pushViewController:quickDiagnoseDetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableView *)repliedQuickDiagnoseTableView {
    
	if(_repliedQuickDiagnoseTableView == nil) {
        
		_repliedQuickDiagnoseTableView = [[UITableView alloc] init];
        _repliedQuickDiagnoseTableView.delegate = self;
        _repliedQuickDiagnoseTableView.dataSource = self;
        _repliedQuickDiagnoseTableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _repliedQuickDiagnoseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _repliedQuickDiagnoseTableView;
}

- (NSArray *)repliedQuickDiagnoses {
    
	if(_repliedQuickDiagnoses == nil) {
        
		_repliedQuickDiagnoses = [[NSArray alloc] init];
	}
	return _repliedQuickDiagnoses;
}

@end
