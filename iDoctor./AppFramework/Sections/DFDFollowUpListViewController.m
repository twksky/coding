//
//  DFDFollowUpListViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDFollowUpListViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "DFDSubtitleTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ManagerUtil.h"
#import "UIResponder+Router.h"
#import "ContactInfoViewController.h"
#import "TTTAttributedLabel.h"

@interface DFDFollowUpListViewController ()
<
UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *followUpReportList;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation DFDFollowUpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    [[AccountManager sharedInstance] asyncGetFollowUpReportListWithType:self.followUpReportType withCompletionHandler:^(NSArray *reportList) {
        self.followUpReportList = reportList;
        [self.tableView reloadData];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Method

- (void)setupSubviews
{
    [self.view addSubview:self.tableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
}


#pragma mark - Property

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray *)followUpReportList
{
    if (nil == _followUpReportList) {
        _followUpReportList = [[NSArray alloc] init];
    }
    return _followUpReportList;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.followUpReportList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseIdentifier = @"E616EEFA-2BB1-4D38-9AB0-9D1E2AF60366";
    DFDSubtitleTableViewCell *cell = (DFDSubtitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (nil == cell) {
        cell = [[DFDSubtitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    FollowUpReport *report = [self.followUpReportList objectAtIndex:indexPath.row];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:report.patient.avatarURLString] placeholderImage:[UIImage imageNamed:@"icon_chat_default_avatar"]];
    
    NSDictionary *nameAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, nil];
    NSMutableString *infoText = [[NSMutableString alloc] initWithString:report.patient.realName];
    [infoText appendFormat:@"\t%@\n", [ManagerUtil parseGender:report.patient.firstFamilyMember.gender]];
    NSMutableAttributedString *infoAttributedString = [[NSMutableAttributedString alloc] initWithString:infoText attributes:nameAttributeDic];
    NSDictionary *statusAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [SkinManager sharedInstance].defaultGrayColor, NSForegroundColorAttributeName, nil];
    NSDictionary *redTextAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *statusAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"现有%ld份报告", (long)report.reportItems.count] attributes:statusAttributeDic];
    [infoAttributedString appendAttributedString:statusAttributedString];
    [cell.titleLabel setAttributedText:infoAttributedString];
    
    if (report.reportItems.count > 0) {
        cell.timeLabel.font = [UIFont systemFontOfSize:10.0f];
        cell.timeLabel.textColor = [SkinManager sharedInstance].defaultGrayColor;
        
        NSDate *createDate = ((FollowUpItem *)[report.reportItems firstObject]).createTime;
        for (NSInteger index = 1; index < report.reportItems.count; index++) {
            NSDate *tmpDate = ((FollowUpItem *)[report.reportItems objectAtIndex:index]).createTime;
            // 将当前对象与参数传递的对象进行比较，如果相同，返回0(NSOrderedSame)；
            // 对象时间早于参数时间，返回-1(NSOrderedAscending)；
            // 对象时间晚于参数时间，返回1(NSOrderedDescending)
            if ([tmpDate compare:createDate] == NSOrderedDescending) {
                createDate = tmpDate;
            }
        }
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
        //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        [cell.timeLabel setText:[dateFormatter stringFromDate:createDate]];
    } else {
        [cell.timeLabel setText:@""];
    }
    
    NSDictionary *imageCountAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [SkinManager sharedInstance].defaultNavigationBarBackgroundColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *subtitleAttributedString = nil;
    NSString *statusText = nil;
    if (report.reportItems.count > 0) {
        statusText = report.isReceive ? @"所有报告已阅" : @"有未阅读的报告";
        subtitleAttributedString = [[NSMutableAttributedString alloc] initWithString:statusText attributes:(report.isReceive ? statusAttributeDic : redTextAttributeDic)];
    } else {
        statusText = @"还没有报告";
        subtitleAttributedString = [[NSMutableAttributedString alloc] initWithString:statusText attributes:statusAttributeDic];
    }
    NSString *countText = [NSString stringWithFormat:@"\n报告：每隔%ld天一次，共%ld次（价值%ld元）", (long)report.reportFrequencyInDay, (long)report.reportCount, (long)report.totalPrice / 100];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:countText attributes:statusAttributeDic]];
    NSString *medicalRecordIDText = [NSString stringWithFormat:@"\n病历号：%@", [report.medicalRecordNumber isEqual:[NSNull null]] ? @"无" : report.medicalRecordNumber];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:medicalRecordIDText attributes:nameAttributeDic]];
    NSString *imageCountText = [NSString stringWithFormat:@"\n病历/处方图片%ld张", (long)report.imagesCount];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:imageCountText attributes:imageCountAttributeDic]];
    [cell.subtitleLabel setAttributedText:subtitleAttributedString];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowUpReport *followUpReport = [self.followUpReportList objectAtIndex:indexPath.row];
    [self selectedFollowUpReport:followUpReport];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Override Method

- (void)selectedFollowUpReport:(FollowUpReport *)followUpReport
{
    
}


#pragma mark - Event

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName isEqualToString:kAvatarClickEvent]) {
        UITableViewCell *cell = [userInfo objectForKey:kTableViewCell];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        FollowUpReport *report = [self.followUpReportList objectAtIndex:indexPath.row];
        Patient *patient = report.patient;
        if (patient.userID != kDoctorAssistantID) {
            ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithPatient:patient];
            [self.navigationController pushViewController:infoViewController animated:YES];
        }
    } else {
        [super routerEventWithName:eventName userInfo:userInfo];
    }
}


#pragma mark - DDFDFollowUpDetailViewControllerDelegate

- (void)followUpDetailViewController:(DFDFollowUpDetailViewController *)viewController didChangedFollowUpReportStatus:(FollowUpReport *)report
{
    for (NSInteger index = 0; index < self.followUpReportList.count; index++) {
        FollowUpReport *followUpReport = [self.followUpReportList objectAtIndex:index];
        if (followUpReport.reportID == report.reportID) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            break;
        }
    }
}

@end
