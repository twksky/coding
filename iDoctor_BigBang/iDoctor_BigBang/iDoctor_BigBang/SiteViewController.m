//
//  SiteViewController.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/21.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "SiteViewController.h"
#import "SiteSecondViewController.h"
#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HomeManager.h"
#import "IDLocationManager.h"

typedef enum{
    Klocating,//定位中
    Klocated_f,//定位失败
    Klocated_s//定位成功
} Location;

@interface SiteViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) NSInteger locationStatus;
@property (nonatomic, strong) HomeManager *manager;//网络请求
@property (nonatomic, strong) NSMutableArray *regionArr;
@property (nonatomic, strong) NSMutableArray *regionIdArr;
@end

@implementation SiteViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.title = @"北京";//默认北京
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
    [self location];
    [self getData];
}

-(void)getData{
    [self.manager getRegionWithDic:@{@"deepth":@"1"} withCompletionHandelr:^(NSArray *arr) {
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

//定位
-(void)location{
    //定位
    self.locationStatus = Klocating;
    ((UILabel *)[self.view viewWithTag:88]).text = @"定位中...";
    [self.locationManager startUpdatingLocation];
}

#pragma mark tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.regionArr.count;//ToDo
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = UIColorFromRGB(0xf3f3f4);
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0x999999);
        label.text = @"          当前所在的城市";
        return label;
    }else{
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = UIColorFromRGB(0xf3f3f4);
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0x999999);
        label.text = @"          全部";
        return label;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *locationCellID = @"locationCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationCellID];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            UIImageView *iMV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"位置"]];
            iMV.center = CGPointMake(40, 30);
            [cell.contentView addSubview:iMV];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iMV.frame)+10, (60-24)/2, self.view.bounds.size.width - 100, 24)];
            label.tag = 88;
            cell.tag = 89;
            label.textColor = UIColorFromRGB(0x353d3f);
            [cell.contentView addSubview:label];
        }
        cell.selectionStyle = NO;
        if (self.locationStatus == Klocating) {
            
            ((UILabel *)[cell viewWithTag:88]).text = @"定位中...";
            
        }else if (self.locationStatus == Klocated_f){
            
            ((UILabel *)[cell viewWithTag:88]).text = @"定位失败";
            
        }
        return cell;
        
    }else{
        static NSString *cellID = @"myCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, (60-24)/2, self.view.bounds.size.width - 100, 24)];
            label.tag = 101;
            label.textColor = UIColorFromRGB(0x353d3f);
            [cell.contentView addSubview:label];
        }
            ((UILabel *)[cell viewWithTag:101]).text = self.regionArr[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (self.locationStatus == Klocating) {
            [self location];
            [MBProgressHUD showSuccess:@"正在定位中..." toView:self.view];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"正在定位中");
        }else if (self.locationStatus == Klocated_f){
            [self location];
            [MBProgressHUD showSuccess:@"正在定位中..." toView:self.view];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"定位失败");
        }else if (self.locationStatus == Klocated_s){
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[HomeViewController class]]) {
                    [((HomeViewController*)controller).firstHeadView.siteBtn setTitle:((UILabel *)[self.view viewWithTag:88]).text forState:UIControlStateNormal];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }else{
        SiteSecondViewController *sSVC = [SiteSecondViewController new];
        sSVC.regionId = [self.regionIdArr[indexPath.row] integerValue];
        sSVC.title = self.regionArr[indexPath.row];
        [self.navigationController pushViewController:sSVC animated:YES];
    }
}

#pragma mark - location定位
// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
    self.locationStatus = Klocated_f;
    ((UILabel *)[self.view viewWithTag:88]).text = @"定位失败";
    ((UITableViewCell *)[self.view viewWithTag:89]).selected = NO;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%lu", (unsigned long)[locations count]);
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    [manager stopUpdatingLocation];
    
    //位置反编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
                           [self.manager postLocationWithDic:@{
                                                              @"longitude": [NSString stringWithFormat:@"%f",oldCoordinate.longitude],
                                                              @"latitude": [NSString stringWithFormat:@"%f",oldCoordinate.latitude]
                                                              } withCompletionHandelr:^(NSArray *arr) {
                                                                  //成功
                                                                  ((UILabel *)[self.view viewWithTag:88]).text = [[place addressDictionary] objectForKey:@"State"];
                                                                  
                                                                IDLocationManager *locationsM = [IDLocationManager sharedInstance];
                                                                locationsM.location = [[place addressDictionary] objectForKey:@"State"];
                                                                  
                                                                  
                                                                  self.locationStatus = Klocated_s;
                                                              } withErrorHandler:^(NSError *error) {
                                                                  //失败
                                                              }];
                       }
                   }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@", @"ok");
}

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        if (IS_IOS8 || IS_IOS9)
        {
            [_locationManager requestAlwaysAuthorization];//***

        }
        _locationManager.delegate = self;
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    }
    return _locationManager;
}

-(HomeManager *)manager{
    if (!_manager) {
        _manager = [HomeManager sharedInstance];
    }
    return _manager;
}

-(UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:self.view.bounds];
        self.tabelView.delegate = self;
        self.tabelView.dataSource = self;
    }
    return _tabelView;
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
