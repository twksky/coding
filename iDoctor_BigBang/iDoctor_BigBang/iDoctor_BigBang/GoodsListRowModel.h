//
//  GoodsList.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"

@interface GoodsListRowModel : BaseRowModel
@property(nonatomic, strong) Goods *goods;
+ (instancetype)goodsListRowModelWithGoods:(Goods *)goods;
@end
