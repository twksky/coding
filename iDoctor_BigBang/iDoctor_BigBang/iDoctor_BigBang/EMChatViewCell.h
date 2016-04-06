//
//  EMChatViewCell.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "EMChatViewBaseCell.h"

#import "EMChatTextBubbleView.h"
#import "EMChatImageBubbleView.h"
//#import "EMChatAudioBubbleView.h"//因为没有语音所以暂时没有加这个功能
//#import "EMChatVideoBubbleView.h"//因为没有视频所以暂时没有加这个功能
//#import "EMChatLocationBubbleView.h"//因为没有位置所以暂时没有加这个功能
#import "EMChatExtTextBubbleView.h"
#import "EMChatTemplateBubbleView.h"

#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

extern NSString *const kResendButtonTapEventName;
extern NSString *const kShouldResendCell;

@interface EMChatViewCell : EMChatViewBaseCell

//sender
@property (nonatomic, strong) UIActivityIndicatorView *activtiy;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *retryButton;

@end