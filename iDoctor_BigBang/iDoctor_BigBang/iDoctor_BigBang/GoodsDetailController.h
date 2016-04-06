//
//  GoodsDetailController.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyBaseController.h"

typedef void(^successBlock)();

@interface GoodsDetailController : MyBaseController

@property(nonatomic, assign) NSInteger goods_id;

@property (nonatomic, strong) NSString *need_score;

@property (nonatomic, copy) successBlock block;

@end
