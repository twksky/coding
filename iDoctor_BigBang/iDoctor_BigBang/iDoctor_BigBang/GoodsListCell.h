//
//  GoodsListCell.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseCell.h"

@class GoodsListRowModel;

typedef void(^exchangeButtonBlock)(GoodsListRowModel *model);

@interface GoodsListCell : BaseCell

@property (nonatomic, copy) exchangeButtonBlock block;

@end
