// o
//  HomeViewController.m
//  
//
//  Created by 周世阳 on 15/9/14.
//
//

#import "HomeViewController.h"

#import "HomeSecondHeadView.h"
#import "HomeTableViewCell.h"
#import "IWantPatientViewController.h"
#import "CardViewController.h"
#import "SiteViewController.h"
#import "HomeManager.h"
#import "HomeInfoModel.h"
#import "HomeInfoViewController.h"
#import "HomeInfoRequestModel.h"
#import "IDHaveViewController.h"
#import "PatientRecommendViewController.h"
#import "QuickDiagnoseViewController.h"
#import "IDCardView.h"

#import "DataBaseManger.h"

#import "IDRegistSuccessView.h"

#import <MJRefresh.h>

#import "AccountManager.h"
#import "Account.h"
#import "IDDoctorIsGoodAtDiseaseModel.h"
#import "IDselectSymptomViewController.h"
#import "ChangeInfoManger.h"

typedef NS_ENUM(NSInteger,getDataStatus){
    up,//下拉新的数据
    down//上拉加载更多的数据
};

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)  UITableView *homeTableView;
@property (nonatomic, strong) HomeManager *manager;//网络请求
@property (nonatomic, strong) HomeSecondHeadView *secondHeadView;
@property (nonatomic, strong) HomeTableViewCell *homeCell;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) FMDatabaseQueue *queue;
@property (nonatomic, strong) MJRefreshNormalHeader *header;
@property (nonatomic, strong) UIView *menuView;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
////        [self refresh];
//    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //代理
//    self.homeTableView.delegate = self;
//    self.homeTableView.dataSource = self;
//    [self getDataWith:up];
    [self setupRefresh];
    [self.homeTableView.header beginRefreshing];
    [self dataWithDataBase];//加数据库缓存
    [[HomeManager sharedInstance] checkVersionUpdate];
}

-(void)dataWithDataBase{
    HomeInfoRequestModel *request = [[HomeInfoRequestModel alloc] init];
    request.page = @1;
    request.size = @10;
    //先从缓存里面读
    NSMutableArray *arr = [DataBaseManger getHomeInfoWithData:request];
    if (arr.count) {
        for (NSDictionary *dic in arr) {
            HomeInfoModel *model = [HomeInfoModel objectWithKeyValues:dic];
            [self.dataArr addObject:model];
        }
        [self.homeTableView reloadData];
    }
}

#pragma mark - 得到数据，判断是上拉还是下拉

