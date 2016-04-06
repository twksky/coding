//
//  NativeQuestionCellTableViewCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/15.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuickQuestion;
@class Patient;

@protocol NativeQuestionCellTableViewCellDelegate <NSObject>

- (void)iconUserImageClickedWithPatient:(Patient *)patient;

@end

@interface NativeQuestionCellTableViewCell : UITableViewCell

@property (nonatomic, weak) id<NativeQuestionCellTableViewCellDelegate> delegate;

- (void)loadData:(QuickQuestion *)question;

@end
