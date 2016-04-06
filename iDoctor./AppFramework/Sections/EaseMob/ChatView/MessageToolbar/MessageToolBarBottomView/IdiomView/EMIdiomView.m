//
//  EMIdiomView.m
//  AppFramework
//
//  Created by ABC on 7/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "EMIdiomView.h"
#import "UIView+Autolayout.h"

@interface EMIdiomView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView       *selectTextTableView;
@property (nonatomic, strong) NSMutableArray    *idiomArray;

@end

@implementation EMIdiomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.selectTextTableView];
        [self addConstraints:[self.selectTextTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Property

- (UITableView *)selectTextTableView
{
    if (!_selectTextTableView) {
        _selectTextTableView = [[UITableView alloc] init];
        _selectTextTableView.dataSource = self;
        _selectTextTableView.delegate = self;
    }
    return _selectTextTableView;
}

- (NSMutableArray *)idiomArray
{
    if (!_idiomArray) {
        _idiomArray = [[NSMutableArray alloc] initWithObjects:
                       @"您好，稍等一下，我看一下您的资料。",
                       @"很抱歉，我现在有点忙，稍后回复您。",
                       @"请点击“上传病历”，上传您的病历页，处方单，化验单等。",
                       @"您需要来一下我的门诊，我的门诊时间是：",
                       @"对不起，我暂时不能为您提供咨询服务。",
                       @"您的症状持续了多长时间？有什么诱因吗？",
                       @"您还有其他的症状吗？",
                       @"您之前有没有其他的疾病？",
                       @"您现在服用什么药物？",
                       @"请根据如下提示时间回馈您的治疗情况，以便我更好地跟进治疗。", nil];
    }
    return _idiomArray;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.idiomArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReusableCellIdentifier = @"D837CE6C-AEB9-4BF0-AEFC-F4C481EE1868";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    [cell.textLabel setText:[self.idiomArray objectAtIndex:[indexPath row]]];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(idiomView:didSelectIdiom:)]) {
        [self.delegate idiomView:self didSelectIdiom:[self.idiomArray objectAtIndex:[indexPath row]]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
