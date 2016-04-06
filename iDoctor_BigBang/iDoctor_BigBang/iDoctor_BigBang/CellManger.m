//
//  CellManger.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "CellManger.h"
#import "BaseCell.h"
#import "BriefIntroCell.h"
#import "AvatarCell.h"
#import "QrCodeCell.h"
#import "AddrCell.h"
#import "LogoutCell.h"
#import "TextViewCell.h"
#import "TextFieldCell.h"
#import "RecruitRatioCell.h"
#import "RecruitTitleCell.h"
#import "CheckBoxCell.h"
#import "IntegralListCell.h"
#import "GoodsListCell.h"
#import "BalanceListCell.h"
#import "BankCardCell.h"


#import "GoodsListRowModel.h"

@interface CellManger ()<UIAlertViewDelegate>

@end

@implementation CellManger

+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView rowModel:(BaseRowModel *)rowModel
{
    
    if ([rowModel isKindOfClass:[BriefIntroRowModel class]]) {
        
        BriefIntroCell *cell = [BriefIntroCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    if ([rowModel isKindOfClass:[BankCardListRowModel class]]) {
        
        BankCardCell *cell = [BankCardCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    if ([rowModel isKindOfClass:[RecruitRatioRowModel class]]) {
        
        RecruitRatioCell *cell = [RecruitRatioCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }

    if ([rowModel isKindOfClass:[CheckBoxRowModel class]]) {
        
        CheckBoxCell *cell = [CheckBoxCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }

    if ([rowModel isKindOfClass:[AvatarRowModel class]]) {
        
        AvatarCell *cell = [AvatarCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    if ([rowModel isKindOfClass:[IntegralListRowModel class]]) {
        
        IntegralListCell *cell = [IntegralListCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    if ([rowModel isKindOfClass:[GoodsListRowModel class]]) {
        
        GoodsListCell *cell = [GoodsListCell cellWithTableView:tableView];
        
        cell.block = ^(GoodsListRowModel *model){
        
            goodsModel = model;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shopWithExchange" object:goodsModel.goods];
//            [self shopWithExchange:goodsModel.goods];
        };

        [cell setDataWithModel:rowModel];
        return cell;
    }
    if ([rowModel isKindOfClass:[BalanceListRowModel class]]) {
        
        BalanceListCell *cell = [BalanceListCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    if ([rowModel isKindOfClass:[BankCardRowModel class]]) {
        
        BankCardCell *cell = [BankCardCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    
    if ([rowModel isKindOfClass:[QrCodeRowModel class]]) {
        
        QrCodeCell *cell = [QrCodeCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }

    if ([rowModel isKindOfClass:[AddrRowModel class]]) {
        AddrCell *cell = [AddrCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    if ([rowModel isKindOfClass:[RecruitTitleRowModel class]]) {
        RecruitTitleCell *cell = [RecruitTitleCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }

    if ([rowModel isKindOfClass:[TextFieldRowModel class]]) {
        TextFieldCell *cell = [TextFieldCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }

    if ([rowModel isKindOfClass:[TextViewRowModel class]]) {
        TextViewCell *cell = [TextViewCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }

    if ([rowModel isKindOfClass:[LogoutModel class]]) {
        LogoutCell *cell = [LogoutCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    
    if ([rowModel isKindOfClass:[BaseRowModel class]]) {
        
        BaseCell *cell = [BaseCell cellWithTableView:tableView];
        [cell setDataWithModel:rowModel];
        return cell;
    }
    return nil;
}


@end
