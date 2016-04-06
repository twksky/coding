//
//  IWantPatientViewController.m
//  iDoctor_BigBang
//
//  Created by hexy on 6/25/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "IWantPatientViewController.h"
#import "IWantPatientCell.h"
#import "MenuView.h"
#import "PatientInfoViewController.h"
#import "IWantPatientDataManger.h"

#import "IDPatientCaseDetailViewController.h"
#import "IDPatientMessageViewController.h"

@interface IWantPatientViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic, strong) MenuView *menuView;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) PatientModel *patientModel;
@property(nonatomic, strong) NSArray *patientModelArray;
@property(nonatomic, strong) NSArray *filterPatientModelArray;
@property(nonatomic, strong) UISearchBar *seachBar;
@property(nonatomic, strong) UISearchDisplayController *seachDC;

@property(nonatomic, strong) FilterRequest *filterRequest;

@property (nonatomic, assign) NSInteger row;


@property (nonatomic, strong) NSArray *patienRecodementArray;


@end

@implementation IWantPatientViewController

-(void)viewWillAppear:(BOOL)animated{
    [self setUpRefreshView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.row = 0;
    
    [self setUpAllViews];
}

- (void)setUpAllViews
{
    [self setUpNav];
    [self setUpTableView];
    [self setUpMenu];
    
    if (self.isRecomment) {
        
        [self setDatas];
        
    } else {
        
         [self setUpRefreshView];
    
    }

//    [self setUpRefreshView];
}

- (void)setUpSearchDC
{
    self.seachDC = [[UISearchDisplayController alloc] initWithSearchBar:self.seachBar contentsController:self];
    self.seachDC.searchResultsTableView.backgroundColor = IWantPatientCellSelectedColor;
    self.seachDC.searchResultsTableView.contentInset = UIEdgeInsetsMake(43, 0, IWantPatientCellMargin, 0);
    self.seachDC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.seachDC.delegate = self;
    self.seachDC.searchResultsDataSource = self;
    self.seachDC.searchResultsDelegate = self;
    
}



/**
 *  集成上拉刷新和下拉刷新
 */
- (void)setUpRefreshView
{
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        // 加载新数据
        if (self.isRecomment) {
            
            [self setDatas];
            
        } else {
            
            [self loadNewData];
            
        }
    }];
    self.tableView.header = header;
    
    // 下拉刷新
//    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        
//        // 加载旧数据
////        [self loadMoreData];
//    }];
    
    // 进入页面后自动开始刷新
    [self.tableView.header beginRefreshing];
}


- (void)loadNewData
{
    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
            
        }
    }

  
    [IWantPatientDataManger getPatientsWithFilterRequest:self.filterRequest success:^(NSArray *patientsArray) {
        
    
        self.patienRecodementArray = patientsArray;
   
        self.patientModelArray = patientsArray;
        
        
        
        if (self.patientModelArray.count == 0) {
            
            [self tipView];
            
        } else {
            
            [self.tableView reloadData];
            
        }
        
        [self.tableView.header endRefreshing];
        
        
        
    } failure:^(NSError *error) {
        
        self.row = 0;
        
        [self errorView];
        [self.tableView.header endRefreshing];
        
        
    }];
    
    
//    [IWantPatientDataManger getPatientsWithFilterRequest:self.filterRequest success:^(PatientsModel *patients) {
//        
//        [MBProgressHUD hideHUDForView:self.view];
//        self.patientModelArray = patients.patient_medicals;
//        
//        if (self.patientModelArray.count == 0) {
//            
//            [self tipView];
//            
//        } else {
//        
//            [self.tableView reloadData];
//        
//        }
//
//        [self.tableView.header endRefreshing];
//
//    } failure:^(NSError *error) {
//
//    }];
    
}


- (void)setDatas
{
    
    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
            
        }
    }
    
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view isDimBackground:NO];
    [IWantPatientDataManger getPatientRecommendWithSuccess:^(NSArray *array) {
        
        [self hideLoading];
        
        self.patientModelArray = array;
        
        if (self.patienRecodementArray.count == 0) {
            
            [self tipView];
            
        } else {
            
            [self.tableView reloadData];
            
        }

    } failure:^(NSError *error) {
        
        [self hideLoading];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

- (void)errorView
{
    IDErrorView *errorView = [[IDErrorView alloc] init];
    errorView.block = ^(){
    
        if (self.row == 0) {
            
            if (self.isRecomment) {
                
                [self setDatas];
                
            } else {
                
                [self setUpRefreshView];
                
            }
            
        } else if (self.row == 1) {
        
            [self searchBarSearchButtonClicked:self.seachBar];
        }

    };
    
    [self.view addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(50);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 50));
        
    }];
}


- (void)tipView
{
    UIView *noMessage = [self tipViewWithName:@"暂时没有患者哦!"];
    [self.view addSubview:noMessage];
    [noMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(50);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 50));
        
    }];

}


- (void)setUpNav
{
    self.title = @"我要患者";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"wantP_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)search
{
    [self.menuView hideMenu];
    if (_seachBar == nil) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.seachBar];
    }
