//
//  BankCardListRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BankCardListRowModel.h"

@implementation BankCardListRowModel

+ (instancetype)bankCardListRowModelWithBankCard:(BankCard *)bankCard
{
    BankCardListRowModel *bList = [[self alloc] init];
    bList.bankCard = bankCard;
    return bList;
}
@end
