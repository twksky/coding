/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChatViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SRRefreshView.h"
#import "DXChatBarMoreView.h"
#import "DXRecordView.h"
#import "DXFaceView.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "ChatSendHelper.h"
#import "MessageReadManager.h"
#import "MessageModelManager.h"
#import "LocationViewController.h"
//#import "ChatGroupDetailViewController.h"
#import "UIViewController+HUD.h"
#import "WCAlertView.h"
#import "NSDate+Category.h"
#import "DXMessageToolBar.h"

#import "SkinManager.h"
#import "AccountManager.h"
#import "UIView+Subview.h"
#import "EMIdiomView.h"     // 常用语
#import "IQKeyboardManager.h"
#import "EMChatExtTextBubbleView.h"
#import "ContactDetailInfoViewController.h"
#import "ContactManager.h"
#import "ContactInfoViewController.h"
#import "LocalCacheManager.h"
#import "UIImageView+WebCache.h"
#import "UIView+AutoLayout.h"
#import "AddTemplateViewController.h"
#import "MyTemplateViewController.h"
#import "WebShowViewController.h" 
#import "TemplateWithoutCategoriesViewController.h"

#define KPageCount 20

@interface ChatViewController ()
<
UITableViewDataSource, UITableViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
SRRefreshDelegate,
IChatManagerDelegate,
DXChatBarMoreViewDelegate,
DXMessageToolBarDelegate,
LocationViewDelegate,
IDeviceManagerDelegate,
UIGestureRecognizerDelegate,
EMChatExtTextBubbleViewDelegate,
UIActionSheetDelegate,
TemplateWithoutCategoriesViewControllerDelegate
>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    dispatch_queue_t _messageQueue;
    
    BOOL _isScrollToBottom;
}

@property (nonatomic) BOOL isChatGroup;
@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) UIView      *callArea;
@property (strong, nonatomic) UIButton      *callButton;
@property (strong, nonatomic) UILabel       *callTipLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) MessageReadManager *messageReadManager;//message阅读的管理者
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@property (strong, nonatomic) NSDate *chatTagDate;

@property (nonatomic, assign) CGFloat callAreaHeight;
@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic, strong) UIImage *chatterAvatar;
@property (nonatomic, strong) UIImage *myAvatar;

@property (nonatomic, strong) NSString  *chatterAvatarURLPath;
@property (nonatomic, strong) NSString  *accountAvatarURLPath;

- (void)callButtonClicked:(id)sender;

@end

@implementation ChatViewController

- (instancetype)initWithUserID:(NSInteger)userID
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        NSString *chatter = [NSString stringWithFormat:@"%ld", (long)userID];
        Patient *patient = [[ContactManager sharedInstance] getContactWithUserID:userID];
        if (userID == kDoctorAssistantID) {
            self.title = @"医生助手";
//            self.callAreaHeight = 0.0f;
        } else {
            self.title = [patient getDisplayName];
//            self.callAreaHeight = 64.0f;
        }
        self.title = [patient getDisplayName];
        self.chatterAvatarURLPath = patient.avatarURLString;
        self.accountAvatarURLPath = [AccountManager sharedInstance].account.avatarImageURLString;
        _isPlayingAudio = NO;
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter isGroup:_isChatGroup];
        
        //TODO
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (instancetype)initWithChatter:(NSString *)chatter withChatterAvatar:(UIImage *)chatterAvatar withMyAvatar:(UIImage *)myAvatar
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        NSString *assistantIDString = [NSString stringWithFormat:@"%ld", (long)kDoctorAssistantID];
//        self.callAreaHeight = 64.0f;
        self.callAreaHeight = 0.0f;
        if ([chatter isEqualToString:assistantIDString]) {
            self.title = @"医生助手";
//            self.callAreaHeight = 0.0f;
        }
        _isPlayingAudio = NO;
        
        self.chatterAvatar = chatterAvatar;
        self.myAvatar = myAvatar;
        self.accountAvatarURLPath = [AccountManager sharedInstance].account.avatarImageURLString;
        
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter isGroup:_isChatGroup];
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _isChatGroup = YES;
        _chatGroup = chatGroup;
        
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatGroup.groupId isGroup:_isChatGroup];
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)initViewController
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xeef1f1);
    self.tableView.backgroundColor = UIColorFromRGB(0xeef1f1);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    #warning 以下三行代码必须写，注册为SDK的ChatManager的delegate
    [[[EaseMob sharedInstance] deviceManager] addDelegate:self onQueue:nil];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    _isScrollToBottom = YES;
