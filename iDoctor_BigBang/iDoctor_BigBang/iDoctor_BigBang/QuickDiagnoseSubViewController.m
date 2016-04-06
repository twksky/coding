//
//  QuickDiagnoseSubViewController.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseSubViewController.h"
#import "QuickDiagnoseDetailViewController.h"
#import "QuickDiagnoseCell.h"
#import "QuickDiagnose.h"
#import "QuickDiagnoseManager.h"
#import "QuickDiagnoseMenuView.h"

#import <MJRefresh.h>
#import <Masonry.h>

@interface QuickDiagnoseSubViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
QuickDiagnoseMenuViewDelegate
>

@property (nonatomic, strong) UITableView *quickDiagnoseTableView;
@property (nonatomic, strong) UIButton *locationSelectButton;
@property (nonatomic, strong) UIButton *departmentSelectButton;
@property (nonatomic, strong) QuickDiagnoseMenuView *menuView;

@property (nonatomic, strong) NSArray *quickDiagnoseList;
@property (nonatomic, strong) NSString *currentDepartment;
@property (nonatomic, assign) NSInteger currentRegionId;

@end

@implementation QuickDiagnoseSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentRegionId = -1;
    [self setupViews];
    [self setupPullToRefresh];
    [self.quickDiagnoseTableView.header beginRefreshing];
}

#pragma mark - 
- (void)setupViews {
    
//    [self.view addSubview:self.locationSelectButton];
//    [self.locationSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.and.left.equalTo(self.view);
//        make.width.equalTo(Main_Screen_Width / 2.0f);
//        make.height.equalTo(50.0f);
//    }];
//    
//    [self.view addSubview:self.departmentSelectButton];
//    [self.departmentSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.and.right.equalTo(self.view);
//        make.width.equalTo(Main_Screen_Width / 2.0f);
//        make.height.equalTo(50.0f);
//    }];
    
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
//        make.top.and.left.and.right.equalTo(self.view);
//        make.height.equalTo(50.0f);
    }];
    
    [self.view addSubview:self.quickDiagnoseTableView];
    [self.quickDiagnoseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(50.0f);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

#pragma mark - pullToRefresh
- (void)setupPullToRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSInteger page = 1;
        NSInteger size = 20;
        
        if (self.quickDiagnoseList.count != 0) {
            
            size = self.quickDiagnoseList.count;
        }
        
        [self getDiagnoseListWithDepartment:self.currentDepartment withRegionId:_currentRegionId withPage:page withSize:size withIsPullToRefresh:YES];
    }];
    self.quickDiagnoseTableView.header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (self.quickDiagnoseList.count != 0) {
            
            if (self.quickDiagnoseList.count % 20 != 0) {
                
                [self.quickDiagnoseTableView.footer noticeNoMoreData];
            } else {
                
                NSInteger page = self.quickDiagnoseList.count / 20;
                NSInteger size = 20;
                [self getDiagnoseListWithDepartment:self.currentDepartment withRegionId:_currentRegionId withPage:page withSize:size withIsPushToRefresh:YES];
            }
        } else {
            
            [self.quickDiagnoseTableView.footer endRefreshing];
        }
        
        
        //TODO
    }];
    self.quickDiagnoseTableView.footer = footer;
}

#pragma mark - getData
- (void)getDefautDiagnoseList {
    
    [self getDiagnoseListWithDepartment:self.currentDepartment withRegionId:_currentRegionId withPage:0 withSize:20 withIsPullToRefresh:NO];
}

- (void)getDiagnoseListWithDepartment:(NSString *)department withRegionId:(NSInteger)regionId withPage:(NSInteger)page withSize:(NSInteger)size withIsPullToRefresh:(BOOL)isPullToRefresh {
    
    [[QuickDiagnoseManager sharedInstance] getQuickDiagnoseListWithDepartment:department withRegion:regionId withPage:page withSize:size withCompletionHandler:^(NSArray *quickDiagnoseList) {
        
        self.quickDiagnoseList = quickDiagnoseList;
        [self.quickDiagnoseTableView reloadData];
        
        if (isPullToRefresh) {
            
            [self.quickDiagnoseTableView.header endRefreshing];
        }
        
    } withErrorHandler:^(NSError *error) {
        
        [self handleError:error];
    }];
}

