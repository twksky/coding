//
//  CellManger.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionModel.h"
#import "BaseRowModel.h"
#import "ArrowRowModel.h"
#import "CheckMarkRowModel.h"
#import "BriefIntroRowModel.h"
#import "AvatarRowModel.h"
#import "QrCodeRowModel.h"
#import "AddrRowModel.h"
#import "LogoutModel.h"
#import "TextViewRowModel.h"
#import "TextFieldRowModel.h"
#import "RecruitRatioRowModel.h"
#import "RecruitTitleRowModel.h"
#import "CheckBoxRowModel.h"
#import "IntegralListRowModel.h"
#import "GoodsListRowModel.h"
#import "BalanceListRowModel.h"
#import "BankCardRowModel.h"
#import "BankCardListRowModel.h"

#import "GoodsListCell.h"
@class BaseRowModel,GoodsListRowModel,ShopingController;

static GoodsListRowModel *goodsModel = nil;

@interface CellManger : NSObject

@property (nonatomic, strong) GoodsListRowModel *goodModel;
@property (nonatomic,weak) id delegate;

/**
 *  根据不同的模型创建不同的Cell
 *
 *  @param tableView          tableView
 *  @param memberBaseRowModel cell所对应的模型
 */
+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView rowModel:(BaseRowModel *)rowModel;

@end