//    self.seachBar.hidden = NO;
    [self setUpSearchDC];
    [self.seachBar becomeFirstResponder];
}
- (void)setUpMenu
{
    self.menuView = [[MenuView alloc] init];
    __weak typeof(self) wkSelf = self;
    [_menuView setRegionFilterBlock:^(NSNumber *regionId) { // 地区id
        
//        wkSelf.filterRequest.category = nil;
//        wkSelf.filterRequest.rank = nil;
//        wkSelf.filterRequest.keyword = nil;
//        
//        wkSelf.filterRequest.region_id = regionId;
//        [wkSelf loadNewData];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"试运营，仅限保定地区" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        wkSelf.patientModelArray = wkSelf.patienRecodementArray;
        
        if (wkSelf.patientModelArray.count == 0) {
            
            [wkSelf tipView];
            
        } else {
            
            [wkSelf.tableView reloadData];
            
        }
        
    }];
    
    [_menuView setCategoryFilterBlock:^(NSString *categoryName, NSNumber *rank) { // 分类名字 等级
        
        wkSelf.filterRequest.region_id = nil;
        wkSelf.filterRequest.keyword = nil;

        wkSelf.filterRequest.category = categoryName;
        wkSelf.filterRequest.rank = rank;
        [wkSelf loadNewData];
        
    }];
    
    [self.view addSubview:_menuView];
    [_menuView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(49);
    }];
}

- (void)setUpTableView
{
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        
        return self.patientModelArray.count;

    } else {
        return self.filterPatientModelArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IWantPatientCell *cell = [IWantPatientCell cellWithTableView:tableView];
    
    if (tableView == self.tableView) {
       
        [cell setDataWithPatientModel:self.patientModelArray[indexPath.row]];
        
    } else {
        
        [cell setDataWithPatientModel:self.filterPatientModelArray[indexPath.row]];
    }
   
    
    [cell setAvatarClickBlock:^(PatientModel *patientModel, IDMedicaledModel *medicaledModel) {
       
        IDPatientMessageViewController *message = [[IDPatientMessageViewController alloc] init];
        message.model = patientModel;
        
        [self.navigationController pushViewController:message animated:YES];
    }];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    IDMedicaledModel *model = nil;

    
    if (tableView == self.tableView) {
        
         model = self.patientModelArray[indexPath.row];
        
    } else {
        
         model = self.filterPatientModelArray[indexPath.row];
    }
    
   
    IDPatientCaseDetailViewController *pInfo = [[IDPatientCaseDetailViewController alloc] init];
    pInfo.model = model;
    [self.navigationController pushViewController:pInfo animated:YES];
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [IWantPatientCell height];

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // GDLog(@"%@",searchText);
    
    self.filterRequest.keyword = searchText;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.filterRequest.category = nil;
    self.filterRequest.rank = nil;
    self.filterRequest.region_id = nil;
    [self showMessage:@"搜索中..."];
    
    [IWantPatientDataManger getPatientsWithFilterRequest:self.filterRequest success:^(NSArray *patientsArray) {
        self.filterPatientModelArray = patientsArray;
        
        [self hideLoading];
        if (self.filterPatientModelArray.count == 0) {
            
            [self tipView];
            
        } else {
            
            for (UIView *view in self.view.subviews) {
                
                if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
                    
                    [view removeFromSuperview];
                    
                    break;
                }
                
                
            }
            
            
            [self.seachDC.searchResultsTableView reloadData];
            
        }
        
        [self hidMessage];
        
        
    } failure:^(NSError *error) {
        [self hideLoading];
        
        self.row = 1;
        
        [self errorView];
        
        [self hidMessage];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
//    [IWantPatientDataManger getPatientsWithFilterRequest:self.filterRequest success:^(PatientsModel *patients) {
//        
     //   self.filterPatientModelArray = patients.patient_medicals;
        
    
//
//    } failure:^(NSError *error) {
//        

//    }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.seachBar setShowsCancelButton:NO animated:YES];
    [self.seachBar resignFirstResponder];
    [self.seachBar removeFromSuperview];
    self.seachBar = nil;
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.seachBar removeFromSuperview];
    self.seachBar = nil;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor =IWantPatientCellSelectedColor;
        _tableView.contentInset = UIEdgeInsetsMake(49, 0, IWantPatientCellMargin+49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (UISearchBar *)seachBar
{
    if (_seachBar == nil) {
        _seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 64)];
        _seachBar.delegate = self;
//        _seachBar.barStyle = UIBarStyleBlack;
        _seachBar.placeholder = @"搜索";
        _seachBar.tintColor = [UIColor whiteColor];
        UIImage *image = [UIImage createImageWithColor:UIColorFromRGB(0x36cacc)];
        [_seachBar setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        _seachBar.barTintColor = [UIColor clearColor];
        UIImage *img = [UIImage createImageWithColor:UIColorFromRGB(0x2abec0) andSize:CGSizeMake(App_Frame_Width - 10, 30)];
        UIImage *rImg = [UIImage createRoundedRectImage:img size:CGSizeMake(App_Frame_Width - 10, 30) radius:6];
        [_seachBar setSearchFieldBackgroundImage:rImg forState:UIControlStateNormal];
    }
    return _seachBar;
}

- (NSArray *)patientModelArray
{
    if (_patientModelArray == nil) {
        _patientModelArray = [NSArray array];
    }
    return _patientModelArray;
}
- (NSArray *)filterPatientModelArray
{
    if (_filterPatientModelArray == nil) {
        _filterPatientModelArray = [NSArray array];
    }
    return _filterPatientModelArray;

}
- (FilterRequest *)filterRequest
{
    if (_filterRequest == nil) {
        _filterRequest = [[FilterRequest alloc] init];
    }
    return _filterRequest;
}

- (NSArray *)patienRecodementArray
{
    if (_patienRecodementArray == nil) {
        
        _patienRecodementArray = [NSArray array];
    }
    
    return _patienRecodementArray;
}


@end
