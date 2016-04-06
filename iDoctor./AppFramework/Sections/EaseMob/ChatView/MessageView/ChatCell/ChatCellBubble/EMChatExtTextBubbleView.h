//
//  EMChatExtTextBubbleView.h
//  AppFramework
//
//  Created by ABC on 7/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "EMChatTextBubbleView.h"

@class EMChatExtTextBubbleView;

@protocol EMChatExtTextBubbleViewDelegate <NSObject>

- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didAcceptFlowerWithMessageModel:(MessageModel *)model;
- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didRefuseFlowerWithMessageModel:(MessageModel *)model;
- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didClickDetailButtonWithMessageModel:(MessageModel *)model;

@end

@interface EMChatExtTextBubbleView : EMChatTextBubbleView

@property (nonatomic, weak) id<EMChatExtTextBubbleViewDelegate> delegate;

- (void)clearSubview;

@end