//    //通过会话管理者获取已收发消息
//    
//    NSArray *chats = [_conversation loadNumbersOfMessages:KPageCount before:[_conversation latestMessage].timestamp + 1];
//    [self.dataSource addObjectsFromArray:[self sortChatSource:chats]];
    
    [self setupBarButtonItem];
//    [self.view addSubview:self.callArea];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self.view addSubview:self.chatToolBar];
//    {
//        // Autolayout
//        [self.view addConstraint:[self.callArea autoSetDimension:ALDimensionHeight toSize:self.callAreaHeight]];
//        [self.view addConstraint:[self.callArea autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0f]];
//        [self.view addConstraint:[self.callArea autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.0f]];
//        [self.view addConstraint:[self.callArea autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0f]];
//    }
//    [self.callArea addSubview:self.callButton];
//    [self.callArea addSubview:self.callTipLabel];
//    if (self.callAreaHeight > 0.0f)
//    {
//        // Autolayout
//        [self.callArea addConstraints:[self.callButton autoSetDimensionsToSize:CGSizeMake(159.0f, 33.0f)]];
//        [self.callArea addConstraint:[self.callButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.callArea withOffset:5.0f]];
//        [self.callArea addConstraint:[self.callButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.callArea]];
//        
//        [self.callArea addConstraint:[self.callTipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.callArea withOffset:0.0f]];
//        [self.callArea addConstraint:[self.callTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.callButton withOffset:0.0f]];
//        [self.callArea addConstraint:[self.callTipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.callArea withOffset:0.0f]];
//        [self.callArea addConstraint:[self.callTipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.callArea withOffset:0.0f]];
//    }
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    tap.delegate = self;
    //[self.view addGestureRecognizer:tap];
    [self.tableView addGestureRecognizer:tap];
    
    //通过会话管理者获取已收发消息
    [self loadMoreMessages];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    if (_isChatGroup) {
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(showRoomContact:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    }
    else if ([_conversation.chatter integerValue] != kDoctorAssistantID){
        
        UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [callBtn setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:callBtn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isScrollToBottom) {
        [self scrollViewToBottom:YES];
    }
    else{
        _isScrollToBottom = YES;
    }
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self keyBoardHidden];
    
    // 设置当前conversation的所有message为已读
    [_conversation markMessagesAsRead:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _slimeView.delegate = nil;
    _slimeView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    [[EaseMob sharedInstance].chatManager stopPlayingAudio];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[[EaseMob sharedInstance] deviceManager] removeDelegate:self];
}

- (void)back
{
    //判断当前会话是否为空，若符合则删除该会话
    EMMessage *message = [_conversation latestMessage];
    if (message == nil) {
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:_conversation.chatter deleteMessages:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - helper
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        int timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UIView *)callArea
{
    if (nil == _callArea) {
        _callArea = [[UIView alloc] init];
        _callArea.layer.masksToBounds = YES;
    }
    return _callArea;
}

- (UIButton *)callButton
{
    if (nil == _callButton) {
        _callButton = [[UIButton alloc] init];
        //[_callButton setImage:[UIImage imageNamed:@"img_call"] forState:UIControlStateNormal];
        _callButton.backgroundColor = UIColorFromRGBA(0xDBEED4FF);
        _callButton.layer.borderColor = [UIColorFromRGBA(0x62B62BFF) CGColor];
        _callButton.layer.borderWidth = 1.0f;
        _callButton.layer.cornerRadius = 16.5f;
        _callButton.layer.masksToBounds = YES;
        _callButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_callButton setTitle:@"免费通话" forState:UIControlStateNormal];
        [_callButton setTitleColor:UIColorFromRGBA(0x62B62BFF) forState:UIControlStateNormal];
        [_callButton setImage:[UIImage imageNamed:@"icon_call"] forState:UIControlStateNormal];
        _callButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 5.0f);
        _callButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 0.0f);
        [_callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}

