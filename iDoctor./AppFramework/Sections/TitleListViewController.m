//
//  TitleListViewController.m
//  AppFramework
//
//  Created by ABC on 7/22/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "TitleListViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"

@interface TitleListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation TitleListViewController

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
    self.title = @"职称";
    
    [self.view addSubview:self.contentTableView];
    [self.view addConstraints:[self.contentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
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
    }
    return _contentTableView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"主任医师", @"副主任医师", @"主治医师", @"住院医师", @"医师", nil];
    }
    return _titleArray;
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableCellIdentifier = @"32941A0E-76DA-44B9-8644-07DFA08F47BA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
    }
    NSString *title = [self.titleArray objectAtIndex:[indexPath row]];
    [cell.textLabel setText:title];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.titleArray objectAtIndex:[indexPath row]];
    if ([self.delegate respondsToSelector:@selector(titleListViewController:didSelectedTitle:)]) {
        [self.delegate titleListViewController:self didSelectedTitle:title];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