- (void)getDiagnoseListWithDepartment:(NSString *)department withRegionId:(NSInteger)regionId withPage:(NSInteger)page withSize:(NSInteger)size withIsPushToRefresh:(BOOL)isPushToRefresh {
    
    [[QuickDiagnoseManager sharedInstance] getQuickDiagnoseListWithDepartment:department withRegion:regionId withPage:page withSize:size withCompletionHandler:^(NSArray *quickDiagnoseList) {
        
        NSMutableArray *quickDiganoseListMutableCopy = [self.quickDiagnoseList mutableCopy];
        [quickDiganoseListMutableCopy addObjectsFromArray:quickDiagnoseList];
        self.quickDiagnoseList = quickDiganoseListMutableCopy;
        
        [self.quickDiagnoseTableView reloadData];
        
        if (isPushToRefresh) {
            
            [self.quickDiagnoseTableView.footer endRefreshing];
            if (quickDiagnoseList.count != size) {
                
                [self.quickDiagnoseTableView.footer noticeNoMoreData];
            }
        }
        
    } withErrorHandler:^(NSError *error) {
        
        [self handleError:error];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.quickDiagnoseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuickDiagnoseCellIdentifier = @"732afcf3-0468-485b-a86a-1b1ffe32c3ae";
    
    QuickDiagnose *quickDiagnose = self.quickDiagnoseList[indexPath.row];
    QuickDiagnoseCell *cell = [tableView dequeueReusableCellWithIdentifier:QuickDiagnoseCellIdentifier];
    if (!cell) {
        
        cell = [[QuickDiagnoseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuickDiagnoseCellIdentifier];
    }
    
    // 张丽修改
    [cell loadData:quickDiagnose ishiden:YES];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuickDiagnose *quickDiagnose = self.quickDiagnoseList[indexPath.row];
    QuickDiagnoseDetailViewController *quickDiagnoseVC = [[QuickDiagnoseDetailViewController alloc] initWithQuickDiagnose:quickDiagnose];
    [self.navigationController pushViewController:quickDiagnoseVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [QuickDiagnoseCell cellHeight];
}

#pragma mark - QuickDiagnoseMenuViewDelegate
- (void)didSelectLocation:(NSInteger)regionId {
    
    _currentRegionId = regionId;
    [self.quickDiagnoseTableView.footer resetNoMoreData];
    [self getDefautDiagnoseList];
}

- (void)didSelectDepartment:(NSString *)department {
    
    self.currentDepartment = department;
    [self.quickDiagnoseTableView.footer resetNoMoreData];
    [self getDefautDiagnoseList];
}

- (void)didShowMenuView {
    
    [self.view bringSubviewToFront:self.menuView];
}

- (void)didHideMenuView {
    
    [self.view bringSubviewToFront:self.quickDiagnoseTableView];
}

#pragma mark - Properties

- (UITableView *)quickDiagnoseTableView {
    
	if(_quickDiagnoseTableView == nil) {
        
		_quickDiagnoseTableView = [[UITableView alloc] init];
        _quickDiagnoseTableView.delegate = self;
        _quickDiagnoseTableView.dataSource = self;
        _quickDiagnoseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _quickDiagnoseTableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
	}
	return _quickDiagnoseTableView;
}

- (UIButton *)locationSelectButton {
    
	if(_locationSelectButton == nil) {
        
		_locationSelectButton = [[UIButton alloc] init];
        [_locationSelectButton setTitle:@"按地区" forState:UIControlStateNormal];
        [_locationSelectButton setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
        _locationSelectButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        ViewBorderRadius(_locationSelectButton, 0.0f, 0.7f, UIColorFromRGB(0xeaeaea));
	}
	return _locationSelectButton;
}

- (UIButton *)departmentSelectButton {
    
	if(_departmentSelectButton == nil) {
        
		_departmentSelectButton = [[UIButton alloc] init];
        [_departmentSelectButton setTitle:@"按科室" forState:UIControlStateNormal];
        [_departmentSelectButton setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
        _departmentSelectButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        ViewBorderRadius(_departmentSelectButton, 0.0f, 0.7f, UIColorFromRGB(0xeaeaea));
	}
	return _departmentSelectButton;
}

- (NSArray *)quickDiagnoseList {
    
	if(_quickDiagnoseList == nil) {
        
		_quickDiagnoseList = [[NSArray alloc] init];
	}
	return _quickDiagnoseList;
}

- (QuickDiagnoseMenuView *)menuView {
    
	if(_menuView == nil) {
        
		_menuView = [[QuickDiagnoseMenuView alloc] init];
        _menuView.delegate = self;
	}
	return _menuView;
}

- (NSString *)currentDepartment {
    
	if(_currentDepartment == nil) {
        
		_currentDepartment = @"全部";
	}
    
	return _currentDepartment;
}

@end