- (UILabel *)callTipLabel
{
    if (nil == _callTipLabel) {
        _callTipLabel = [[UILabel alloc] init];
        _callTipLabel.font = [UIFont systemFontOfSize:12.0f];
        _callTipLabel.textColor = [SkinManager sharedInstance].defaultGrayColor;
        _callTipLabel.textAlignment = NSTextAlignmentCenter;
        _callTipLabel.text = @"您的手机号不会显示在对方手机上";
    }
    return _callTipLabel;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.callAreaHeight, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height - self.callAreaHeight) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        _chatToolBar.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    }
    
    return _chatToolBar;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.navigationController.delegate = self;
    }
    
    return _imagePicker;
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            
            return timeCell;
        }
        else{
            MessageModel *model = (MessageModel *)obj;
            NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
            EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ([cell.bubbleView isKindOfClass:[EMChatExtTextBubbleView class]] && model.message.ext) {
                EMChatExtTextBubbleView *extTextBubbleView = (EMChatExtTextBubbleView *)cell.bubbleView;
                extTextBubbleView.delegate = self;
                [extTextBubbleView clearSubview];
                // obj:接受到的obj对象    objKey:obj对应的key
                NSObject *obj = [model.message.ext objectForKey:@"type"];
                NSNumber *typeNumber = (NSNumber *)obj;
                if (0 == [typeNumber integerValue]) {
                    // 普通文字信息
                } else if (1 == [typeNumber integerValue]) {
                    // 病例
                } else if (2 == [typeNumber integerValue]) {
                    // 送花
                } else if (3 == [typeNumber integerValue]) {
                    // 接受花
                } else if (4 == [typeNumber integerValue]) {
                    // 拒绝花
                }
            }
            cell.messageModel = model;
            
            BOOL isReceiver = !model.isSender;
            if (isReceiver) {
                if (nil != self.chatterAvatar) {
                    [cell.headImageView setImage:self.chatterAvatar];
                } else {
                    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.chatterAvatarURLPath] placeholderImage:[SkinManager sharedInstance].defaultContactAvatarIcon];
                }
            } else {
                /*
                NSString *accountAvatarURLString = [AccountManager sharedInstance].account.avatarImageURLString;
                [[AccountManager sharedInstance] asyncDownloadImageWithURLString:accountAvatarURLString withCompletionHandler:^(UIImage *image) {
                    [cell.headImageView setImage:image];
                } withErrorHandler:^(NSError *error) {
                    
                }];*/
                if (nil != self.myAvatar) {
                    [cell.headImageView setImage:self.myAvatar];
                } else {
                    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.accountAvatarURLPath] placeholderImage:[SkinManager sharedInstance].defaultContactAvatarIcon];
                }
            }
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self loadMoreMessages];
    [_slimeView endRefresh];
}

