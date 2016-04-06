//
//  GDTabBarController.m
//  GoodDoctor
//
//  Created by hexy on 15/7/9.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDTabBarController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ContactsViewController.h"
#import "MeViewController.h"
#import "ContactManager.h"

@interface IDTabBarController ()
<UINavigationControllerDelegate
,EMChatManagerDelegate
>
@property (nonatomic, strong) MessageViewController *messageVC;
@property (nonatomic, strong) ContactsViewController *contactsVC;
@property (nonatomic, strong) NSDate *lastPlaySoundDate;

@end

@implementation IDTabBarController

static const CGFloat kDefaultPlaySoundInterval = 3.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = UIColorFromRGB(0x36cacc);
    
    // 初始化所有子控制器
    [self setupViewControllers];
}

- (void)setupViewControllers {
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    MessageViewController *messageVC = [[MessageViewController alloc] init];
    self.messageVC.title = @"消息";
//    ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
    self.contactsVC.title = @"我的患者";
    MeViewController *meVC = [[MeViewController alloc] init];
    meVC.title = @"我";
    self.viewControllers = @[
                             [self packWithNavigationControllerBy:homeVC],
                             [self packWithNavigationControllerBy:self.messageVC],
                             [self packWithNavigationControllerBy:self.contactsVC],
                             [self packWithNavigationControllerBy:meVC]
                             ];
    
    NSArray *titles = @[@"首页", @"消息", @"通讯录", @"我"];
    NSArray *tabBarCommonIcons = @[@"首页", @"消息", @"通讯录", @"我"];
    NSArray *tabBarHighlightIcons = @[@"首页hover", @"消息hover", @"通讯录hover", @"我hover"];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        
        [item setImage:[UIImage imageNamed:tabBarCommonIcons[idx]]];
        [item setSelectedImage:[[UIImage imageNamed:tabBarHighlightIcons[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitle:titles[idx]];
    }];
}

#pragma mark - 
- (UINavigationController *)packWithNavigationControllerBy:(UIViewController *)viewController {
    
    viewController.hidesBottomBarWhenPushed = NO;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.delegate = self;
    navigationController.navigationBar.translucent = NO;
    //TODO 包装NavigationController
    return navigationController;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (navigationController.childViewControllers.count > 1) {
        
        viewController.navigationItem.hidesBackButton = YES;
    }
}

#pragma mark -
- (void)popViewControllerFrom:(UINavigationController *)navigationController {
    
    [navigationController popViewControllerAnimated:YES];
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
        [self.messageVC updateUnreadCount:conversation.unreadMessagesCount withUserID:conversation.chatter];
        unreadCount += conversation.unreadMessagesCount;
    }
    self.messageVC.recentlyUnreadMessageCount = unreadCount;
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
    if (![[ContactManager sharedInstance] containContactWithUserID:msgUserID]) {
        [self.contactsVC reloadContacts];    // 这个总判断，效率不高啊
    }

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
//暂时没有用
- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage
{
    [self.messageVC updateUnreadCountWithCmdMessage:cmdMessage];
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
    //TODO 周世阳要加的震动功能
//    if ([[LocalCacheManager sharedInstance] isPlayVibration]) {
//        // 收到消息时，震动
//        [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
//    } else {
//        // 收到消息时，播放音频
//        [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
//    }
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
//        if (message.isGroup) {
//            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//            for (EMGroup *group in groupArray) {
//                if ([group.groupId isEqualToString:message.conversationChatter]) {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
//                    break;
//                }
//            }
//        }
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


- (UIViewController *)messageVC {
    
    if (!_messageVC) {
        
        _messageVC = [[MessageViewController alloc] init];
    }
    
    return _messageVC;
}

- (UIViewController *)contactsVC {
    
    if (!_contactsVC) {
        
        _contactsVC = [[ContactsViewController alloc] init];
        
    }
    
    return _contactsVC;
}

-(void)dealloc{
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


@end
