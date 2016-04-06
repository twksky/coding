//
//  DFDQuickQuestionListViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDQuickQuestionListViewController.h"
#import "SkinManager.h"
#import "AccountManager.h"
#import "DFDSubtitleTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "UIResponder+Router.h"
#import "UIImageView+WebCache.h"
#import "DFDQuickQuestionDetailViewController.h"
#import "ContactInfoViewController.h"

@interface DFDQuickQuestionListViewController ()
<
UITableViewDataSource, UITableViewDelegate,
DFDQuickQuestionDetailViewControllerDelegate
>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *quickQuestionList;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation DFDQuickQuestionListViewController

#define CellTextFont [UIFont systemFontOfSize:14.0f]

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"本地区患者快速提问查看";
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
//    [[AccountManager sharedInstance] asyncGetQuickQuestionListWithCompletionHandler:^(NSArray *quickQuestionList) {
//        self.quickQuestionList = quickQuestionList;
//        
//        [self.tableView reloadData];
//    } withErrorHandler:^(NSError *error) {
//        
//    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
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

- (NSArray *)quickQuestionList
{
    if (nil == _quickQuestionList) {
        _quickQuestionList = [NSArray array];
    }
    return _quickQuestionList;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quickQuestionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseIdentifier = @"969594A8-3DF7-4BBE-A7EF-01831654A226";
    DFDSubtitleTableViewCell *cell = (DFDSubtitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (nil == cell) {
        cell = [[DFDSubtitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    QuickQuestion *question = [self.quickQuestionList objectAtIndex:indexPath.row];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:question.patient.avatarURLString] placeholderImage:[UIImage imageNamed:@"icon_chat_default_avatar"]];
    
    NSDictionary *nameAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:CellTextFont, NSFontAttributeName, nil];
    NSMutableString *infoText = [[NSMutableString alloc] initWithString:[question.patient getDisplayName]];
    NSMutableAttributedString *infoAttributedString = [[NSMutableAttributedString alloc] initWithString:infoText attributes:nameAttributeDic];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDictionary *timeAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:CellTextFont, NSFontAttributeName,
                                      [SkinManager sharedInstance].defaultGrayColor, NSForegroundColorAttributeName, nil];
    NSString *timeString = [NSString stringWithFormat:@"\n%@", [dateFormatter stringFromDate:question.createTime]];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:timeAttributeDic];
    [infoAttributedString appendAttributedString:timeAttributedString];
    [cell.titleLabel setAttributedText:infoAttributedString];
    
    NSDictionary *imageCountAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:CellTextFont, NSFontAttributeName, [SkinManager sharedInstance].defaultNavigationBarBackgroundColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *subtitleAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"科室：%@", (nil == question.department) ? @"" : question.department] attributes:nameAttributeDic];
    NSString *descriptionText = [NSString stringWithFormat:@"\n描述：%@", question.conditionDescription];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:descriptionText attributes:nameAttributeDic]];
    NSString *imageCountText = [NSString stringWithFormat:@"\n有图片%ld张 共有%ld条回复", (long)question.imagesCount, (long)question.commentsCount];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:imageCountText attributes:imageCountAttributeDic]];
    [cell.subtitleLabel setAttributedText:subtitleAttributedString];
    /*
    NSDictionary *statusAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [SkinManager sharedInstance].defaultGrayColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *statusAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"现有%ld份报告", (long)report.reportItems.count] attributes:statusAttributeDic];
    [infoAttributedString appendAttributedString:statusAttributedString];
    
    
    
    NSString *statusText = report.isReceive ? @"所有报告已阅" : @"有未阅读的报告";
    
    NSString *countText = [NSString stringWithFormat:@"\n报告：每隔%ld天一次，共%ld次（价值%ld元）", (long)report.reportFrequencyInDay, (long)report.reportCount, (long)report.totalPrice / 100];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:countText attributes:statusAttributeDic]];
    NSString *medicalRecordIDText = [NSString stringWithFormat:@"\n病历号：%@", report.medicalRecordNumber];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:medicalRecordIDText attributes:nameAttributeDic]];
    */
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuickQuestion *question = [self.quickQuestionList objectAtIndex:indexPath.row];
    NSString *descriptionText = [NSString stringWithFormat:@"\n描述：%@", question.conditionDescription];
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 70.0f, MAXFLOAT);
    CGSize textSize = [descriptionText sizeWithFont:CellTextFont constrainedToSize:constraintSize];
    return 90.0f + textSize.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuickQuestion *question = [self.quickQuestionList objectAtIndex:indexPath.row];
    DFDQuickQuestionDetailViewController *questionDetailViewController = [[DFDQuickQuestionDetailViewController alloc] init];
    questionDetailViewController.delegate = self;
    questionDetailViewController.quickQuestion = question;
    [self.navigationController pushViewController:questionDetailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Event

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName isEqualToString:kAvatarClickEvent]) {
        UITableViewCell *cell = [userInfo objectForKey:kTableViewCell];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        QuickQuestion *question = [self.quickQuestionList objectAtIndex:indexPath.row];
        Patient *patient = question.patient;
        if (patient.userID != kDoctorAssistantID) {
            ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithPatient:patient];
            [self.navigationController pushViewController:infoViewController animated:YES];
        }
    } else {
        [super routerEventWithName:eventName userInfo:userInfo];
    }
}


#pragma mark - DFDQuickQuestionDetailViewControllerDelegate

- (void)quickQuestionDetailViewController:(DFDQuickQuestionDetailViewController *)viewController didAddComment:(Comment *)comment forQuickQuestion:(QuickQuestion *)quickQuestion
{
    [self.navigationController popToViewController:self animated:YES];
    
    for (NSInteger index = 0; index < self.quickQuestionList.count; index++) {
        QuickQuestion *question = [self.quickQuestionList objectAtIndex:index];
        if (question.questionID == quickQuestion.questionID) {
            question.commentsCount++;
            [question.comments addObject:comment];
            
            [self.tableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            break;
        }
    }
}

@end
