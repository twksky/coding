//
//  NativeQuestionDetailQuestionCellTableViewCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/1.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNativeQuestionDetailAvatarClickEvent                           @"beee28fe-3337-4d72-a546-56b186248d8f"
#define kNativeQuestionDetailQuestionCell @"NativeQuestionDetailQuestionCell"
#define kQuickQuestionDetailImageClickedEvent @"ce111425-dde7-4ddc-852f-a8d8f6e43132"
#define kDetailImageCollectionViewIndexKey @"kDetailImageCollectionViewIndexKey"

@class QuickQuestion;

@interface NativeQuestionDetailQuestionCell : UITableViewCell

- (void)loadQuickQuestion:(QuickQuestion *)question;

+ (CGFloat)cellHeightWithQuickQuestion:(QuickQuestion *)question;

@end
