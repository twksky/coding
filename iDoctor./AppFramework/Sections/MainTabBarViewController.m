//
//  MainUIViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/8.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "DoctorInfoViewController.h"
#import "ContactManager.h"
#import "LocalCacheManager.h"

@interface MainTabBarViewController ()
<
IChatManagerDelegate
>

@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, strong) UIViewController *mainPageController;
@property (nonatomic, strong) UIViewController *naviteQuestionsController;
@property (nonatomic, strong) MessageViewController *messageController;
@property (nonatomic, strong) ContactViewController *contactController;
@property (nonatomic, strong) UIViewController *userInfoController;

@property (nonatomic, strong) NSDate *lastPlaySoundDate;


@end

@implementation MainTabBarViewController

static const CGFloat kDefaultPlaySoundInterval = 3.0f;

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        //TODO
    }
    
    return self;
}

- (void)dealloc {
    
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *tabView = self.tabBarController.view;
    
    [self.view addSubview:tabView];
    [self addChildViewController:self.tabBarController];
    
    //AutoLayout
    {
        [self.view addConstraint:[tabView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view]];
        [self.view addConstraint:[tabView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view]];
        [self.view addConstraint:[tabView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view]];
        [self.view addConstraint:[tabView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view]];
    }
    
    [self registerNotifications];
    
}

#pragma mark - private methods

-(void)registerNotifications
{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        //EMMessage *lastMessage = conversation.latestMessage;
        [self.messageController updateUnreadCount:conversation.unreadMessagesCount withUserID:conversation.chatter];
        unreadCount += conversation.unreadMessagesCount;
    }
    self.messageController.recentlyUnreadMessageCount = unreadCount;
}

#pragma mark - IChatManagerDelegate Methods

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    //[_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message{
    // 检测联系人是否存在，如果不存在，获取好友列表
    NSString *msgUserID = message.from;
    if (![[ContactManager sharedInstance] containContactWithUserID:[msgUserID integerValue]]) {
        [self.contactController reloadContacts];    // 这个总判断，效率不高啊
    }
    
    /*
     回呼：urgency_call_cmd
     住院随访：follow_up_hospital_ask_price_cmd
     诊后随访：follow_up_outpatient_ask_price_cmd
     快速提问：quickly_ask_cmd
     */
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self showNotificationWithMessage:message];
    }
#endif
}

/*!
 @method
 @brief 收到消息时的回调
 @param cmdMessage      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时, 会触发此回调
 针对有附件的消息, 此时附件还未被下载.
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:,
 下载完所有附件后, 回调didMessageAttachmentsStatusChanged:error:会被触发
 */

- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage
{
    [self.messageController updateUnreadCountWithCmdMessage:cmdMessage];
}

- (void)playSoundAndVibration
{
    //如果距离上次响铃和震动时间太短, 则跳过响铃
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        return;
    }
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    if ([[LocalCacheManager sharedInstance] isPlayVibration]) {
        // 收到消息时，震动
        [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
    } else {
        // 收到消息时，播放音频
        [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    }
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.soundName = UILocalNotificationDefaultSoundName;  // 添加声音
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"[图片]";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"[位置]";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"[音频]";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"[视频]";
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.isGroup) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"您有一条新消息";
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
}



#pragma mark - properties

- (UITabBarController *)tabBarController {
    
    if (!_tabBarController) {
        
        _tabBarController = [[UITabBarController alloc] init];
        NSArray *controllers = [[NSArray alloc] initWithObjects:
                                [[UINavigationController alloc] initWithRootViewController:self.mainPageController],
                                [[UINavigationController alloc] initWithRootViewController:self.naviteQuestionsController],
                                [[UINavigationController alloc] initWithRootViewController:self.messageController],
                                [[UINavigationController alloc] initWithRootViewController:self.contactController],
                                [[UINavigationController alloc] initWithRootViewController:self.userInfoController], nil];
        [_tabBarController setViewControllers:controllers];
        _tabBarController.tabBar.barTintColor = [SkinManager sharedInstance].defaultTabBarTintColor;
        _tabBarController.tabBar.tintColor = [SkinManager sharedInstance].defaultTabBarTitleTintColor;
        [_tabBarController setSelectedIndex:0];
    }
    
    return _tabBarController;
}

- (UIViewController *)mainPageController {
    
    if (!_mainPageController) {
        
        _mainPageController = [[MainPageViewController alloc] init];
    }
    
    return _mainPageController;
}

- (UIViewController *)naviteQuestionsController {
    
    if (!_naviteQuestionsController) {
        
        _naviteQuestionsController = [[NativeQuestionsViewController alloc] init];
    }
    
    return _naviteQuestionsController;
}

- (UIViewController *)messageController {
    
    if (!_messageController) {
        
        _messageController = [[MessageViewController alloc] init];
    }
    
    return _messageController;
}

- (UIViewController *)contactController {
    
    if (!_contactController) {
        
        _contactController = [[ContactViewController alloc] init];
    }
    
    return _contactController;
}

- (UIViewController *)userInfoController {
    
    if (!_userInfoController) {
        
        _userInfoController = [[DoctorInfoViewController alloc] init];;
    }
    
    return _userInfoController;
}

@end
