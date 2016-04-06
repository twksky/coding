//
//  ArrowRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"

@interface ArrowRowModel : BaseRowModel
/**
 *  点击这一行要跳转的控制器
 */
@property (nonatomic, assign) Class destVC;
/**
 *  创建模型
 *
 *  @param icon   图标
 *  @param title  标题
 *  @param destVC 要跳转的控制器
 *
 *  @return
 */
+ (instancetype)arrowRowWithTitle:(NSString *)title destVC:(Class)destVC;

/**
 *  创建模型
 *
 *  @param icon   图标
 *  @param title  标题
 *  @param destVC 要跳转的控制器
 *
 *  @return
 */
+ (instancetype)arrowRowWithIcon:(UIImage *)icon title:(NSString *)title destVC:(Class)destVC;
/**
 *  创建模型
 *
 *  @param title    <#title description#>
 *  @param subtitle <#subtitle description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)arrowRowModelWithTitle:(NSString *)title subtitle:(NSString *)subtitle destVC:(Class)destVC;
/**
 *  创建模型
 *
 *  @param title    <#title description#>
 *  @param subtitle <#subtitle description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)arrowRowModelWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVC:(Class)destVC;

@end
