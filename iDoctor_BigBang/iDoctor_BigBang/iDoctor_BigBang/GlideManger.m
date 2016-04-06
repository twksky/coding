//
//  GlideManger.m
//  iDoctor_BigBang
//
//  Created by hexy on 8/1/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "GlideManger.h"

@implementation GlideManger
+ (void)balanceGlideWithAccountId:(NSInteger)accountId Page:(NSInteger)page size:(NSInteger)size success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"api/accounting_journals/%ld",accountId];
     NSDictionary *dict = @{@"page" : @(page), @"size" : @(size)};
    
    [[APIManager sharedManager] GET:urlPath parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            
            NSMutableArray *arrM = [BalanceGlide objectArrayWithKeyValuesArray:responseObject[@"accounting_journals"]];
            success(arrM);
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }

    }];
}

+ (void)integralGlideWithAccountId:(NSInteger)accountId Page:(NSInteger)page size:(NSInteger)size success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSDictionary *dict = @{@"page" : @(page), @"size" : @(size)};
    
    [[APIManager sharedManager] GET:@"api/doctors/score" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            
            NSMutableArray *arrM = [IntegralGlide objectArrayWithKeyValuesArray:responseObject[@"scores"]];
            success(arrM);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

// 得到银行卡列表
+ (void)bankCardListWithAccountId:(NSInteger)accountId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"v4/doctors/%ld/bank_accounts",accountId];
    
    [[APIManager sharedManager] GET:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            NSMutableArray *arrM = [BankCard objectArrayWithKeyValuesArray:responseObject[@"bank_accounts"]];
            success(arrM);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }

    }];
}

// 增加银行卡
+ (void)addBankCardWithCardNum:(NSString *)cardNum AccountId:(NSInteger)accountId isDefault:(BOOL)isDefault success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"v4/doctors/%ld/bank_accounts",accountId];
    NSDictionary *dict = @{@"bank_account":cardNum, @"is_default":@(isDefault)};
    
    [[APIManager sharedManager] POST:urlPath parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        GDLog(@"%@",responseObject);
        if (success) {
            success(@"添加成功！");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 提现
+ (void)chargeWithAccount:(NSInteger)accoutdId chargeRequest:(ChargeRequest *)request success:(void (^)(NSInteger))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"v4/doctors/%ld/withdrawals",accoutdId];
//    GDLog(@"%@",urlPath);
    [[APIManager sharedManager] POST:urlPath parameters:request.keyValues success:^(NSURLSessionDataTask *task, id responseObject) {
        
        GDLog(@"%@",responseObject);
        if (success) {
            success((NSInteger)responseObject[@"balance"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)getGoodsIfSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [[APIManager sharedManager] GET:@"api/score_gifts" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            NSMutableArray *arrM = [Goods objectArrayWithKeyValuesArray:responseObject[@"score_gifts"]];
            success(arrM);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }

    }];
}

// 
+ (void)getGoodsDetailWithGoodsId:(NSInteger)goodsId success:(void (^)(GoodsDetail *))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"/v4/gifts/%ld",goodsId];
    
    [[APIManager sharedManager] GET:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        GDLog(@"%@",responseObject);
        if (success) {
            GoodsDetail *gd = [GoodsDetail objectWithKeyValues:responseObject];
            success(gd);
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}


// 积分兑换余额
+ (void)exchangeMoneyWithScore:(int)score  success:(void(^)(ExchangeMoney *money))success
                       failure:(void(^)(NSError *error))failure
{
    NSString *string = [NSString stringWithFormat:@"api/score_gifts/%d/actions/exchange_balance",score];
    
    [[APIManager sharedManager] POST:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
        if (success) {
            
            ExchangeMoney *model = [ExchangeMoney objectWithKeyValues:responseObject];
            success(model);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (error) {
            failure(error);
        }
        
    }];


}

// 积分兑换商品
+ (void)exchangeGoodsWithGiftID:(int)gift_id success:(void(^)(ExchangeGoods *goods))success
                        failure:(void(^)(NSError *error))failure
{
    NSString *string = [NSString stringWithFormat:@"api/score_gifts/%d/actions/exchange",gift_id];
    
    [[APIManager sharedManager] POST:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            
            ExchangeGoods *model = [ExchangeGoods objectWithKeyValues:responseObject];
            
            success(model);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (error) {
            
            failure(error);
        }
        
    }];


}



@end






@implementation IntegralGlide

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

//- (NSString *)ctime_iso
//{
//    return @"2015-10-20";
//}

@end

@implementation BalanceGlide

- (NSString *)datetime_iso
{
    return @"2015-10-20";
}
- (NSInteger)money
{
    return _money/100;
}
@end

@implementation BankCard



@end

@implementation ChargeRequest


@end

@implementation Goods

//- (NSString *)real_price
//{
//    return @"200元";
//}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"goods_id" : @"id"};
}

@end

@implementation GoodsDetail

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}


@end

@implementation ExchangeMoney

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

@end

@implementation ExchangeGoods

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

@end