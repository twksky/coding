//
//  AddTemplateDiyQuestionCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddTemplateDiyQuestionCell;

@protocol AddTemplateDiyQuestionCellDelegate <NSObject>

- (void)removeItemWith:(AddTemplateDiyQuestionCell *)cell;

@end

@interface AddTemplateDiyQuestionCell : UITableViewCell

@property (nonatomic, weak) id<AddTemplateDiyQuestionCellDelegate> delegate;

- (void)loadDataWithDiyQuestion:(NSString *)diyQuestion;

@end
