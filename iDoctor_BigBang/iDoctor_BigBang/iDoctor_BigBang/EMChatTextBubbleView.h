//
//  EMChatTextBubbleView.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMChatBaseBubbleView.h"


#define TEXTLABEL_MAX_WIDTH 200 //　textLaebl 最大宽度
#define LABEL_FONT_SIZE 14

extern NSString *const kRouterEventTextBubbleTapEventName;

@interface EMChatTextBubbleView : EMChatBaseBubbleView

@property (nonatomic, strong) UILabel *textLabel;

+ (UIFont *)textLabelFont;
+ (NSLineBreakMode)textLabelLineBreakModel;

@end
