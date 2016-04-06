//
//  BriefIntroRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BriefIntroRowModel.h"

@implementation BriefIntroRowModel
+ (instancetype)briefIntroRowWithAccountModel:(Account *)account
{
    BriefIntroRowModel *briefIntro = [[self alloc] init];
    
    briefIntro.accout = account;
    return briefIntro;

}
- (void)setIntegralBtnClickBlock:(IntegralBtnClickBlock)integralBtnClickBlock
{
    _integralBtnClickBlock = integralBtnClickBlock;
}
- (void)setBalacneBtnClickBlock:(BalacneBtnClickBlock)balacneBtnClickBlock
{
    _balacneBtnClickBlock = balacneBtnClickBlock;
}
@end
