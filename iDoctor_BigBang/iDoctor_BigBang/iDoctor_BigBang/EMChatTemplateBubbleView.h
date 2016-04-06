//
//  EMChatTemplateBubbleView.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "EMChatTextBubbleView.h"

@class EMChatTemplateBubbleView;
//

extern NSString *const kRouterEventTemplateBubbleTapEventName;

@protocol EMChatTemplateBubbleViewDelegate <NSObject>

- (void)chatExtTextBubbleView:(EMChatTemplateBubbleView *)bubbleView didAcceptFlowerWithMessageModel:(MessageModel *)model;
- (void)chatExtTextBubbleView:(EMChatTemplateBubbleView *)bubbleView didRefuseFlowerWithMessageModel:(MessageModel *)model;
- (void)chatExtTextBubbleView:(EMChatTemplateBubbleView *)bubbleView didClickDetailButtonWithMessageModel:(MessageModel *)model;

@end

@interface EMChatTemplateBubbleView : EMChatTextBubbleView

@property (nonatomic, weak) id<EMChatTemplateBubbleViewDelegate> delegate;

- (void)clearSubview;

@end

