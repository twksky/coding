//
//  EMChatExtTextBubbleView.h
//  AppFramework
//
//  Created by ABC on 7/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "EMChatTextBubbleView.h"

@class EMChatTemplateBubbleView;


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
