//
//  BriefIntroRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"
#import "Account.h"

typedef void(^IntegralBtnClickBlock)(void);
typedef void(^BalacneBtnClickBlock)(void);

@interface BriefIntroRowModel : BaseRowModel
@property(nonatomic, strong) Account *accout;
@property(nonatomic, copy) IntegralBtnClickBlock integralBtnClickBlock;
@property(nonatomic, copy) BalacneBtnClickBlock balacneBtnClickBlock;
/**
 *  创建模型
 *
 *  @param accountModel 用户账户模型
 *
 *  @return
 */
+ (instancetype)briefIntroRowWithAccountModel:(Account *)account;

- (void)setIntegralBtnClickBlock:(IntegralBtnClickBlock)integralBtnClickBlock;
- (void)setBalacneBtnClickBlock:(BalacneBtnClickBlock)balacneBtnClickBlock;
@end
