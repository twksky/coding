//
//  DepartmentsViewController.m
//  AppFramework
//
//  Created by ABC on 7/8/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "DepartmentsViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "AppUtil.h"
#import "BaseMainViewController.h"

@interface DepartmentsViewController () <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) UITableView *departmentTableView;

@property (nonatomic, strong) NSMutableArray *departmentsResult;
@property (nonatomic, strong) NSMutableDictionary *departmentsDic;
@property (nonatomic, strong) NSArray *sortedKeysArray;

// Selector
- (void)rightNavigationBarItemAction:(id)sender;

@end

@implementation DepartmentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.title = @"医院科室";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightNavigationBarItemAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"departments" ofType:@"xml"];
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    if (xmlData) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
        [parser setDelegate:self];
        [parser parse];
    }
    
    if ([self.departmentsDic count] > 0) {
        self.sortedKeysArray = [[self.departmentsDic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    [self.view addSubview:self.departmentTableView];
    [self.view addConstraints:[self.departmentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.departmentTableView setEditing:YES animated:YES];
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

- (UITableView *)departmentTableView
{
    if (!_departmentTableView) {
        _departmentTableView = [[UITableView alloc] init];
        _departmentTableView.dataSource = self;
        _departmentTableView.delegate = self;
        _departmentTableView.allowsMultipleSelectionDuringEditing = YES;
        _departmentTableView.sectionIndexColor = [UIColor grayColor];
    }
    return _departmentTableView;
}

- (NSMutableArray *)departmentsResult
{
    if (!_departmentsResult) {
        _departmentsResult = [[NSMutableArray alloc] init];
    }
    return _departmentsResult;
}

- (NSMutableDictionary *)departmentsDic
{
    if (!_departmentsDic) {
        _departmentsDic = [[NSMutableDictionary alloc] init];
    }
    return _departmentsDic;
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sortedKeysArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.sortedKeysArray objectAtIndex:section];
    NSInteger contactCount = [[self.departmentsDic objectForKey:key] count];
    return contactCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableCellIdentifier = @"D75E52F2-0FA1-496D-BD21-4FE284A3D844";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
    }
    NSString *key = [self.sortedKeysArray objectAtIndex:[indexPath section]];
    NSArray *departmentsArray = [self.departmentsDic objectForKey:key];
    Department *department = [departmentsArray objectAtIndex:[indexPath row]];
    [cell.textLabel setText:department.name];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.sortedKeysArray objectAtIndex:[indexPath section]];
    NSArray *departmentsArray = [self.departmentsDic objectForKey:key];
    Department *department = [departmentsArray objectAtIndex:[indexPath row]];
    [self.departmentsResult addObject:department];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.sortedKeysArray objectAtIndex:[indexPath section]];
    NSArray *departmentsArray = [self.departmentsDic objectForKey:key];
    Department *department = [departmentsArray objectAtIndex:[indexPath row]];
    [self.departmentsResult removeObject:department];
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


#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {
        Department *department = [[Department alloc] init];
        department.name = [attributeDict objectForKey:@"name"];
        department.identity = [attributeDict objectForKey:@"id"];
        department.pinYinName = [AppUtil pinyinFromChiniseString:department.name];
        
        NSString *firstChar = [department.pinYinName substringWithRange:NSMakeRange(0, 1)];
        firstChar = [firstChar uppercaseString];
        if (![[self.departmentsDic allKeys] containsObject:firstChar]) {
            if (![self.departmentsDic objectForKey:firstChar]) {
                [self.departmentsDic setObject:[[NSMutableArray alloc] init] forKey:firstChar];
            }
        }
        [[self.departmentsDic objectForKey:firstChar] addObject:department];
    }
}


#pragma mark - Selector

- (void)rightNavigationBarItemAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(departmentsViewController:didSelectedDepartments:)]) {
        [self.delegate departmentsViewController:self didSelectedDepartments:self.departmentsResult];
    }
}

@end
