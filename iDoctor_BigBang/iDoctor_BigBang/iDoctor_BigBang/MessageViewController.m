//
//  MessageViewController.m
//  
//
//  Created by twksky on 15/9/14.
//
//

#import "MessageViewController.h"
#import "IDGetDoctorPatient.h"
//#import "SkinManager.h"
//#import "UIViewController+Util.h"
//#import "UIView+AutoLayout.h"
#import "ChatViewController.h"
#import "ContactManager.h"//联系人的管理项
//#import "AccountManager.h"
#import "RecentlyContactTableViewCell.h"
//#import "ContactInfoViewController.h"//联系人详情界面
#import "NSDate+Category.h"
#import "ConvertToCommonEmoticonsHelper.h"//表情
//#import "TTTAttributedLabel.h"
//#import "DFDQuickQuestionListViewController.h"
//#import "DFDUrgentCallListViewController.h"
//#import "DFDOutpatientFollowUpListViewController.h"
//#import "DFDInHospitalFollowUpListViewController.h"
//#import "LocalCacheManager.h"
#import "IDPatientMessageViewController.h"//联系人详情界面


@interface MessageViewController ()
<
UITableViewDataSource
, UITableViewDelegate
//, IChatManagerDelegate
, RecentlyContactTableViewCellDelegate//cell代理
>

{
    BOOL _isResendSuccess;
}

@property (nonatomic, strong) UITableView   *contactTableView;

@property (nonatomic, strong) NSMutableArray *contactArray;

@property (nonatomic, strong) UIView *tipView;

- (void)setupSubviews;//布局
- (void)setupConstraints;//约束

// Notification
- (void)contactChangedNotification:(NSNotification *)notification;
- (void)recentlyContactChangedNotification:(NSNotification *)notification;

@end

@implementation MessageViewController

enum TableViewSection
{
    FixedMessageSection = 0,
    RecentlyMessageSection = 1
};


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"消息";
        //设置自定义的皮肤的背景的
//        [self.tabBarItem setImage:[SkinManager sharedInstance].defaultMessageTabBarNormalIcon];
//        [self.tabBarItem setSelectedImage:[SkinManager sharedInstance].defaultMessageTabBarHighlightedIcon];
        
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        
        // Add Observer
        //        [self addObserver:self forKeyPath:@"systemUnreadMessageCount" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"recentlyUnreadMessageCount" options:NSKeyValueObservingOptionNew context:NULL];
        
        // Add Notification Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactChangedNotification:) name:kContactChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recentlyContactChangedNotification:) name:kRecentlyContactChangedNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    //    [self removeObserver:self forKeyPath:@"systemUnreadMessageCount"];
    [self removeObserver:self forKeyPath:@"recentlyUnreadMessageCount"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setNavigationBarWithTitle:@"消息" leftBarButtonItem:nil rightBarButtonItem:nil];
    self.title = @"消息";
//    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    [self setupSubviews];
    
    //    NSInteger msgCount = [[LocalCacheManager sharedInstance] getSystemMessageUnreadCountWithMessageType:SM_UrgencyCall];
    //    msgCount += [[LocalCacheManager sharedInstance] getSystemMessageUnreadCountWithMessageType:SM_OutpatientFollowUp];
    //    msgCount += [[LocalCacheManager sharedInstance] getSystemMessageUnreadCountWithMessageType:SM_InHospitalFollowUp];
    //    msgCount += [[LocalCacheManager sharedInstance] getSystemMessageUnreadCountWithMessageType:SM_QuickQuestion];
    //    self.systemUnreadMessageCount = msgCount;
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

//重写系统的方法
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.contactTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contactTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.contactTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.contactTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (void)updateViewConstraints
//{
//    [super updateViewConstraints];
//}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    void (^updateUnreadMessageCountBlock)(NSInteger) = ^(NSInteger unreadMsgCount) {
        if (unreadMsgCount > 0) {
            //self.contactViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)unreadMsgCount];
        } else {
            //self.contactViewController.tabBarItem.badgeValue = nil;
            self.tabBarItem.badgeValue = nil;
        }
    };
    if ([keyPath isEqualToString:@"systemUnreadMessageCount"]) {
        updateUnreadMessageCountBlock(self.systemUnreadMessageCount + self.recentlyUnreadMessageCount);
    } else if ([keyPath isEqualToString:@"recentlyUnreadMessageCount"]) {
        //        updateUnreadMessageCountBlock(self.systemUnreadMessageCount + self.recentlyUnreadMessageCount);
        updateUnreadMessageCountBlock(self.recentlyUnreadMessageCount);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




#pragma mark - Property

- (UITableView *)contactTableView
{
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] init];
        _contactTableView.dataSource = self;
        _contactTableView.delegate = self;
