//
//  NativeQuestionsOfficeTypesTableViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/3.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "NativeQuestionsOfficeTypesTableViewController.h"
#import <PureLayout.h>

@interface NativeQuestionsOfficeTypesTableViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *officeTypes;

@end

@implementation NativeQuestionsOfficeTypesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x38b19a);
    self.tableView.backgroundColor = UIColorFromRGB(0x38b19a);
    
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
}


#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 36.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedOfficeType:)]) {
        
        [self.delegate didSelectedOfficeType:[self.officeTypes objectAtIndex:indexPath.row]];
    }
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.officeTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"10882132-88dc-422f-babb-3b7a806b52db";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [self.officeTypes objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = UIColorFromRGB(0x38b19a);
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSArray *)officeTypes {
    
    if (!_officeTypes) {
        
        _officeTypes = @[@"全部", @"内科", @"外科", @"妇科", @"儿科", @"其他科室"];
    }
    
    return _officeTypes;
}

@end
