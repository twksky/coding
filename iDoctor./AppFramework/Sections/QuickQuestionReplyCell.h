//
//  QuickQuestionReplyCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/4/23.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkinManager.h"

@interface QuickQuestionReplyCell : UITableViewCell

@property (nonatomic, strong) UIButton *replyButton;

- (void)addReplyButtonAction:(SEL)action withTarget:(id)target;

@end
