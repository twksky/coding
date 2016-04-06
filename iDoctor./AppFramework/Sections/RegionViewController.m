//
//  RegionViewController.m
//  AppFramework
//
//  Created by ABC on 6/6/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "RegionViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "AccountManager.h"
#import "AppUtil.h"
#import "MBProgressHUD.h"

@interface RegionViewController () <RegionViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *regionTableView;

@property (nonatomic, assign) NSInteger     regionCodeCopy;
@property (nonatomic, strong) RegionItem    *regionItem;
@property (nonatomic, strong) NSMutableDictionary *regionItemDic;
@property (nonatomic, strong) NSArray       *sortedKeysArray;
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation RegionViewController

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
        self.regionCodeCopy = regionCode;
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
    self.title = @"所在地区";
    
    [self.view addSubview:self.regionTableView];
    [self.view addConstraints:[self.regionTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];

    [self.progressHUD show:YES];
    [[AccountManager sharedInstance] asyncGetRegionWithRegionCode:self.regionCodeCopy withCompletionHandler:^(RegionItem *regionItem) {
        self.regionItem = regionItem;
        for (RegionItem *theRegionItem in regionItem.subItemArray) {
            if ([theRegionItem.pinYinName length] > 1) {
                NSString *firstChar = [theRegionItem.pinYinName substringWithRange:NSMakeRange(0, 1)];
                firstChar = [firstChar uppercaseString];
                if (![[self.regionItemDic allKeys] containsObject:firstChar]) {
                    if (![self.regionItemDic objectForKey:firstChar]) {
                        [self.regionItemDic setObject:[[NSMutableArray alloc] init] forKey:firstChar];
                    }
                }
                [[self.regionItemDic objectForKey:firstChar] addObject:theRegionItem];
            }
        }
        
        if ([self.regionItemDic count] > 0) {
            self.sortedKeysArray = [[self.regionItemDic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
        
        [self.progressHUD hide:YES];
        [self.regionTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
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

- (UITableView *)regionTableView
{
    if (!_regionTableView) {
        _regionTableView = [[UITableView alloc] init];
        _regionTableView.dataSource = self;
        _regionTableView.delegate = self;
        _regionTableView.sectionIndexColor = [UIColor grayColor];
    }
    return _regionTableView;
}

- (NSMutableDictionary *)regionItemDic
{
    if (!_regionItemDic) {
        _regionItemDic = [[NSMutableDictionary alloc] init];
    }
    return _regionItemDic;
}

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.labelText = @"请稍候...";
    }
    return _progressHUD;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sortedKeysArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.sortedKeysArray objectAtIndex:section];
    NSInteger contactCount = [[self.regionItemDic objectForKey:key] count];
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
    NSArray *regionItemsArray = [self.regionItemDic objectForKey:key];
    RegionItem *item = [regionItemsArray objectAtIndex:[indexPath row]];
    [cell.textLabel setText:item.name];
    if (item.subItemArray) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.sortedKeysArray objectAtIndex:[indexPath section]];
    NSArray *regionItemsArray = [self.regionItemDic objectForKey:key];
    RegionItem *item = [regionItemsArray objectAtIndex:[indexPath row]];
    if (item.level < 3) {
        RegionViewController *regionViewController = [[RegionViewController alloc] initWithRegionCode:item.code];
        regionViewController.delegate = self;
        [self.navigationController pushViewController:regionViewController animated:YES];
    } else {
        if ([self.delegate respondsToSelector:@selector(regionViewController:didSelectedRegionItem:)]) {
            [self.delegate regionViewController:self didSelectedRegionItem:item];
        }
    }
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


#pragma mark - RegionViewControllerDelegate

- (void)regionViewController:(RegionViewController *)viewController didSelectedRegionItem:(RegionItem *)regionItem
{
    if ([self.delegate respondsToSelector:@selector(regionViewController:didSelectedRegionItem:)]) {
        [self.delegate regionViewController:self didSelectedRegionItem:regionItem];
    }
}

@end