#pragma mark - GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[MessageModel class]]) {
            EMChatViewCell *cell = (EMChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
        }
    }
}

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventTemplateBubbleTapEventName]) {
        
        [self chatTemplateCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        [self chatLocationCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        EMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        messageModel.status = eMessageDeliveryState_Delivering;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
    } else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        [self chatVideoCellPressed:model];
    } else if ([eventName isEqualToString:kRouterEventChatHeadImageTapEventName]) {
        BOOL isReceiver = !model.isSender;
        if (isReceiver) {
            Patient *patient = [[ContactManager sharedInstance] getContactWithUserID:[self.conversation.chatter integerValue]];
            ContactInfoViewController *vc = [[ContactInfoViewController alloc] initWithPatient:patient];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)chatTemplateCellBubblePressed:(MessageModel *)model {
    
    NSString *url = [model.message.ext objectForKey:@"link"];
    
    if (url && ![url isEqual:[NSNull null]]) {
        
        WebShowViewController *detailVC = [[WebShowViewController alloc] initWithUrl:url];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MessageModel *)model
{
    id <IEMFileMessageBody> body = [model.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [self showHint:@"正在下载语音，稍后点击"];
        return;
    }
    else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [self showHint:@"正在下载语音，稍后点击"];
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        
        return;
    }
    
    // 播放音频
    if (model.type == eMessageBodyType_Voice) {
        __weak ChatViewController *weakSelf = self;
        BOOL isPrepare = [self.messageReadManager prepareMessageAudioModel:model updateViewCompletion:^(MessageModel *prevAudioModel, MessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak ChatViewController *weakSelf = self;
            [[[EaseMob sharedInstance] deviceManager] enableProximitySensor];
            [[EaseMob sharedInstance].chatManager asyncPlayAudio:model.chatVoice completion:^(EMError *error) {
                [weakSelf.messageReadManager stopMessageAudioModel];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    
                    weakSelf.isPlayingAudio = NO;
//                    [[[EaseMob sharedInstance] deviceManager] disableProximitySensor];
                });
            } onQueue:nil];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

// 位置的bubble被点击
-(void)chatLocationCellBubblePressed:(MessageModel *)model
{
    _isScrollToBottom = NO;
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)chatVideoCellPressed:(MessageModel *)model{
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [weakSelf showHudInView:weakSelf.view hint:@"正在获取视频..."];
    [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
            if (localPath && localPath.length > 0) {
                [weakSelf playVideoWithVideoPath:localPath];
            }
        }else{
            [weakSelf showHint:@"视频获取失败!"];
        }
    } onQueue:nil];
}

- (void)playVideoWithVideoPath:(NSString *)videoPath
{
    _isScrollToBottom = NO;
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model
{
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            [weakSelf showHudInView:weakSelf.view hint:@"正在获取大图..."];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        NSURL *url = [NSURL fileURLWithPath:localPath];
                        weakSelf.isScrollToBottom = NO;
                        [weakSelf.messageReadManager showBrowserWithImages:@[url]];
                        return ;
                    }
                }
                [weakSelf showHint:@"大图获取失败!"];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:@"缩略图获取失败!"];
                }
                
            } onQueue:nil];
        }
    }else if ([model.messageBody messageBodyType] == eMessageBodyType_Video) {
        //获取缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed) {
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:@"缩略图获取失败!"];
                }
            } onQueue:nil];
        }
    }
}

#pragma mark - IChatManagerDelegate

-(void)didSendMessage:(EMMessage *)message error:(EMError *)error;
{
    [self reloadTableViewDataWithMessage:message];
    
    //增加一个判断 如果是第一次聊天而且是我发出去的消息这时候需要更新MessageViewController
    //第一次聊天而且是我发出去的消息 dataSource的count会为2   一个消息  和  一个timeline
    if ([self.dataSource count] == 2) {
        
        //TODO 暂时只能这么处理了  每次和一个患者第一次聊天且是自己发出的消息同步一下最近联系人列表 这样联系人列表才会出现患者信息  这个机制也真是奇葩
        [[ContactManager sharedInstance] asyncReloadContactsWithCompletionHandler:^(BOOL bSuccess, NSInteger contactCount) {
            
            //Nothing
        } withErrorHandler:^(NSError *error) {
            
            //Nothing
        }];
    }
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversation.chatter])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MessageModel class]]) {
                    EMMessage *currMsg = [weakSelf.dataSource objectAtIndex:i];
                    if ([message.messageId isEqualToString:currMsg.messageId]) {
                        MessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                            
                        });
                        
                        break;
                    }
                }
            }
        }
    });
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}

-(void)didReceiveMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversation.chatter]) {
        [self addChatDataToMessage:message];
    }
}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if (_isChatGroup && [group.groupId isEqualToString:_chatGroup.groupId]) {
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didInterruptionRecordAudio
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markMessagesAsRead:YES];
    
    [self stopAudioPlaying];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (0 == buttonIndex) {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }
    else if (1 == buttonIndex) {
        
#if TARGET_IPHONE_SIMULATOR
        [self showHint:@"模拟器不支持拍照"];
#elif TARGET_OS_IPHONE
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
    }
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片", @"拍照", nil];
    [actionSheet showInView:self.view];
    
    
