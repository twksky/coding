//
//  HospitalListViewController.m
//  AppFramework
//
//  Created by ABC on 7/19/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "HospitalListViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "AccountManager.h"
#import "MBProgressHUD.h"
#import "AppUtil.h"

@interface HospitalListViewController () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UITableView   *contentTableView;
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@property (nonatomic, strong) NSArray   *hospitalArray;
@property (nonatomic, assign) NSInteger regionCode;
@property (nonatomic, strong) NSMutableDictionary *hospitalDic;
@property (nonatomic, strong) NSArray *sortedKeysArray;

@end

@implementation HospitalListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRegionCode:(NSInteger)regionCode
{
    self = [super init];
    if (self) {
        self.regionCode = regionCode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    self.title = @"医院列表";
    
    [self.view addSubview:self.contentTableView];
    [self.view addConstraints:[self.contentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.progressHUD show:YES];
    [[AccountManager sharedInstance] asyncGetHospitalListWithRegionCode:self.regionCode withCompletionHandler:^(NSArray *hospitalListArray) {
        self.hospitalArray = hospitalListArray;
        
        for (HospitalItem *theHospitalItem in self.hospitalArray) {
            theHospitalItem.pinYinName = [AppUtil pinyinFromChiniseString:theHospitalItem.name];
            NSString *firstChar = [theHospitalItem.pinYinName substringWithRange:NSMakeRange(0, 1)];
            firstChar = [firstChar uppercaseString];
            if (![[self.hospitalDic allKeys] containsObject:firstChar]) {
                if (![self.hospitalDic objectForKey:firstChar]) {
                    [self.hospitalDic setObject:[[NSMutableArray alloc] init] forKey:firstChar];
                }
            }
            [[self.hospitalDic objectForKey:firstChar] addObject:theHospitalItem];
        }
        
        if ([self.hospitalDic count] > 0) {
            self.sortedKeysArray = [[self.hospitalDic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
        
        [self.contentTableView reloadData];
        [self.progressHUD hide:YES];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Property

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] init];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        _contentTableView.sectionIndexColor = [UIColor grayColor];
    }
    return _contentTableView;
}

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"请稍候...";
    }
    return _progressHUD;
}

- (NSMutableDictionary *)hospitalDic
{
    if (!_hospitalDic) {
        _hospitalDic = [[NSMutableDictionary alloc] init];
    }
    return _hospitalDic;
}

#pragma mark - UITableViewDatasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sortedKeysArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.sortedKeysArray objectAtIndex:section];
    NSInteger contactCount = [[self.hospitalDic objectForKey:key] count];
    return contactCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableCellIdentifier = @"F511E163-D23B-4F04-9B02-AA7765B72C13";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
    }
    NSString *key = [self.sortedKeysArray objectAtIndex:[indexPath section]];
    HospitalItem *item = [[self.hospitalDic objectForKey:key] objectAtIndex:[indexPath row]];
    if (item) {
        [cell.textLabel setText:item.name];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.sortedKeysArray objectAtIndex:[indexPath section]];
    HospitalItem *item = [[self.hospitalDic objectForKey:key] objectAtIndex:[indexPath row]];
    if ([self.delegate respondsToSelector:@selector(hospitalListViewController:didSelectedHospitalItem:)]) {
        [self.delegate hospitalListViewController:self didSelectedHospitalItem:item];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.sortedKeysArray objectAtIndex:section];
    return key;
}

// 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sortedKeysArray;
}


#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (hud) {

    }
}

@end
