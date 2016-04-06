//
//  GoodsList.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "GoodsListRowModel.h"

@implementation GoodsListRowModel
+ (instancetype)goodsListRowModelWithGoods:(Goods *)goods
{
    GoodsListRowModel *g = [[self alloc] init];
    g.goods = goods;
    return g;
}
@end
