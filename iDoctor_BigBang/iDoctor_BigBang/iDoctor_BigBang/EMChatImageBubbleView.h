//
//  EMChatImageBubbleView.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMChatBaseBubbleView.h"

#define MAX_SIZE 120 //　图片最大显示大小

extern NSString *const kRouterEventImageBubbleTapEventName;

@interface EMChatImageBubbleView : EMChatBaseBubbleView

@property (nonatomic, strong) UIImageView *imageView;

@end