-(void)getDataWith:(getDataStatus)status{
    
    static int page = 1;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //刷新新的数据
    if (status == up) {
        HomeInfoRequestModel *request = [[HomeInfoRequestModel alloc] init];
        page = 1;
        request.page = @(page);
        request.size = @10;
        
        [self.manager getHomeInfoWithModel:request withCompletionHandelr:^(NSArray *arr) {
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in arr) {
                HomeInfoModel *model = [HomeInfoModel objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.homeTableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.homeTableView.header endRefreshing];
            [self.homeTableView.footer resetNoMoreData];
            [self fmdbAdd];//加数据库
        } withErrorHandler:^(NSError *error) {
            [self.homeTableView.header endRefreshing];
        }];
    }else if (status == down){
        //加载更多的数据
        HomeInfoRequestModel *request = [[HomeInfoRequestModel alloc] init];
        ++page;
        request.page = @(page);
        request.size = @10;
        
        [self.manager getHomeInfoWithModel:request withCompletionHandelr:^(NSArray *arr) {
            
            for (NSDictionary *dic in arr) {
                HomeInfoModel *model = [HomeInfoModel objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.homeTableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.homeTableView.footer endRefreshing];
            
            if (!arr.count) {
                
//                [self.homeTableView.footer endRefreshingWithNoMoreData];
            }
            
        } withErrorHandler:^(NSError *error) {
            
            [self.homeTableView.footer endRefreshing];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //会在IOS7崩溃  但是又没找到在替代方法, 所以先暂时这样处理
    if (IOS_VERSION > 8.0) {
        
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = UIColorFromRGB(0x00AEB1);
        CGFloat yOffset = self.homeTableView.contentOffset.y;
        [self.homeTableView addSubview:v];
        
        //向上偏移量变正  向下偏移量变负
        if (yOffset < -5) {
            CGFloat factor = ABS(yOffset);
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake([[UIScreen mainScreen] bounds].size.width*factor/64, factor));
                make.left.equalTo(-([[UIScreen mainScreen] bounds].size.width*factor/64-[[UIScreen mainScreen] bounds].size.width)/2);
                make.top.equalTo(-ABS(yOffset)-5);
            }];
        }
    }
    
    
//    else {
//        CGRect f = v.frame;
//        f.origin.y = 0;
//        [v mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake([[UIScreen mainScreen] bounds].size.width, 0));
//            make.left.equalTo(0);
//            make.top.equalTo(-50);
//        }];
//    }
}

-(void)fmdbAdd{
    //缓存
    [DataBaseManger addHomeInfoWithData:self.dataArr];
}

#pragma mark - mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return (458+300)/2;//头
    }else {
        return 50;//图文播报
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20/2;//头,图文播报间隙
    }else {
        return 0.001;//给0会出现默认的空隙
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.firstHeadView;
    }else{
        return self.secondHeadView;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else {
        return self.dataArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (30+30+102)/2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.homeCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"homeCell"];
    if (!self.homeCell) {
        self.homeCell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    self.homeCell.selectionStyle = UITableViewCellAccessoryNone;
//    self.homeCell.backgroundColor = [UIColor colorWithRed:((arc4random()%100)+100)/255.0 green:150.0/255.0 blue:120.0/255.0 alpha:1];

    [self fitToCellWithModel:self.dataArr[indexPath.row]];
    
    return self.homeCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeInfoViewController *homeInfoVC = [[HomeInfoViewController alloc]initWithUrlString:((HomeInfoModel *)self.dataArr[indexPath.row])];
    [self.navigationController pushViewController:homeInfoVC animated:YES];
}

-(void)fitToCellWithModel:(id)model{
    self.homeCell.titleLabel.text = ((HomeInfoModel*)model).title;
    //自适应
    self.homeCell.titleLabel.numberOfLines = 1;
    CGSize ts = [self.homeCell.titleLabel boundWithSize:14 WithSize:CGSizeMake(self.view.frame.size.width - 96 - 30, 100)];
    self.homeCell.titleLabel.fHeight = ts.height;
    [self.homeCell.titleLabel sizeToFit];//必须要写中间
    self.homeCell.titleLabel.fWidth = ts.width;
    
    self.homeCell.contentLabel.text = ((HomeInfoModel*)model).short_desc;
    //自适应
    self.homeCell.contentLabel.numberOfLines = 2;
    CGSize cs = [self.homeCell.contentLabel boundWithSize:12 WithSize:CGSizeMake(self.view.frame.size.width - 96 - 30, 100)];
    self.homeCell.contentLabel.fWidth = cs.width;
    self.homeCell.contentLabel.fHeight = cs.height;
    [self.homeCell.contentLabel sizeToFit];
    //调整高度
    self.homeCell.contentLabel.fY = CGRectGetMaxY(self.homeCell.titleLabel.frame) + 6;
    
    //图片
    [self.homeCell.pic sd_setImageWithURL:[NSURL URLWithString:((HomeInfoModel*)model).banner_url]];
}

#pragma mark - setupRefresh
- (void)setupRefresh {
    
    self.homeTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 加载新数据
        [self getDataWith:up];
    }];

    // 上拉刷新
    self.homeTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        // 加载旧数据
        [self getDataWith:down];
    }];
    
    self.homeTableView.header.backgroundColor = UIColorFromRGB(0x00AEB1);
}