//    // 弹出照片选择
//    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
//    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)moreViewMyTemplateAction:(DXChatBarMoreView *)moreView {
    
    [self keyBoardHidden];
    
//    MyTemplateViewController *mtv = [[MyTemplateViewController alloc] init];
//    mtv.delegate = self;
//    [self.navigationController pushViewController:mtv animated:YES];
    
    //我的模板界面换为模板ViewController
    TemplateWithoutCategoriesViewController *tvc = [[TemplateWithoutCategoriesViewController alloc] init];
    tvc.delegate = self;
    [self.navigationController pushViewController:tvc animated:YES];
    
}

- (void)moreViewAddTemplateAction:(DXChatBarMoreView *)moreView {
    
    [self keyBoardHidden];
    
    AddTemplateViewController *atv = [[AddTemplateViewController alloc] init];
    [self.navigationController pushViewController:atv animated:YES];
    //TODO  新增模板 代理
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
//    [self keyBoardHidden];
//    
//#if TARGET_IPHONE_SIMULATOR
//    [self showHint:@"模拟器不支持拍照"];
//#elif TARGET_OS_IPHONE
//    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
//    [self presentViewController:self.imagePicker animated:YES completion:NULL];
//#endif
    
    
    
}

- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    LocationViewController *locationController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)moreViewVideoAction:(DXChatBarMoreView *)moreView{
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:@"模拟器不支持录像"];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
}

#pragma mark - LocationViewDelegate

-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    EMMessage *locationMessage = [ChatSendHelper sendLocationLatitude:latitude longitude:longitude address:address toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO];
    [self addChatDataToMessage:locationMessage];
}


#pragma mark - DXMessageToolBarDelegate

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView
{
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = self.callAreaHeight;
        rect.size.height = self.view.frame.size.height - toHeight - self.callAreaHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:YES];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
//    if (_isRecording) {
//        ++_recordingCount;
//        if (_recordingCount > 10)
//        {
//            _recordingCount = 0;
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，已经戳漏了，随时崩溃给你看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//        else if (_recordingCount > 5) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，手别抖了，快被戳漏了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//        return;
//    }
//    _isRecording = YES;
    
    DXRecordView *tmpView = (DXRecordView *)recordView;
    tmpView.center = self.view.center;
    [self.view addSubview:tmpView];
    [self.view bringSubviewToFront:recordView];
    
    NSError *error = nil;
    [[EaseMob sharedInstance].chatManager startRecordingAudioWithError:&error];
    if (error) {
        NSLog(@"开始录音失败");
    }
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EaseMob sharedInstance].chatManager asyncCancelRecordingAudioWithCompletion:nil onQueue:nil];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    [[EaseMob sharedInstance].chatManager
     asyncStopRecordingAudioWithCompletion:^(EMChatVoice *aChatVoice, NSError *error){
         if (!error) {
             [self sendAudioMessage:aChatVoice];
         }else{
             if (error.code == EMErrorAudioRecordNotStarted) {
                 [self showHint:error.domain yOffset:-40];
             } else {
                 [self showHint:error.domain];
             }
         }
         
     } onQueue:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:nil];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.MOV
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideo];
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self sendImageMessage:orgImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MenuItem actions

- (void)copyMenuAction:(id)sender
{
    // todo by du. 复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.content;
    }
    
    _longPressIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        NSMutableArray *messages = [NSMutableArray arrayWithObjects:model, nil];
        [_conversation removeMessage:model.messageId];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [messages addObject:prevMessage];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        [self.dataSource removeObjectsInArray:messages];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - private

- (void)stopAudioPlaying
{
    //停止音频播放及播放动画
    [[EaseMob sharedInstance].chatManager stopPlayingAudio];
    MessageModel *playingModel = [self.messageReadManager stopMessageAudioModel];
    
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}

