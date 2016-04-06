//
//  GlideManger.h
//  iDoctor_BigBang
//
//  Created by hexy on 8/1/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IntegralGlide,BalanceGlide,BankCard,ChargeRequest, Goods, GoodsDetail,ExchangeGoods,ExchangeMoney;
@interface GlideManger : NSObject

+ (void)balanceGlideWithAccountId:(NSInteger)accountId
                        Page:(NSInteger)page
                        size:(NSInteger)size
                     success:(void(^)(NSArray *balanceGlideArray))success
                     failure:(void(^)(NSError *error))failure;

+ (void)integralGlideWithAccountId:(NSInteger)accountId
                        Page:(NSInteger)page
                        size:(NSInteger)size
                     success:(void(^)(NSArray *integralGlideArray))success
                     failure:(void(^)(NSError *error))failure;

+ (void)bankCardListWithAccountId:(NSInteger)accountId
                          success:(void(^)(NSArray *bankCardList))success
                          failure:(void(^)(NSError *error))failure;

+ (void)addBankCardWithCardNum:(NSString *)cardNum
                     AccountId:(NSInteger)accountId
                     isDefault:(BOOL)isDefault
                       success:(void(^)(NSString *msg))success
                       failure:(void(^)(NSError *error))failure;

+ (void)chargeWithAccount:(NSInteger)accoutdId
            chargeRequest:(ChargeRequest *)request
                  success:(void(^)(NSInteger balance))success
                  failure:(void(^)(NSError *error))failure;

+ (void)getGoodsIfSuccess:(void(^)(NSArray *goods))success
                  failure:(void(^)(NSError *error))failure;

+ (void)getGoodsDetailWithGoodsId:(NSInteger)goodsId
                          success:(void(^)(GoodsDetail *goodsDetail))success
                          failure:(void(^)(NSError *error))failure;

// 积分兑换余额
+ (void)exchangeMoneyWithScore:(int)score  success:(void(^)(ExchangeMoney *money))success
                       failure:(void(^)(NSError *error))failure;

// 积分兑换商品
+ (void)exchangeGoodsWithGiftID:(int)gift_id success:(void(^)(ExchangeGoods *goods))success
                        failure:(void(^)(NSError *error))failure;








@end

@interface IntegralGlide : NSObject

@property(nonatomic, assign) NSInteger count;
@property(nonatomic, copy) NSString *ctime_iso;
@property(nonatomic, copy) NSString *desc;

@end

@interface BalanceGlide : NSObject

@property(nonatomic, assign) NSInteger balance;
@property(nonatomic, assign) NSInteger money;
@property(nonatomic, copy) NSString *datetime_iso;
@property(nonatomic, copy) NSString *project;

@end

@interface BankCard : NSObject

@property(nonatomic, assign) BOOL is_default;
@property(nonatomic, copy) NSString *bank_account;
@property(nonatomic, copy) NSString *bankname;
@property(nonatomic, copy) NSString *bank_logo_url;
@end

@interface ChargeRequest : NSObject

@property(nonatomic, assign) NSNumber *money;
@property(nonatomic, copy) NSString *bank_account;
@property(nonatomic, copy) NSString *payee;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *id_card;

@end

@interface Goods : NSObject
@property(nonatomic, assign) NSInteger goods_id;

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *need_score;
@property(nonatomic, copy) NSString *real_price;
@property(nonatomic, copy) NSString *pic_url;
@end

@interface GoodsDetail : NSObject


@property (nonatomic, copy) NSString *status_message;

@property (nonatomic, copy) NSString *pic_url;

@property (nonatomic, assign) NSInteger need_score;

@property (nonatomic, copy) NSString *validity_period;

@property (nonatomic, assign) NSInteger status_code;

@property (nonatomic, copy) NSString *real_price;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *name;

@end


// 积分兑换余额
@interface ExchangeMoney : NSObject

@property (nonatomic, assign) NSInteger remain_score;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) NSInteger balance;

@end

// 积分兑换商品
@interface ExchangeGoods : NSObject

@property (nonatomic, assign) NSInteger gift_id;

@property (nonatomic, assign) NSInteger remain_score;

@property (nonatomic, strong) NSString *desc;

@end