//        _contactTableView.sectionIndexColor = [SkinManager sharedInstance].defaultGrayColor;
    }
    return _contactTableView;
}

- (NSMutableArray *)contactArray
{
    if (!_contactArray) {
        _contactArray = [[NSMutableArray alloc] init];
    }
    return _contactArray;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (FixedMessageSection == section) {
    //        return 4;
    //    } else if (RecentlyMessageSection == section) {
    //        return [[ContactManager sharedInstance] getRecentlyContactCount];
    //    }
    //    return 0;
    if ([[ContactManager sharedInstance] getRecentlyContactCount] == 0) {
        self.tipView.hidden = NO;
    }else{
        self.tipView.hidden = YES;
    }
    
    return [[ContactManager sharedInstance] getRecentlyContactCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sReusableCellWithIdentifier = @"514F3E9E-6C48-458E-AE91-C4F66E7EC265";
    RecentlyContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sReusableCellWithIdentifier];
    if (!cell) {
        cell = [[RecentlyContactTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sReusableCellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    /*
     // 不用环信的好友列表
     EMBuddy *buddy = [self.contactArray objectAtIndex:[indexPath row]];
     [cell.textLabel setText:buddy.username];
     */
    IDGetDoctorPatient *patient = [[ContactManager sharedInstance] getRecentlyContactWithIndex:[indexPath row]];
    [cell setContact:patient];
    
    NSString *chatter = patient.patient_id;
//    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:eConversationTypeChat];
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter isGroup:NO];
    if (conversation) {
        NSString *lastMessage = [self subTitleMessageByConversation:conversation];
        [cell.messageLabel setText:[NSString stringWithFormat:@"最后消息：%@", lastMessage]];
        if (_isResendSuccess == NO) {
            cell.reSendIMG.hidden = NO;
            [cell.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.avatarImageView.right).offset(12 + 19 +5);
            }];
        }else{
            cell.reSendIMG.hidden = YES;
            [cell.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.avatarImageView.right).offset(12);
            }];
        }
        EMMessage *lastMsg = [conversation latestMessage];
        NSDate *msgDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:lastMsg.timestamp];
        [cell.timeLabel setText:[msgDate formattedDateDescription]];
        
        [cell.countLabel setHidden:!(conversation.unreadMessagesCount > 0)];
        [cell.countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)conversation.unreadMessagesCount]];
    }
    return cell;
    //    }
    //    return nil;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        if (lastMessage.deliveryState == eMessageDeliveryState_Failure) {
            _isResendSuccess = NO;
        }else{
            _isResendSuccess = YES;
        }
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[声音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (FixedMessageSection == indexPath.section) {
    //        return [RecentlyContactTableViewCell DefaultCellHeight];
    //    } else if (RecentlyMessageSection == indexPath.section) {
    //        return [RecentlyContactTableViewCell DefaultCellHeight];
    //    }
    return [RecentlyContactTableViewCell DefaultCellHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (FixedMessageSection == indexPath.section) {
    //        NSString *messageType = @"";
    //        if (0 == indexPath.row) {
    //            DFDUrgentCallListViewController *urgentCallListViewController = [[DFDUrgentCallListViewController alloc] init];
    //            [self.navigationController pushViewController:urgentCallListViewController animated:YES];
    //            messageType = SM_UrgencyCall;
    //        } else if (1 == indexPath.row) {
    //            DFDOutpatientFollowUpListViewController *outpatientFollowUpListViewController = [[DFDOutpatientFollowUpListViewController alloc] init];
    //            [self.navigationController pushViewController:outpatientFollowUpListViewController animated:YES];
    //            messageType = SM_OutpatientFollowUp;
    //        } else if (2 == indexPath.row) {
    //            DFDInHospitalFollowUpListViewController *inHospitalFollowUpListViewController = [[DFDInHospitalFollowUpListViewController alloc] init];
    //            [self.navigationController pushViewController:inHospitalFollowUpListViewController animated:YES];
    //            messageType = SM_InHospitalFollowUp;
    //        } else if (3 == indexPath.row) {
    //            DFDQuickQuestionListViewController *quickQuestionListViewController = [[DFDQuickQuestionListViewController alloc] init];
    //            [self.navigationController pushViewController:quickQuestionListViewController animated:YES];
    //            messageType = SM_QuickQuestion;
    //        }
    //        NSInteger msgCount = [[LocalCacheManager sharedInstance] getSystemMessageUnreadCountWithMessageType:messageType];
    //        self.systemUnreadMessageCount -= msgCount;
    //        [[LocalCacheManager sharedInstance] saveSystemMessageUnreadCount:0 withMessageType:messageType];
    //
    //        UITableViewCell *cell = (UITableViewCell *)[self.contactTableView cellForRowAtIndexPath:indexPath];
    //        [cell.detailTextLabel setText:@"暂时没有新消息"];
    //        TTTAttributedLabel *countLabel = (TTTAttributedLabel *)[cell.imageView viewWithTag:10];
    //        if (nil != countLabel) {
    //            [countLabel setHidden:YES];
    //        }
    //    } else if (RecentlyMessageSection == indexPath.section) {
    IDGetDoctorPatient *patient = [[ContactManager sharedInstance] getRecentlyContactWithIndex:[indexPath row]];
    //RecentlyContactTableViewCell *cell = (RecentlyContactTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //ChatViewController *messageController = [[ChatViewController alloc] initWithChatter:patient.userID withChatterAvatar:cell.avatarImageView.image withMyAvatar:nil];
    //跳入聊天
    ChatViewController *messageController = [[ChatViewController alloc] initWithUserID:patient.patient_id];
    messageController.title = [patient getDisplayName];
    [self.navigationController pushViewController:messageController animated:YES];
    //    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (FixedMessageSection == indexPath.section) {
    //
    //    } else if (RecentlyMessageSection == indexPath.section) {
    //        return YES;
    //    }
    //    return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (FixedMessageSection == indexPath.section) {
    //
    //    } else if (RecentlyMessageSection == indexPath.section) {
    //        if (editingStyle == UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
    //            if (indexPath.row < [[ContactManager sharedInstance] getRecentlyContactCount]) {
    //                [[ContactManager sharedInstance] removeRecentlyContactWithIndex:indexPath.row];//移除数据源的数据
    //                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
    //            }
    //        }
    //    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row < [[ContactManager sharedInstance] getRecentlyContactCount]) {
            [[ContactManager sharedInstance] removeRecentlyContactWithIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (FixedMessageSection == indexPath.section) {
    //
    //    } else if (RecentlyMessageSection == indexPath.section) {
    return UITableViewCellEditingStyleDelete;
    //    }
    //    return UITableViewCellEditingStyleNone;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark - Pravite Method

- (void)setupSubviews
{
    [self.view addSubview:self.contactTableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.contactTableView.tableFooterView = view;
    
    [self setupConstraints];
}

- (void)setupConstraints
{

    [self.contactTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
    }];
}


#pragma mark - Notification

- (void)contactChangedNotification:(NSNotification *)notification
{
    [[ContactManager sharedInstance] asyncReloadRecentlyContactsWithCompletionHandler:^(BOOL bSuccess, NSInteger contactCount) {
        // 在通知处响应
    } withErrorHandler:^(NSError *error) {
        
    }];
}

- (void)recentlyContactChangedNotification:(NSNotification *)notification
{
    [self.contactTableView reloadData];
}


#pragma mark - Selector

#pragma mark - Public Method
//刷新未读数
- (void)updateUnreadCount:(NSInteger)count withUserID:(NSString *)userID
{
    void (^updateUnreadCountBlock)(NSString *userIDInBlock) = ^(NSString *userIDInBlock) {
        NSInteger index = [[ContactManager sharedInstance] getContactIndexWithUserID:userID];
        if (NSNotFound == index) {
            return ;
        }
        //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:RecentlyMessageSection];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];//现在Section只有一个了
        RecentlyContactTableViewCell *cell = (RecentlyContactTableViewCell *)[self.contactTableView cellForRowAtIndexPath:indexPath];
        [cell.countLabel setHidden:!(count > 0)];
        if (count > 0) {
            [cell.countLabel setText:[NSString stringWithFormat:@"%ld", (long)count]];
        }
    };
    
    if ([[ContactManager sharedInstance] containRecentlyContactWithUserID:userID]) {
        updateUnreadCountBlock(userID);
    } else {
        [[ContactManager sharedInstance] asyncReloadRecentlyContactsWithCompletionHandler:^(BOOL bSuccess, NSInteger contactCount) {
            [self.contactTableView reloadData];
            updateUnreadCountBlock(userID);
        } withErrorHandler:^(NSError *error) {
            
        }];
    }
}

//- (void)updateUnreadCountWithCmdMessage:(EMMessage *)cmdMessage
//{
//    NSArray *msgBodies = cmdMessage.messageBodies;
//    self.systemUnreadMessageCount += msgBodies.count;
//    for (id body in msgBodies) {
//        if ([body isKindOfClass:[EMCommandMessageBody class]]) {
//            EMCommandMessageBody *cmdMsgBody = (EMCommandMessageBody *)body;
//            NSString *messageType = @"";
//            NSInteger index = -1;
//            if ([cmdMsgBody.action isEqualToString:@"urgency_call_cmd"]) {      // 回呼
//                messageType = SM_UrgencyCall;
//                index= 0;
//            } else if ([cmdMsgBody.action isEqualToString:@"follow_up_outpatient_cmd"]) {   // 诊后随访
//                messageType = SM_OutpatientFollowUp;
//                index = 1;
//            } else if ([cmdMsgBody.action isEqualToString:@"follow_up_in_hospital_cmd"]) {  // 住院随访
//                messageType = SM_InHospitalFollowUp;
//                index = 2;
//            } else if ([cmdMsgBody.action isEqualToString:@"quickly_ask_cmd"]) {            // 快速提问
//                messageType = SM_QuickQuestion;
//                index = 3;
//            }
//            if (![messageType isEqualToString:@""]) {
//                NSInteger msgCount = [[LocalCacheManager sharedInstance] getSystemMessageUnreadCountWithMessageType:messageType];
//                [[LocalCacheManager sharedInstance] saveSystemMessageUnreadCount:(msgCount + 1) withMessageType:messageType];
//                
//                //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:FixedMessageSection];
//                //                [self.contactTableView beginUpdates];
//                //                [self.contactTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                //                [self.contactTableView endUpdates];
//                //                UITableViewCell *cell = (UITableViewCell *)[self.contactTableView cellForRowAtIndexPath:indexPath];
//                //                TTTAttributedLabel *countLabel = (TTTAttributedLabel *)[cell.imageView viewWithTag:10];
//                //                if (nil == countLabel) {
//                //                    countLabel = [[TTTAttributedLabel alloc] init];
//                //                    countLabel.font = [UIFont systemFontOfSize:14.0f];
//                //                    countLabel.backgroundColor = [UIColor redColor];
//                //                    countLabel.textColor = [UIColor whiteColor];
//                //                    countLabel.layer.cornerRadius = 8.0f;
//                //                    countLabel.layer.masksToBounds = YES;
//                //                    countLabel.textInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
//                //                    countLabel.tag = 10;
//                //                    [cell.imageView addSubview:countLabel];
//                //                    {
//                //                        [cell.imageView addConstraint:[countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.imageView withOffset:-5.0f]];
//                //                        [cell.imageView addConstraint:[countLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.imageView withOffset:5.0f]];
//                //                    }
//                //                }
//                //                [countLabel setHidden:NO];
//                //                [countLabel setText:[NSString stringWithFormat:@"%ld", (long)(msgCount + 1)]];
//            }
//        }
//    }
//}

-(UIView *)tipView{
    if (!_tipView) {
        _tipView = [self tipViewWithName:@"没有最近消息记录!"];
        [self.view addSubview:_tipView];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).offset(0);
            make.top.equalTo(self.view).offset(-50);
            make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height));
            
        }];
    }
    return _tipView;
}

#pragma mark - RecentlyContactTableViewCellDelegate

- (void)recentlyContactTableViewCellDidClickedAvatarImage:(RecentlyContactTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.contactTableView indexPathForCell:cell];
    //Patient *patient = [[ContactManager sharedInstance] getContactWithSection:[indexPath section] withRow:[indexPath row]];
    IDGetDoctorPatient *patient = [[ContactManager sharedInstance] getRecentlyContactWithIndex:[indexPath row]];
    //TODO
    //跳到联系人详情界面
    IDPatientMessageViewController *infoViewController = [[IDPatientMessageViewController alloc] init];
    if (![patient.patient_id isEqualToString:kDoctorAssistantID]) {
        infoViewController.patient_id = [patient.patient_id intValue];
        [self.navigationController pushViewController:infoViewController animated:YES];
    }
    
}

@end
