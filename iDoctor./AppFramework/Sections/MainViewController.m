//
//  MainViewController.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "MainViewController.h"
#import "ContactViewController.h"
#import "MessageViewController.h"
#import "GiftViewController.h"
#import "UserInfoViewController.h"
#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "UIView+AutoLayout.h"
#import "AccountManager.h"
#import "BMXSwitch.h"
#import "LoginManager.h"
#import "ContactManager.h"
#import "LocalCacheManager.h"

@interface MainViewController () <UITabBarControllerDelegate, IChatManagerDelegate>

@property (nonatomic, strong) ContactViewController  *contactViewController;
@property (nonatomic, strong) MessageViewController  *messageViewController;
@property (nonatomic, strong) GiftViewController     *giftViewController;
@property (nonatomic, strong) UserInfoViewController *userInfoViewController;

@property (nonatomic, strong) UITabBarController        *mainTabBarController;
@property (nonatomic, strong) UIView                    *statusContainerView;
@property (nonatomic, strong) UILabel                   *offlineLabel;
@property (nonatomic, strong) BMXSwitch                 *bmxStatusSwitch;
@property (nonatomic, strong) UILabel                   *onlineLabel;

@property (nonatomic, strong) NSDate                    *lastPlaySoundDate;

- (void)setupSubviews;
- (void)setupConstraints;

// Selector
- (void)switchStatusAction:(id)sender;
- (void)loginstatusChanged:(NSNotification *)notification;

@end

@implementation MainViewController

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginstatusChanged:) name:kLoginStatusChangedNotification object:nil];
        
        [self.bmxStatusSwitch setOn:YES];
        [self performSelector:@selector(switchStatusAction:) withObject:self.bmxStatusSwitch];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangedNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupSubviews];
    
    self.navigationItem.titleView = self.statusContainerView;
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];

    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        [self.view setFrame:CGRectMake(0.0f, App_Frame_Y + self.navigationBarHeight, App_Frame_Width, App_Frame_Height - self.navigationBarHeight)];
    }
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}


#pragma mark - Property

- (ContactViewController *)contactViewController
{
    if (!_contactViewController) {
        _contactViewController = [[ContactViewController alloc] init];
        
        //[self unSelectedTapTabBarItems:_contactViewController.tabBarItem];
        //[self selectedTapTabBarItems:_contactViewController.tabBarItem];
    }
    return _contactViewController;
}

- (MessageViewController *)messageViewController
{
    if (!_messageViewController) {
        _messageViewController = [[MessageViewController alloc] init];
        
        //[self unSelectedTapTabBarItems:_messageViewController.tabBarItem];
        //[self selectedTapTabBarItems:_messageViewController.tabBarItem];
    }
    return _messageViewController;
}

- (GiftViewController *)giftViewController
{
    if (!_giftViewController) {
        _giftViewController = [[GiftViewController alloc] init];
    }
    return _giftViewController;
}

- (UserInfoViewController *)userInfoViewController
{
    if (!_userInfoViewController) {
        _userInfoViewController = [[UserInfoViewController alloc] init];
    }
    return _userInfoViewController;
}

- (UITabBarController *)mainTabBarController
{
    if (!_mainTabBarController) {
        _mainTabBarController = [[UITabBarController alloc] init];
        _mainTabBarController.delegate = self;
        NSArray *viewControllerArray = [NSArray arrayWithObjects:
                                        self.contactViewController, self.messageViewController,
                                        self.giftViewController, self.userInfoViewController, nil];
        [_mainTabBarController setViewControllers:viewControllerArray];
        [_mainTabBarController setCustomizableViewControllers:viewControllerArray];
        _mainTabBarController.tabBar.tintColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        [_mainTabBarController setSelectedIndex:1];
    }
    return _mainTabBarController;
}

- (UIView *)statusContainerView
{
    if (!_statusContainerView) {
        _statusContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 141.0f, 24.0f)];
        
        [_statusContainerView addSubview:self.offlineLabel];
        [_statusContainerView addSubview:self.bmxStatusSwitch];
        [_statusContainerView addSubview:self.onlineLabel];
        [self.offlineLabel setFrame:CGRectMake(0.0f, 0.0f, 42.0f, 24.0f)];
        [self.bmxStatusSwitch setFrame:CGRectMake(42.0f, 0.0f, 57.0f, 24.0f)];
        [self.onlineLabel setFrame:CGRectMake(99.0f, 0.0f, 42.0f, 24.0f)];
    }
    return _statusContainerView;
}