- (void)loadMoreMessages
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSInteger currentCount = [weakSelf.dataSource count];
        EMMessage *latestMessage = [weakSelf.conversation latestMessage];
        NSTimeInterval beforeTime = 0;
        if (latestMessage) {
            beforeTime = latestMessage.timestamp + 1;
        }else{
            beforeTime = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
        }
        
        NSArray *chats = [weakSelf.conversation loadNumbersOfMessages:(currentCount + KPageCount) before:beforeTime];
        
        if ([chats count] > currentCount) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:[weakSelf sortChatSource:chats]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
    });
}

- (NSArray *)sortChatSource:(NSArray *)array
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (array && [array count] > 0) {
        
        for (EMMessage *message in array) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [resultArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            [resultArray addObject:[MessageModelManager modelWithMessage:message]];
        }
    }
    
    return resultArray;
}

-(NSMutableArray *)addChatToMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    [ret addObject:[MessageModelManager modelWithMessage:message]];
    
    return ret;
}

-(void)addChatDataToMessage:(EMMessage *)message
{
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf addChatToMessage:message];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < messages.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count+i inSection:0];
//            [indexPaths insertObject:indexPath atIndex:0];
            [indexPaths addObject:indexPath];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView beginUpdates];
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
            
            //            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

- (void)addTipToMessage:(NSString *)tipMessage
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    [self.dataSource addObject:tipMessage];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataSource.count - 1) inSection:0];
    [indexPaths addObject:indexPath];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self performSelector:@selector(scrollViewToBottom:) withObject:nil afterDelay:0.1];
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)showRoomContact:(id)sender
{
    /*[self.view endEditing:YES];
    if (_isChatGroup && _chatGroup) {
        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroup:_chatGroup];
        detailController.title = _chatGroup.groupSubject;
        [self.navigationController pushViewController:detailController animated:YES];
    }*/
}

- (void)removeAllMessages:(id)sender
{
    if (_dataSource.count == 0) {
        [self showHint:@"消息已经清空"];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        if (_isChatGroup && [groupId isEqualToString:_conversation.chatter]) {
            [_conversation removeAllMessages];
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            [self showHint:@"消息已经清空"];
        }
    }
    else{
        __weak typeof(self) weakSelf = self;
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"请确认删除"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [weakSelf.conversation removeAllMessages];
                 [weakSelf.dataSource removeAllObjects];
                 [weakSelf.tableView reloadData];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applicationDidEnterBackground
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markMessagesAsRead:YES];
}

#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage
{
//    for (int i = 0; i < 100; i++) {
//        NSString *str = [NSString stringWithFormat:@"%@--%i", _conversation.chatter, i];
//        EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:str toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO];
//        [self addChatDataToMessage:tempMessage];
//    }
    //EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO];
    // 换上iDoctor的消息格式
    EMMessage *tempMessage = [ChatSendHelper sendCustomTextMessageWithString:textMessage toUsername:_conversation.chatter];
    [self addChatDataToMessage:tempMessage];
}

-(void)sendImageMessage:(UIImage *)imageMessage
{
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:imageMessage toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO];
    [self addChatDataToMessage:tempMessage];
}

-(void)sendAudioMessage:(EMChatVoice *)voice
{
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO];
    [self addChatDataToMessage:tempMessage];
}

-(void)sendVideoMessage:(EMChatVideo *)video
{
    EMMessage *tempMessage = [ChatSendHelper sendVideo:video toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO];
    [self addChatDataToMessage:tempMessage];
}

#pragma mark - EMDeviceManagerProximitySensorDelegate

- (void)proximitySensorChanged:(BOOL)isCloseToUser{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if (isCloseToUser && ![LocalCacheManager sharedInstance].isPlayFromSpeaker)//黑屏
    {
        // 使用耳机播放
        [[EaseMob sharedInstance].deviceManager switchAudioOutputDevice:eAudioOutputDevice_earphone];
    } else {
        // 使用扬声器播放
        [[EaseMob sharedInstance].deviceManager switchAudioOutputDevice:eAudioOutputDevice_speaker];
        if (!_isPlayingAudio) {
            [[[EaseMob sharedInstance] deviceManager] disableProximitySensor];
        }
    }
}