#pragma mark - BtnClicked
//名片
-(void)cardClick:(UIButton *)btn{
    CardViewController *cardVC = [[CardViewController alloc] initForView:self.menuView];
    [cardVC showInViewController:self.tabBarController center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
//选择地区，北京
-(void)selectSite:(UIButton *)btn{
    SiteViewController *sVC = [[SiteViewController alloc]init];
    sVC.title = self.firstHeadView.siteBtn.titleLabel.text;
    [self.navigationController pushViewController:sVC animated:YES];
}

-(void)iWantToPatient:(UIButton *)btn{
    IWantPatientViewController *iwp = [[IWantPatientViewController alloc] init];
    
    [self.navigationController pushViewController:iwp animated:YES];
}

-(void)iHavePatient:(UIButton *)btn{
    
    IDHaveViewController *have = [[IDHaveViewController alloc] init];
    [self.navigationController pushViewController:have animated:YES];
    
}

-(void)patientRecomment:(UIButton *)btn{

    PatientRecommendViewController *prv = [[PatientRecommendViewController alloc] init];
    prv.title = @"患者推荐";
    [self.navigationController pushViewController:prv animated:YES];
}

- (void)toQuickDiagnoseVC:(UIButton *)sender {
    
    QuickDiagnoseViewController *quickDiagnoseVC = [[QuickDiagnoseViewController alloc] init];
    [self.navigationController pushViewController:quickDiagnoseVC animated:YES];
}

- (void)toDiseaseTag:(id)sender
{
    IDselectSymptomViewController *selectedSymptom = [[IDselectSymptomViewController alloc] init];
    
    Account *model = [AccountManager sharedInstance].account;
    NSArray *array = model.skills;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [array enumerateObjectsUsingBlock:^(IDDoctorIsGoodAtDiseaseModel *model, NSUInteger idx, BOOL *stop) {
        
        // 疾病
        if (model.type == 1) { // 疾病
            
            NSMutableArray *array = [NSMutableArray array];
            
            [array addObjectsFromArray:diction[@"disease"]];
            
            [array addObject:model];
            
            [diction setObject:array forKey:@"disease"];
            
        } else if (model.type == 2) {
        
            NSMutableArray *array = [NSMutableArray array];
            
            [array addObjectsFromArray:diction[@"symptom"]];
            
            [array addObject:model];
            
            [diction setObject:array forKey:@"symptom"];
        
        }
  
    }];
    
    selectedSymptom.diction = diction;
    
    selectedSymptom.block = ^(NSArray *array, NSDictionary *diction) {
    
    
    InfoChangeRequest *request = [InfoChangeRequest request];
        request.good_disease_list = array;
        
        [MBProgressHUD showMessage:@"正在修改..." toView:self.view isDimBackground:NO];
        [ChangeInfoManger changeInfoWithInfoChangeRequest:request accountId:kAccount.doctor_id success:^(Account *account) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"修改成功"];
            [AccountManager saveAccount:account];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
            
            
        }];
    
    };
    
    [self.navigationController pushViewController:selectedSymptom animated:YES];
    
}


-(UITableView *)homeTableView{
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_homeTableView];
        [_homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
        }];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
    }
    return _homeTableView;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
         _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(HomeFirstHeadView *)firstHeadView{
    if (!_firstHeadView) {
        _firstHeadView = [[[NSBundle mainBundle] loadNibNamed:@"HomeFirstHeadView" owner:nil options:nil] objectAtIndex:0];
        _firstHeadView.delegate = self;
    }
    return _firstHeadView;
}

-(HomeSecondHeadView *)secondHeadView{
    if (!_secondHeadView) {
        _secondHeadView = [[[NSBundle mainBundle] loadNibNamed:@"HomeSecondHeadView" owner:nil options:nil] objectAtIndex:0];
    }
    return _secondHeadView;
}

-(HomeManager *)manager{
    if (!_manager) {
        _manager = [HomeManager sharedInstance];
    }
    return _manager;
}

-(FMDatabaseQueue *)queue{
    if (!_queue) {
        NSString *path = [NSString stringWithFormat:@"%@/iDoctorDataBase.sqlite",NSHomeDirectory()];
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _queue;
}

-(UIView *)menuView{
    if(!_menuView){
        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"IDCardView" owner:self options:nil] objectAtIndex:0];
        [(IDCardView *)_menuView getData];
        
    }
    return _menuView;
}


@end