- (UILabel *)offlineLabel
{
    if (!_offlineLabel) {
        _offlineLabel = [[UILabel alloc] init];
        _offlineLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _offlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _offlineLabel.font = [UIFont systemFontOfSize:12.0f];
        _offlineLabel.textColor = [UIColor whiteColor];
        _offlineLabel.textAlignment = NSTextAlignmentCenter;
        [_offlineLabel setText:@"离线"];
    }
    return _offlineLabel;
}

- (BMXSwitch *)bmxStatusSwitch
{
    if (!_bmxStatusSwitch) {
        _bmxStatusSwitch = [[BMXSwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 57.0f, 24.0f)];
        _bmxStatusSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        _bmxStatusSwitch.canvasImage = [UIImage imageNamed:@"img_overlay"];
        _bmxStatusSwitch.maskImage = [UIImage imageNamed:@"img_track_mask"];
        [_bmxStatusSwitch setContentImage:[UIImage imageNamed:@"img_track"] forState:UIControlStateNormal];
        [_bmxStatusSwitch setContentImage:[UIImage imageNamed:@"img_track"] forState:UIControlStateHighlighted];
        [_bmxStatusSwitch setKnobImage:[UIImage imageNamed:@"img_thumb"] forState:UIControlStateNormal];
        [_bmxStatusSwitch setKnobImage:[UIImage imageNamed:@"img_thumb"] forState:UIControlStateHighlighted];
        [_bmxStatusSwitch addTarget:self action:@selector(switchStatusAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _bmxStatusSwitch;
}

- (UILabel *)onlineLabel
{
    if (!_onlineLabel) {
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _onlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _onlineLabel.font = [UIFont systemFontOfSize:12.0f];
        _onlineLabel.textColor = [UIColor whiteColor];
        _onlineLabel.textAlignment = NSTextAlignmentCenter;
        [_onlineLabel setText:@"在线"];
    }
    return _onlineLabel;
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //[self.navigationItem.titleView setHidden:!([viewController class] == [MessageViewController class])];
    if ([viewController isKindOfClass:[ContactViewController class]]) {
        self.navigationItem.titleView = self.statusContainerView;
    } else if ([viewController isKindOfClass:[MessageViewController class]]) {
        self.navigationItem.titleView = self.statusContainerView;
    } else if ([viewController isKindOfClass:[GiftViewController class]]) {
        self.navigationItem.titleView = self.statusContainerView;
    } else if ([viewController isKindOfClass:[UserInfoViewController class]]) {
        self.navigationItem.titleView = self.statusContainerView;
    }
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.mainTabBarController.view];
    [self addChildViewController:self.mainTabBarController];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    UIView *tabView = self.mainTabBarController.view;
    [self.view addConstraint:[tabView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[tabView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[tabView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[tabView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0.0f]];
}


#pragma mark - Selector

-(void)switchStatusAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    [[AccountManager sharedInstance] asyncUploadOnlineStatus:isButtonOn withCompletionHandler:^(BOOL isSuccess) {
        
    } withErrorHandler:^(NSError *error) {
        [switchButton setOn:![switchButton isOn]];
    }];
}


#pragma mark - Notification

- (void)loginstatusChanged:(NSNotification *)notification
{
    if ([LoginManager sharedInstance].loginStatus == LOGINSTATUS_ONLINE) {
        
    } else if ([LoginManager sharedInstance].loginStatus == LOGINSTATUS_NONE) {
        [[AccountManager sharedInstance] asyncUploadOnlineStatus:NO withCompletionHandler:^(BOOL isSuccess) {
            
        } withErrorHandler:^(NSError *error) {
            
        }];
    }
}


#pragma mark - IChatManagerDelegate 消息变化

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
        [self.contactViewController reloadContacts];    // 这个总判断，效率不高啊
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
    [self.messageViewController updateUnreadCountWithCmdMessage:cmdMessage];
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


#pragma mark - private

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
        [self.messageViewController updateUnreadCount:conversation.unreadMessagesCount withUserID:conversation.chatter];
        unreadCount += conversation.unreadMessagesCount;
    }
    self.messageViewController.recentlyUnreadMessageCount = unreadCount;
}

- (void)setupUntreatedApplyCount
{
    
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],
                                        NSFontAttributeName, [UIColor colorWithRed:0.393 green:0.553 blue:1.000 alpha:1.000], NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
}

@end