#pragma mark - UIGestureRecognizerDelegate
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    DLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
*/

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        navigationController.navigationBar.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        if (IOS_VERSION >= 7.0f) {
            navigationController.navigationBar.barTintColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        }
    }
}


#pragma mark - EMChatExtTextBubbleViewDelegate

- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didAcceptFlowerWithMessageModel:(MessageModel *)model
{
    // 接受鲜花
    __weak ChatViewController * wself = self;
    NSInteger flowerDealID = [[model.message.ext objectForKey:@"flower_id"] integerValue];
    [[AccountManager sharedInstance] asyncAcceptGift:YES withDealID:flowerDealID withCompletionHandler:^(BOOL isSuccess) {
        //[bubbleView clearSubview];
        ChatViewController * sself = wself;
        //[sself addTipToMessage:@"您已接收鲜花"];
        [sself sendTextMessage:@"医生已接收鲜花并表示感谢"];
    } withErrorHandler:^(NSError *error) {
        ChatViewController * sself = wself;
        [sself addTipToMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didRefuseFlowerWithMessageModel:(MessageModel *)model
{
    // 拒绝鲜花
    __weak ChatViewController * wself = self;
    NSInteger flowerDealID = [[model.message.ext objectForKey:@"flower_id"] integerValue];
    [[AccountManager sharedInstance] asyncAcceptGift:NO withDealID:flowerDealID withCompletionHandler:^(BOOL isSuccess) {
        //[bubbleView clearSubview];
        ChatViewController * sself = wself;
        //[sself addTipToMessage:@"您已拒绝鲜花"];
        [sself sendTextMessage:@"抱歉，医生拒绝了您的鲜花。"];
    } withErrorHandler:^(NSError *error) {
        ChatViewController * sself = wself;
        [sself addTipToMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]];
    }];
}

- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didClickDetailButtonWithMessageModel:(MessageModel *)model
{
    NSInteger medicalRecordID = [[model.message.ext objectForKey:@"record_id"] integerValue];
    ContactDetailInfoViewController *vc = [[ContactDetailInfoViewController alloc] initWithMedicalRecordID:medicalRecordID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)callButtonClicked:(id)sender
{
    [[AccountManager sharedInstance] asyncCallPatientWithUserID:[self.conversation.chatter integerValue] withCompletionHandler:^(BOOL isSuccess) {
        UIAlertView *alserView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"呼叫患者成功，请等待4008105790的双向来电" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alserView show];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alserView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"呼叫患者失败，请重试" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alserView show];
    }];
}

//#pragma mark - MyTemplateViewControllerDelegate Methods
//
//- (void)selectedTemplate:(TemplateModel *)templateModel {
//    
//    EMMessage *tempMessage = [ChatSendHelper sendCustomTextMessageWithString:@"(模板已发送)" toUsername:_conversation.chatter];
//    NSMutableDictionary *extDictionary = [[NSMutableDictionary alloc] init];
//    [extDictionary setValue:@"inquiry_template_cmd" forKey:@"action"];
//    [extDictionary setValue:@(templateModel.templateId) forKey:@"template_id"];
//    [extDictionary setValue:@(999) forKey:@"type"];
//    tempMessage.ext = extDictionary;
//    [self addChatDataToMessage:tempMessage];
//}

#pragma mark - TemplateWithoutCategoriesViewControllerDelegate Methods

- (void)didSelectedTemplateModelFromTemplateSetting:(TemplateModel *)templateModel {
    
    NSString *msg = [NSString stringWithFormat:@"[%@](模板已发送)", templateModel.name];
    EMMessage *tempMessage = [ChatSendHelper sendCustomTextMessageWithString:msg toUsername:_conversation.chatter];
    NSMutableDictionary *extDictionary = [[NSMutableDictionary alloc] init];
    [extDictionary setValue:@"inquiry_template_cmd" forKey:@"action"];
    [extDictionary setValue:@(templateModel.templateId) forKey:@"template_id"];
    [extDictionary setValue:@(999) forKey:@"type"];
    tempMessage.ext = extDictionary;
    [self addChatDataToMessage:tempMessage];
}

@end

















