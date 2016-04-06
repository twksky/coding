//
//  EMChatExtTextBubbleView.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "EMChatTextBubbleView.h"

@class EMChatExtTextBubbleView;

@protocol EMChatExtTextBubbleViewDelegate <NSObject>

//- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didAcceptFlowerWithMessageModel:(MessageModel *)model;
//- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didRefuseFlowerWithMessageModel:(MessageModel *)model;
- (void)chatExtTextBubbleView:(EMChatExtTextBubbleView *)bubbleView didClickDetailButtonWithMessageModel:(MessageModel *)model;

@end

@interface EMChatExtTextBubbleView : EMChatTextBubbleView

@property (nonatomic, weak) id<EMChatExtTextBubbleViewDelegate> delegate;

- (void)clearSubview;

@end
