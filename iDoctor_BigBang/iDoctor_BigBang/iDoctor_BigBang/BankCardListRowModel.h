//
//  BankCardListRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "CheckMarkRowModel.h"
#import "GlideManger.h"
@interface BankCardListRowModel : CheckMarkRowModel

@property(nonatomic, strong) BankCard *bankCard;


+ (instancetype)bankCardListRowModelWithBankCard:(BankCard *)bankCard;

@end
