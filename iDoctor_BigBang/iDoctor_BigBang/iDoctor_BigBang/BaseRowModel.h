//
//  BaseRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RowSelectedBlock)(NSIndexPath *indexPath);

@interface BaseRowModel : NSObject
/**
 *  图标
 */
@property (nonatomic, strong) UIImage *icon;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;
/**
 *  文字的对齐方式
 */
@property(nonatomic, assign) NSTextAlignment textAlignment;
/**
 *  行ID
 */
@property(nonatomic, assign) NSUInteger rowId;

@property(nonatomic, copy) RowSelectedBlock rowSelectedBlock;

- (void)setRowSelectedBlock:(RowSelectedBlock)rowSelectedBlock;

/**
 *  创建模型
 *
 *  @param title 标题
 *
 *  @return
 */
+ (instancetype)baseRowModelWithTitle:(NSString *)title;
/**
 *  创建模型
 *
 *  @param icon  图标
 *  @param title 标题
 *
 *  @return
 */
+ (instancetype)baseRowModelWithIcon:(UIImage *)icon title:(NSString *)title;
/**
 *  创建模型
 *
 *  @param title    正标题
 *  @param subtitle 副标题
 *
 *  @return 返回本身
 */
+ (instancetype)baseRowModelWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
