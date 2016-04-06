//
//  AccountManager.m
//  AppFramework
//
//  Created by ABC on 7/1/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "AccountManager.h"
#import <JSONKit-NoWarning/JSONKit.h>
#import "ManagerUtil.h"
#import <NSString+MKNetworkKitAdditions.h>
#import "AppUtil.h"
#import "AppNetworkManager.h"

@interface AccountManager ()

+ (Account *)parseAccountFromJson:(NSDictionary *)jsonData;
+ (RegionItem *)parseRegionItemFromJson:(NSDictionary *)jsonData withRegionCode:(NSInteger)regionCode;
+ (Bankcard *)parseBankcardFromJson:(NSDictionary *)jsonData;
+ (HospitalItem *)parseHospitalItemFromJson:(NSDictionary *)jsonData;
+ (ImageHandle *)parseImageHandleFromJson:(NSDictionary *)jsonData;
+ (Patient *)parsePatientFromJson:(NSDictionary *)jsonData;
+ (MedicalRecord *)parseMedicalRecordFromJson:(NSDictionary *)jsonData;
+ (GiftItem *)parseGiftItemFromJson:(NSDictionary *)jsonData;
+ (Payments *)parsePaymentsItemFromJson:(NSDictionary *)jsonData;
+ (WithdrawalParam *)parseWithdrawalParamFromJson:(NSDictionary *)jsonData;
+ (Comment *)parseCommentFromJson:(NSDictionary *)jsonData;
+ (NSMutableArray *)parseCommentListFromJson:(NSDictionary *)jsonData;
+ (QuickQuestion *)parseQuickQuestionFromJson:(NSDictionary *)jsonData;
+ (FamilyMember *)parseFamilyMemberFromJson:(NSDictionary *)jsonData;
+ (UrgentCallInfo *)parseUrgentCallInfoFromJson:(NSDictionary *)jsonData;
+ (FollowUpItem *)parseFollowUpItemFromJson:(NSDictionary *)jsonData;
+ (FollowUpReport *)parseFollowUpReportFromJson:(NSDictionary *)jsonData;

- (BOOL)isNetworkReachableWithErrorHandler:(void (^)(NSError *error))errorHandler;

@end

@implementation AccountManager

+ (AccountManager *)sharedInstance
{
    static AccountManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AccountManager alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark - Property

- (AppNetworkEngine *)networkEngine
{
    if (!_networkEngine) {
        _networkEngine = [[AppNetworkEngine alloc] initWithHostName:kHostName];
        [_networkEngine useCache];
    }
    return _networkEngine;
}


#pragma mark - Class Method

+ (Account *)parseAccountFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        Account *account = [[Account alloc] init];
        account.accountID           = [[jsonData objectForKey:@"id"] integerValue];
        account.loginName           = [jsonData objectForKey:@"loginname"];
        account.easemobPassword     = [jsonData objectForKey:@"easemob_passwd"];
        account.token               = [jsonData objectForKey:@"token"];
        account.isOnline            = [[jsonData objectForKey:@"online"] boolValue];
        
        account.mobile              = [jsonData objectForKey:@"mobile"];
        account.realName            = [jsonData objectForKey:@"realname"];
        account.region              = [[RegionItem alloc] init];
        account.region.name         = [jsonData objectForKey:@"region"];
        account.region.code         = [[jsonData objectForKey:@"region_id"] integerValue];
        account.hospital            = [[HospitalItem alloc] init];
        account.hospital.name       = [ManagerUtil filterObject:[jsonData objectForKey:@"hospital"]];
        account.hospital.hospitalID = [[jsonData objectForKey:@"hosptial_id"] integerValue];
        account.department          = [jsonData objectForKey:@"department"];
        account.title               = [jsonData objectForKey:@"title"];
        account.schedule            = [jsonData objectForKey:@"schedule"];
        account.brief               = [jsonData objectForKey:@"brief"];
        account.credentialsID       = [jsonData objectForKey:@"credentials_id"];
        account.certificateImageURLString   = [jsonData objectForKey:@"credentials_url"];
        account.officePhone         = [jsonData objectForKey:@"office_phone"];
        account.avatarImageURLString        = [jsonData objectForKey:@"avatar_url"];
        account.qCodeImageUrlString = [jsonData objectForKey:@"qr_code_url"];
        account.pinYinName          = [AppUtil pinyinFromChiniseString:account.realName];
        
        account.hospitalAskPrice    = [[jsonData objectForKey:@"hospital_ask_price"] integerValue];
        account.outPatientAskPrice  = [[jsonData objectForKey:@"outpatient_ask_price"] integerValue];
        account.urgencyAskPrice     = [[jsonData objectForKey:@"urgency_ask_price"] integerValue];
        account.score               = [[ManagerUtil filterObject:[jsonData objectForKey:@"score"]] integerValue];
        account.balance             = [[ManagerUtil filterObject:[jsonData objectForKey:@"balance"]] integerValue];
        
        return account;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (RegionItem *)parseRegionItemFromJson:(NSDictionary *)jsonData withRegionCode:(NSInteger)regionCode
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        RegionItem *regionItem = [[RegionItem alloc] init];
        regionItem.code             = regionCode;
        regionItem.level            = [[jsonData objectForKey:@"deepth"] integerValue];
        regionItem.name             = [jsonData objectForKey:@"name"];
        NSArray *subRegionsArray    = [jsonData objectForKey:@"sub_regions"];
        if ([subRegionsArray count] > 0) {
            regionItem.subItemArray = [[NSMutableArray alloc] init];
        }
        for (NSDictionary *subRegionItemDic in subRegionsArray) {
            RegionItem *subRegionItem = [[RegionItem alloc] init];
            subRegionItem.code             = [[subRegionItemDic objectForKey:@"id"] integerValue];
            subRegionItem.level            = [[subRegionItemDic objectForKey:@"deepth"] integerValue];
            subRegionItem.name             = [subRegionItemDic objectForKey:@"name"];
            subRegionItem.pinYinName       = [subRegionItemDic objectForKey:@"pinyin"];
            if (!subRegionItem.pinYinName || [subRegionItem.pinYinName isEqual:[NSNull null]]) {
                subRegionItem.pinYinName   = [AppUtil pinyinFromChiniseString:subRegionItem.name];
            }
            [regionItem.subItemArray addObject:subRegionItem];
        }
        return regionItem;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (Bankcard *)parseBankcardFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        Bankcard *bankcard = [[Bankcard alloc] init];
        bankcard.cardID         = [jsonData objectForKey:@"bank_account"];
        bankcard.cardName       = [jsonData objectForKey:@"name"];
        bankcard.cardType       = [jsonData objectForKey:@"type"];
        bankcard.isDefault      = [[jsonData objectForKey:@"is_default"] boolValue];
        return bankcard;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (HospitalItem *)parseHospitalItemFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        HospitalItem *hospital = [[HospitalItem alloc] init];
        hospital.hospitalID = [[jsonData objectForKey:@"id"] integerValue];
        hospital.name       = [jsonData objectForKey:@"name"];
        hospital.regionID   = [[jsonData objectForKey:@"region_id"] integerValue];
        hospital.grade      = [jsonData objectForKey:@"grade"];
        return hospital;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (ScoreModel *)parseScoreModelFromJson:(NSDictionary *)jsonData {
    
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        ScoreModel *scoreModel = [[ScoreModel alloc] init];
        // 用户ID
        scoreModel.scoreId     = [[ManagerUtil filterObject:[jsonData objectForKey:@"id"]] integerValue];
        // 数量
        scoreModel.count       = [[ManagerUtil filterObject:[jsonData objectForKey:@"count"]] integerValue];
        // 描述
        scoreModel.scoreDescription = [ManagerUtil filterObject:[jsonData objectForKey:@"description"]];
        scoreModel.scoreCtimeIso = [ManagerUtil filterObject:[jsonData objectForKey:@"ctime_iso"]];
        return scoreModel;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (GoodsModel *)parseGoodsModelFromJson:(NSDictionary *)jsonData {
    
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        GoodsModel *goodsModel = [[GoodsModel alloc] init];
        goodsModel.goodsId = [[ManagerUtil filterObject:[jsonData objectForKey:@"id"]] integerValue];
        goodsModel.name = [ManagerUtil filterObject:[jsonData objectForKey:@"name"]];
        goodsModel.needScore = [[ManagerUtil filterObject:[jsonData objectForKey:@"need_score"]] integerValue];
        goodsModel.realPrice = [ManagerUtil filterObject:[jsonData objectForKey:@"real_price"]];
        goodsModel.picUrl = [ManagerUtil filterObject:[jsonData objectForKey:@"pic_url"]];
        
        return goodsModel;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (ImageHandle *)parseImageHandleFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        ImageHandle *imageHandle    = [[ImageHandle alloc] init];
        imageHandle.imageID         = [[jsonData objectForKey:@"id"] integerValue];
        imageHandle.imageName       = [jsonData objectForKey:@"name"];
        imageHandle.imageURLString  = [jsonData objectForKey:@"url"];
        return imageHandle;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (Patient *)parsePatientFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        Patient *patient = [[Patient alloc] init];
        patient.avatarURLString     = [ManagerUtil filterObject:[jsonData objectForKey:@"avatar_url"]];
        NSNumber *userIDNumber      = [ManagerUtil filterObject:[jsonData objectForKey:@"user_id"]];
        if (nil == userIDNumber) {
            userIDNumber            = [ManagerUtil filterObject:[jsonData objectForKey:@"id"]];
        }
        patient.userID              = [userIDNumber integerValue];
        patient.loginName           = [jsonData objectForKey:@"loginname"];
        if (![patient.loginName isEqual:[NSNull null]]) {
            patient.pinYinLoginName = [AppUtil pinyinFromChiniseString:patient.loginName];
        } else {
            patient.loginName = patient.pinYinLoginName = nil;
        }
        patient.realName            = [ManagerUtil filterObject:[jsonData objectForKey:@"realname"]];
        if (![patient.realName isEqual:[NSNull null]]) {
            patient.pinYinRealName  = [AppUtil pinyinFromChiniseString:patient.realName];
        } else {
            patient.realName = patient.pinYinRealName = nil;
        }
        patient.noteName            = [jsonData objectForKey:@"memo"];
        if (![patient.noteName isEqual:[NSNull null]]) {
            patient.pinYinNoteName  = [AppUtil pinyinFromChiniseString:patient.noteName];
        } else {
            patient.noteName = patient.pinYinNoteName = nil;
        }
        patient.flowerAcceptance    = [[jsonData objectForKey:@"flower_acceptance"] integerValue];
        patient.flowerInvitation    = [[jsonData objectForKey:@"flower_invitation"] integerValue];
        patient.isBlocked           = [[jsonData objectForKey:@"blocked"] boolValue];
        patient.isStarted           = [[jsonData objectForKey:@"started"] boolValue];
        patient.firstFamilyMember   = [AccountManager parseFamilyMemberFromJson:[jsonData valueForKey:@"person"]];
        return patient;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (MedicalRecord *)parseMedicalRecordFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        MedicalRecord *medicalRecord = [[MedicalRecord alloc] init];
        medicalRecord.recordID      = [[ManagerUtil filterObject:[jsonData objectForKey:@"id"]] integerValue];
        medicalRecord.dateISO       = [ManagerUtil filterObject:[jsonData objectForKey:@"date_iso"]];
        medicalRecord.personID      = [[ManagerUtil filterObject:[jsonData objectForKey:@"person_id"]] integerValue];
        medicalRecord.doctorName    = [ManagerUtil filterObject:[jsonData objectForKey:@"doctor_name"]];
        medicalRecord.hospitial     = [ManagerUtil filterObject:[jsonData objectForKey:@"hospitial"]];
        medicalRecord.name          = [ManagerUtil filterObject:[jsonData objectForKey:@"name"]];
        medicalRecord.gender        = [ManagerUtil filterObject:[jsonData objectForKey:@"sex"]];
        medicalRecord.age           = [[ManagerUtil filterObject:[jsonData objectForKey:@"age"]] integerValue];
        medicalRecord.allergies     = [ManagerUtil filterObject:[jsonData objectForKey:@"allergies"]];
        medicalRecord.recordDescription   = [ManagerUtil filterObject:[jsonData objectForKey:@"description"]];
        medicalRecord.imagesCount   = [[ManagerUtil filterObject:[jsonData objectForKey:@"images_count"]] integerValue];
        medicalRecord.imagesURLs    = [ManagerUtil filterObject:[jsonData objectForKey:@"images_url"]];
        return medicalRecord;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (GiftItem *)parseGiftItemFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        id dataItem                 = nil;
        GiftItem *giftItem          = [[GiftItem alloc] init];
        giftItem.dealID             = [[jsonData objectForKey:@"id"] integerValue];
        giftItem.userID             = [[jsonData objectForKey:@"user_id"] integerValue];
        giftItem.userLoginName      = [jsonData objectForKey:@"user_loginname"];
        giftItem.userRealName       = [jsonData objectForKey:@"user_realname"];
        giftItem.doctorID           = [[jsonData objectForKey:@"doctor_id"] integerValue];
        giftItem.doctorLoginName    = [jsonData objectForKey:@"doctor_loginname"];
        giftItem.doctorRealName     = [jsonData objectForKey:@"doctor_realname"];
        giftItem.number             = [[jsonData objectForKey:@"number"] integerValue];
        giftItem.money              = [[jsonData objectForKey:@"money"] integerValue];
        dataItem                    = [jsonData objectForKey:@"accepted"];
        giftItem.acceptState        = [dataItem isEqual:[NSNull null]] ? -1 : [dataItem integerValue];
        giftItem.project            = [jsonData objectForKey:@"project"];
        giftItem.dateTimeISO        = [jsonData objectForKey:@"datetime_iso"];
        return giftItem;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (BlogItem *)parseBlogItemFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        BlogItem *blogItem          = [[BlogItem alloc] init];
        blogItem.blogId             = [[jsonData objectForKey:@"id"] integerValue];
        blogItem.username           = [jsonData objectForKey:@"username"];
        blogItem.bannerUrl          = [jsonData objectForKey:@"banner_url"];
        blogItem.title              = [jsonData objectForKey:@"title"];
        blogItem.url                = [jsonData objectForKey:@"url"];
        blogItem.shortDesc          = [jsonData objectForKey:@"short_desc"];
        blogItem.commentCount       = [[ManagerUtil filterObject:[jsonData objectForKey:@"comment_count"]] integerValue];

        return blogItem;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (Payments *)parsePaymentsItemFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        Payments *paymentsItem      = [[Payments alloc] init];
        paymentsItem.balance        = [[jsonData objectForKey:@"balance"] longValue];
        paymentsItem.dateTimeISO    = [jsonData objectForKey:@"datetime_iso"];
        paymentsItem.recordID       = [[jsonData objectForKey:@"id"] integerValue];
        paymentsItem.money          = [[jsonData objectForKey:@"money"] longValue];
        paymentsItem.partnerID      = [[jsonData objectForKey:@"partner_id"] integerValue];
        paymentsItem.project        = [jsonData objectForKey:@"project"];
        return paymentsItem;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (TemplateModel *)parseTemplateModelFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        TemplateModel *templateModel        = [[TemplateModel alloc] init];
        templateModel.templateId            = [[ManagerUtil filterObject:[jsonData objectForKey:@"id"]] integerValue];
        templateModel.name                  = [ManagerUtil filterObject:[jsonData objectForKey:@"name"]];
        templateModel.last_time             = [[ManagerUtil filterObject:[jsonData valueForKey:@"last_time"]] boolValue];
        templateModel.age                   = [[ManagerUtil filterObject:[jsonData valueForKey:@"age"]] boolValue];
        templateModel.sex                   = [[ManagerUtil filterObject:[jsonData valueForKey:@"sex"]] boolValue];
        templateModel.symptomDescription    = [[ManagerUtil filterObject:[jsonData valueForKey:@"description"]] boolValue];
        templateModel.images                = [[ManagerUtil filterObject:[jsonData valueForKey:@"images"]] boolValue];
        //TODO 得到string array
        templateModel.fields                = [ManagerUtil filterObject:[jsonData objectForKey:@"fields"]];
//        templateModel.category              = [AccountManager parseTemplateCategoryModelFromJson:[jsonData objectForKey:@"category"]];
        
        
        return templateModel;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (TemplateCategoryModel *)parseTemplateCategoryModelFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        TemplateCategoryModel *templateCategoryModel        = [[TemplateCategoryModel alloc] init];
        templateCategoryModel.categoryId                    = [[ManagerUtil filterObject:[jsonData objectForKey:@"id"]] integerValue];
        templateCategoryModel.name                          = [ManagerUtil filterObject:[jsonData objectForKey:@"name"]];
        templateCategoryModel.count                         = [[ManagerUtil filterObject:[jsonData objectForKey:@"count"]] integerValue];
        templateCategoryModel.iconUrl                       = [ManagerUtil filterObject:[jsonData objectForKey:@"icon_url"]];
        
        return templateCategoryModel;
    } @catch (NSException *exception) {
        return nil;
    }
}


+ (WithdrawalParam *)parseWithdrawalParamFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        WithdrawalParam *param      = [[WithdrawalParam alloc] init];
        param.platformRate          = [[jsonData objectForKey:@"rate"] floatValue];
        param.bankRate              = [[jsonData objectForKey:@"bank_rate"] floatValue];
        return param;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (Comment *)parseCommentFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        Comment *comment = [[Comment alloc] init];
        comment.commentID = [[jsonData objectForKey:@"id"] integerValue];
        comment.commentDescription = [jsonData objectForKey:@"description"];
        comment.doctor = [AccountManager parseAccountFromJson:[jsonData objectForKey:@"doctor"]];
        comment.ctimeISO = [ManagerUtil filterObject:[jsonData objectForKey:@"ctime_iso"]];
        return comment;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (NSMutableArray *)parseCommentListFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        NSMutableArray *commentList = [[NSMutableArray alloc] init];
        NSArray *responseCommentList = [jsonData objectForKey:@"comments"];
        for (NSDictionary *jsonDic in responseCommentList) {
            Comment *comment = [AccountManager parseCommentFromJson:jsonDic];
            [commentList addObject:comment];
        }
        return commentList;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (QuickQuestion *)parseQuickQuestionFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        QuickQuestion *question  = [[QuickQuestion alloc] init];
        question.questionID     = [[ManagerUtil filterObject:[jsonData objectForKey:@"id"]] integerValue];
        question.userID         = [[ManagerUtil filterObject:[jsonData objectForKey:@"user_id"]] integerValue];
        question.regionID       = [[ManagerUtil filterObject:[jsonData objectForKey:@"region_id"]] integerValue];
        question.conditionDescription   = [ManagerUtil filterObject:[jsonData objectForKey:@"description"]];
        question.imagesURLStrings       = [ManagerUtil filterObject:[jsonData objectForKey:@"images_url"]];
        question.imagesCount            = [[ManagerUtil filterObject:[jsonData objectForKey:@"images_count"]] integerValue];
        question.lastTime               = [ManagerUtil filterObject:[jsonData objectForKey:@"last_time"]];
        question.incentives             = [ManagerUtil filterObject:[jsonData objectForKey:@"burst_reason"]];
        question.otherDisease           = [ManagerUtil filterObject:[jsonData objectForKey:@"medicine"]];
        question.operationHistory       = [ManagerUtil filterObject:[jsonData objectForKey:@"surgery"]];
        question.geneticHistory         = [ManagerUtil filterObject:[jsonData objectForKey:@"genetic_disease"]];
        question.department             = [ManagerUtil filterObject:[jsonData objectForKey:@"department"]];
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
        //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *timeStr               = [ManagerUtil filterObject:[jsonData objectForKey:@"ctime_iso"]];
        question.createTime             = [dateFormatter dateFromString:timeStr];
        timeStr                         = [ManagerUtil filterObject:[jsonData objectForKey:@"mtime_iso"]];
        question.modifyTime             = [dateFormatter dateFromString:timeStr];
        question.comments               = [AccountManager parseCommentListFromJson:jsonData];
        question.commentsCount          = [[jsonData objectForKey:@"comments_count"] integerValue];
        question.patient                = [AccountManager parsePatientFromJson:[jsonData valueForKey:@"user"]];
        question.sex                    = [ManagerUtil filterObject:[jsonData objectForKey:@"sex"]];
        question.age                    = [[ManagerUtil filterObject:[jsonData objectForKey:@"age"]] integerValue];
        return question;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (FamilyMember *)parseFamilyMemberFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        FamilyMember *familyMember  = [[FamilyMember alloc] init];
        familyMember.familyMemberID = [[ManagerUtil filterObject:[jsonData objectForKey:@"id"]] integerValue];
        familyMember.name           = [ManagerUtil filterObject:[jsonData objectForKey:@"name"]];
        familyMember.allergies      = [ManagerUtil filterObject:[jsonData objectForKey:@"allergies"]];
        familyMember.age            = [[ManagerUtil filterObject:[jsonData objectForKey:@"age"]] integerValue];
        familyMember.gender         = [ManagerUtil filterObject:[jsonData objectForKey:@"sex"]];
        familyMember.avatarURLString    = [ManagerUtil filterObject:[jsonData objectForKey:@"avatar_url"]];
        return familyMember;
    } @catch (NSException *exception) {
        return nil;
    }
}


+ (UrgentCallInfo *)parseUrgentCallInfoFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        UrgentCallInfo *info = [[UrgentCallInfo alloc] init];
        info.callID             = [[ManagerUtil filterObject:[jsonData valueForKey:@"id"]] integerValue];
        info.money              = [[ManagerUtil filterObject:[jsonData valueForKey:@"money"]] integerValue];
        info.infoDescription    = [ManagerUtil filterObject:[jsonData valueForKey:@"description"]];
        info.imagesURLStrings   = [ManagerUtil filterObject:[jsonData valueForKey:@"images_url"]];
        info.imagesCount        = [[ManagerUtil filterObject:[jsonData valueForKey:@"images_count"]] integerValue];
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
        //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *dateStr       = [ManagerUtil filterObject:[jsonData valueForKey:@"expire_date_iso"]];
        info.expireDate         = [dateFormatter dateFromString:dateStr];
        dateStr                 = [ManagerUtil filterObject:[jsonData valueForKey:@"ctime_iso"]];
        info.createTime         = [dateFormatter dateFromString:dateStr];
        info.isReceive          = [[ManagerUtil filterObject:[jsonData valueForKey:@"is_receive"]] boolValue];
        info.patient            = [AccountManager parsePatientFromJson:[jsonData valueForKey:@"user"]];
        info.doctor             = [AccountManager parseAccountFromJson:[jsonData valueForKey:@"doctor"]];
        return info;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (FollowUpItem *)parseFollowUpItemFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        FollowUpItem *item = [[FollowUpItem alloc] init];
        item.itemID                     = [[ManagerUtil filterObject:[jsonData valueForKey:@"id"]] integerValue];
        item.imagesURLStrings           = [ManagerUtil filterObject:[jsonData valueForKey:@"images_url"]];
        item.isMedicationCompliance     = [[ManagerUtil filterObject:[jsonData valueForKey:@"medicine_normal"]] boolValue]; // 服药是否正常
        item.woundStatus                = [ManagerUtil filterObject:[jsonData valueForKey:@"wound_status"]];
        item.painStatus                 = [[ManagerUtil filterObject:[jsonData valueForKey:@"pain_status"]] integerValue];
        item.urineStatus                = [ManagerUtil filterObject:[jsonData valueForKey:@"urine"]];
        item.foodStatus                 = [ManagerUtil filterObject:[jsonData valueForKey:@"food_status"]];
        item.symptomsStatus             = [ManagerUtil filterObject:[jsonData valueForKey:@"symptom_status"]];
        NSNumber *indicatorNumber       = [ManagerUtil filterObject:[jsonData valueForKey:@"body_temperature"]];
        item.isSetBodyTemperature       = (nil != indicatorNumber);
        item.bodyTemperature            = [indicatorNumber floatValue];
        item.symptomsDescription        = [ManagerUtil filterObject:[jsonData valueForKey:@"description"]];   // 症状描述
        indicatorNumber                 = [ManagerUtil filterObject:[jsonData valueForKey:@"blood_glucose"]];
        item.isSetBloodGlucose          = (nil != indicatorNumber);
        item.bloodGlucose               = [indicatorNumber floatValue];
        indicatorNumber                 = [ManagerUtil filterObject:[jsonData valueForKey:@"high_blood_pressure"]];
        item.isSetHighBloodPressure     = (nil != indicatorNumber);
        item.highBloodPressure          = [indicatorNumber integerValue];
        indicatorNumber                 = [ManagerUtil filterObject:[jsonData valueForKey:@"low_blood_pressure"]];
        item.isSetLowBloodPressure      = (nil != indicatorNumber);
        item.lowBloodPressure           = [indicatorNumber integerValue];
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
        //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *timeStr               = [ManagerUtil filterObject:[jsonData objectForKey:@"ctime_iso"]];
        item.createTime                 = [dateFormatter dateFromString:timeStr];
        item.isReceived                 = [[ManagerUtil filterObject:[jsonData valueForKey:@"is_receive"]] boolValue];
        return item;
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (FollowUpReport *)parseFollowUpReportFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        
        FollowUpReport *report = [[FollowUpReport alloc] init];
        report.reportID                 = [[jsonData valueForKey:@"id"] integerValue];
        report.followUpType             = [jsonData valueForKey:@"follow_up_type"];
        report.imagesURLStrings         = [jsonData valueForKey:@"images_url"];
        report.imagesCount              = [[jsonData valueForKey:@"images_count"] integerValue];
        report.medicalRecordNumber      = [jsonData valueForKey:@"record_number"];   // 病历号
        report.reportFrequencyInDay     = [[jsonData valueForKey:@"days"] integerValue];
        report.reportCount              = [[jsonData valueForKey:@"count"] integerValue];
        report.patient                  = [AccountManager parsePatientFromJson:[jsonData valueForKey:@"user"]];
        report.doctor                   = [AccountManager parseAccountFromJson:[jsonData valueForKey:@"doctor"]];
        report.reportItems              = [[NSMutableArray alloc] init];
        NSArray *responseItems          = [jsonData valueForKey:@"items"];
        for (NSDictionary *itemData in responseItems) {
            FollowUpItem *item = [AccountManager parseFollowUpItemFromJson:itemData];
            [report.reportItems addObject:item];
        }
        report.isReceive                = [[jsonData valueForKey:@"is_receive"] boolValue];
        report.totalPrice               = [[jsonData valueForKey:@"total_price"] integerValue];
        return report;
    } @catch (NSException *exception) {
        return nil;
    }

}


#pragma mark - Property

- (Account *)account
{
    if (!_account) {
        _account = [[Account alloc] init];
    }
    return _account;
}


#pragma mark - Public Method

- (BOOL)isNetworkReachableWithErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![[AppNetworkManager sharedInstance] isReachable]) {
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"网络错误" forKey:NSLocalizedDescriptionKey];
        NSError *networkError = [[NSError alloc] initWithDomain:kHostName code:404 userInfo:errorDetails];
        if (errorHandler) {
            errorHandler(networkError);
        }
        return NO;
    }
    return YES;

}

- (void)asyncGetCaptchaWithMobile:(NSString *)mobile
            withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor/captcha";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:mobile forKey:@"mobile"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST"];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
       // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncGetCaptchaForRetrievePasswordWithMobile:(NSString *)mobile
                               withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor/retrieve_password";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:mobile forKey:@"mobile"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST"];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncRegisterAccountWithMobile:(NSString *)mobile withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmPassword withRealName:(NSString *)realName withCaptcha:(NSString *)captcha
                 withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctors";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:mobile forKey:@"mobile"];
    [paramDic setValue:[[password md5] uppercaseString] forKey:@"password"];
    [paramDic setValue:[[confirmPassword md5] uppercaseString] forKey:@"confirm_password"];
    if (realName) {
        [paramDic setValue:realName forKey:@"realname"];
    }
    if (captcha) {
        [paramDic setValue:captcha forKey:@"captcha"];
    }
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST"];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            self.account = [AccountManager parseAccountFromJson:jsonRespDic];
            // !--- Reinit Network Engine
            NSDictionary *customHeaderFiledsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.account.token, @"X-AUTH-TOKEN", nil];
            self.networkEngine = [[AppNetworkEngine alloc] initWithHostName:kHostName customHeaderFields:customHeaderFiledsDic];
            // ---!
            completionHandler(self.account);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncLoginWithLoginName:(NSString *)loginName withPassword:(NSString *)password
       withCompletionHandler:(void (^)(Account *account, NSInteger statusCode))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor/login";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [paramDic setObject:[NSNumber numberWithInteger:[appVersion integerValue]] forKey:@"version"];
    [paramDic setValue:loginName forKey:@"loginname"];
    [paramDic setValue:[[password md5] uppercaseString] forKey:@"password"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode || 206 == statusCode || 301 == statusCode || 302 == statusCode) {
            self.account = [AccountManager parseAccountFromJson:jsonRespDic];
            // !--- Reinit Network Engine
            NSDictionary *customHeaderFiledsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.account.token, @"X-AUTH-TOKEN", nil];
            self.networkEngine = [[AppNetworkEngine alloc] initWithHostName:kHostName customHeaderFields:customHeaderFiledsDic];
            // ---!
            completionHandler(self.account, statusCode);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncLogoutWithCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor/login";
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:nil httpMethod:@"DELETE" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncUpdateAccountWithCompletionHandler:(void (^)(Account *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            Account *account = [AccountManager parseAccountFromJson:jsonRespDic];

            completionHandler(account);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncRetrievePassword:(NSString *)password withMobile:(NSString *)mobile withCaptcha:(NSString *)captcha
        withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor/retrieve_password";  // /api/user/retrieve_password
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:mobile forKey:@"mobile"];
    [paramDic setValue:[[password md5] uppercaseString] forKey:@"password"];
    [paramDic setValue:captcha forKey:@"captcha"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncChangeLoginPassword:(NSString *)password withOldPassword:(NSString *)oldPassword
           withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor/change_password";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:[[password md5] uppercaseString] forKey:@"new_password"];
    [paramDic setValue:[[oldPassword md5] uppercaseString] forKey:@"old_password"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncUploadOnlineStatus:(BOOL)isOnline
        withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor/online";
    MKNetworkOperation *op = nil;
    if (isOnline) {
        op = [self.networkEngine operationWithPath:urlPath params:nil httpMethod:@"POST" ssl:NO];
    } else {
        op = [self.networkEngine operationWithPath:urlPath params:nil httpMethod:@"DELETE" ssl:NO];
    }
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncApplyNameCardWithReceiver:(NSString *)receiver withPhone:(NSString *)phone withPostcode:(NSString *)postcode withAddress:(NSString *)address
                 withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/my_name_card";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:receiver forKey:@"receiver"];
    [paramDic setValue:phone forKeyPath:@"phone"];
    [paramDic setValue:postcode forKeyPath:@"postcode"];
    [paramDic setValue:address forKeyPath:@"address"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncUploadAccount:(Account *)accountParam
     withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctor";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    if (accountParam.mobile) {
        [paramDic setObject:accountParam.mobile forKey:@"mobile"];
    }
    if (accountParam.realName) {
        [paramDic setObject:accountParam.realName forKey:@"realname"];
    }
    if (accountParam.region) {
        [paramDic setObject:[NSNumber numberWithInteger:accountParam.region.code] forKey:@"region_id"];
        [paramDic setObject:accountParam.region.name forKey:@"region"];
    }
    if (accountParam.hospital) {
        [paramDic setObject:[NSNumber numberWithInteger:accountParam.hospital.hospitalID] forKey:@"hospital_id"];
        [paramDic setObject:accountParam.hospital.name forKey:@"hospital"];
    }
    if (accountParam.department) {
        [paramDic setObject:accountParam.department forKey:@"department"];
    }
    if (accountParam.title) {
        [paramDic setObject:accountParam.title forKey:@"title"];
    }
    if (accountParam.schedule) {
        [paramDic setObject:accountParam.schedule forKey:@"schedule"];
    }
    if (accountParam.brief) {
        [paramDic setObject:accountParam.brief forKey:@"brief"];
    }
    if (accountParam.credentialsID) {
        [paramDic setObject:accountParam.credentialsID forKey:@"credentials_id"];
    }
    if (accountParam.certificateImageURLString) {
        [paramDic setObject:accountParam.certificateImageURLString forKey:@"credentials_url"];
    }
    if (accountParam.officePhone) {
        [paramDic setObject:accountParam.officePhone forKey:@"office_phone"];
    }
    if (accountParam.avatarImageURLString) {
        [paramDic setObject:accountParam.avatarImageURLString forKey:@"avatar_url"];
    }
    [paramDic setValue:@(accountParam.hospitalAskPrice) forKey:@"hospital_ask_price"];
    [paramDic setValue:@(accountParam.outPatientAskPrice) forKey:@"outpatient_ask_price"];
    [paramDic setValue:@(accountParam.urgencyAskPrice) forKey:@"urgency_ask_price"];
    
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            Account *account = [AccountManager parseAccountFromJson:jsonRespDic];
            self.account = account;
            completionHandler(account);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAccountInfoChanged object:account];
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncUploadHaoyishengMobile:(NSString *)mobile withCaptcha:(NSString *)captcha
              withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    NSString *urlPath = @"/api/doctor/mobile";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:mobile forKey:@"mobile"];
    [paramDic setObject:captcha forKey:@"captcha"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            Account *account = [AccountManager parseAccountFromJson:jsonRespDic];
            self.account = account;
            completionHandler(account);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAccountInfoChanged object:account];
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
       //  DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncUploadAvatarImage:(UIImage *)image
         withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    [self asyncUploadImage:image withCompletionHandler:^(ImageHandle *imageHandle) {
        Account *tmpAccount = [[Account alloc] init];
        tmpAccount.avatarImageURLString = imageHandle.imageURLString;
        [self asyncUploadAccount:tmpAccount withCompletionHandler:completionHandler withErrorHandler:errorHandler];
    } withErrorHandler:errorHandler];

}

- (void)asyncGetPatientListWithCompletionHandler:(void (^)(NSArray *patientList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/my_patients";
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:nil httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *patients = [[NSMutableArray alloc] init];
            NSArray *patientsArray = [jsonRespDic objectForKey:@"patients"];
            for (NSDictionary *patientDic in patientsArray) {
                Patient *patient = [AccountManager parsePatientFromJson:patientDic];
                [patients addObject:patient];
            }
            completionHandler(patients);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncGetMedicalRecordWithUserID:(NSInteger)userID
                  withCompletionHandler:(void (^)(NSArray *medicalRecordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    //NSString *urlPath = [NSString stringWithFormat:@"api/medical_records/person/%@", userID];
    NSString *urlPath = [NSString stringWithFormat:@"api/medical_records/user/%ld", (long)userID];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:nil httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSArray *medicalRecordArray = [jsonRespDic objectForKey:@"medical_records"];
            NSMutableArray *resultArray = [[NSMutableArray alloc] init];
            for (NSDictionary *medicalRecordDic in medicalRecordArray) {
                MedicalRecord *medicalRecord = [AccountManager parseMedicalRecordFromJson:medicalRecordDic];
                [resultArray addObject:medicalRecord];
            }
            completionHandler(resultArray);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncGetMedicalRecordWithID:(NSInteger)medicalRecordID
              withCompletionHandler:(void (^)(MedicalRecord *medicalRecord))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/medical_record/%ld", (long)medicalRecordID];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:nil httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            MedicalRecord *medicalRecord = [AccountManager parseMedicalRecordFromJson:jsonRespDic];
            completionHandler(medicalRecord);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncUploadPatient:(Patient *)patient withCompletionHandler:(void (^)(Patient *updatedPatient))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/my_patient/%ld", (long)patient.userID];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSNumber numberWithBool:patient.isBlocked] forKey:@"blocked"];
    [param setObject:[NSNumber numberWithBool:patient.isStarted] forKey:@"started"];
    if (patient.noteName && [patient.noteName length] > 0) {
        [param setObject:patient.noteName forKey:@"memo"];
    } else {
        [param setObject:@"" forKey:@"memo"];
    }
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:param httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            Patient *tmpPatient = [AccountManager parsePatientFromJson:jsonRespDic];
            completionHandler(tmpPatient);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncGetBlogsWithPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/blogs";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@(page) forKey:@"page"];
    [param setValue:@(size) forKey:@"size"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:param httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            NSArray *blogsDic = [jsonRespDic objectForKey:@"blogs"];
            NSMutableArray *blogs = [[NSMutableArray alloc] init];
            
            [blogsDic enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *blogDic = obj;
                BlogItem *blogItem = [AccountManager parseBlogItemFromJson:blogDic];
                
                [blogs addObject:blogItem];
            }];

            completionHandler(blogs);
            
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncGetBlogCommentsWithBlogId:(NSInteger)blogId withPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/blogs/%ld/comments", blogId];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@(page) forKey:@"page"];
    [param setValue:@(size) forKey:@"size"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:param httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            NSArray *commentsDic = [jsonRespDic objectForKey:@"comments"];
            NSMutableArray *comments = [[NSMutableArray alloc] init];
            
            [commentsDic enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *commentDic = obj;
                Comment *comment = [AccountManager parseCommentFromJson:commentDic];
                [comments addObject:comment];
            }];
            
            completionHandler(comments);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncSaveBlogCommentWithBlogId:(NSInteger)blogId withCommentDesc:(NSString *)commentDesc withCompletionHandler:(void (^)(Comment *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/blogs/%ld/comments", blogId];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:commentDesc forKey:@"description"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:param httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            Comment *comment = [AccountManager parseCommentFromJson:jsonRespDic];
            completionHandler(comment);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncDashInfoWithCompletionHandler:(void (^)(NSDictionary *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/dashboard";
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:nil httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            completionHandler(jsonRespDic);
        } else {
            
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncGetRegionWithRegionCode:(NSInteger)regionCode
               withCompletionHandler:(void (^)(RegionItem *regionItem))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/region/%ld", (long)regionCode];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            RegionItem *regionItem = [AccountManager parseRegionItemFromJson:jsonRespDic withRegionCode:regionCode];
            completionHandler(regionItem);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncRecharge:(long)money
    withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/account_money/%ld", (long)self.account.accountID];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithLong:money] forKey:@"money"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            self.account.money = [[jsonRespDic objectForKey:@"money"] longValue];
            self.account.balance = [[jsonRespDic objectForKey:@"balance"] longValue];
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncGetBalanceWithCompletionHandler:(void (^)(long balance))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/account_money/%ld", (long)self.account.accountID];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:nil httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            self.account.balance = [[jsonRespDic objectForKey:@"balance"] longValue];
            completionHandler(self.account.balance);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetWithdrawalParamWithCompletionHandler:(void (^)(WithdrawalParam *withdrawalParam))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/withdrawals";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            WithdrawalParam *theWithdrawalParam = [AccountManager parseWithdrawalParamFromJson:jsonRespDic];
            completionHandler(theWithdrawalParam);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncWithdrawal:(long)money withBankAccount:(NSString *)bankAccount
  withCompletionHandler:(void (^)(long balance))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/withdrawals";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithLong:money] forKey:@"money"];
    [paramDic setObject:bankAccount forKey:@"bank_account"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            self.account.balance = [[jsonRespDic objectForKey:@"balance"] longValue];
            completionHandler(self.account.balance);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncAddBankcard:(NSString *)bankcard withCardName:(NSString *)cardName withCardType:(NSString *)cardType withDefaultCard:(BOOL)isDefault
   withCompletionHandler:(void (^)(Bankcard *bankcard))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/bank_accounts";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:bankcard forKey:@"bank_account"];
    [paramDic setObject:cardName forKey:@"name"];
    [paramDic setObject:cardType forKey:@"type"];
    [paramDic setObject:[NSNumber numberWithBool:isDefault] forKey:@"is_default"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            Bankcard *bankcard = [AccountManager parseBankcardFromJson:jsonRespDic];
            completionHandler(bankcard);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetBankcardListWithCompletionHandler:(void (^)(NSArray *bankcardArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/bank_accounts";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *bankcardListArray = [[NSMutableArray alloc] init];
            NSArray *bankcards = [jsonRespDic objectForKey:@"bank_accounts"];
            for (NSDictionary *bankcardDic in bankcards) {
                Bankcard *bankcard = [AccountManager parseBankcardFromJson:bankcardDic];
                [bankcardListArray addObject:bankcard];
            }
            completionHandler(bankcardListArray);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncAcceptGift:(BOOL)isAccept withDealID:(NSInteger)dealID
  withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/flowers";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:dealID] forKey:@"id"];
    [paramDic setObject:[NSNumber numberWithBool:isAccept] forKey:@"accepted"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
            [[NSNotificationCenter defaultCenter] postNotificationName:kGiftInfoChanged object:nil];
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetGiftRecordWithCompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/flowers";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *giftArray = [[NSMutableArray alloc] init];
            NSArray *gifts = [jsonRespDic objectForKey:@"flowers"];
            for (NSDictionary *giftDic in gifts) {
                GiftItem *giftItem = [AccountManager parseGiftItemFromJson:giftDic];
                [giftArray addObject:giftItem];
            }
            completionHandler(giftArray);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}


- (void)asyncGetUserGiftRecordWithUserID:(NSInteger)userID withCompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/flowers/user/%ld", (long)userID];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *giftArray = [[NSMutableArray alloc] init];
            NSArray *gifts = [jsonRespDic objectForKey:@"flowers"];
            for (NSDictionary *giftDic in gifts) {
                GiftItem *giftItem = [AccountManager parseGiftItemFromJson:giftDic];
                [giftArray addObject:giftItem];
            }
            completionHandler(giftArray);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}



- (void)asyncGetPaymentsRecordWithPageIndex:(NSInteger)pageIndex size:(NSInteger)pageSize CompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/accounting_journals/%ld", (long)self.account.accountID];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(pageIndex), @"page",@(pageSize),@"size", nil];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *paymentsArray = [[NSMutableArray alloc] init];
            NSArray *payments = [jsonRespDic objectForKey:@"accounting_journals"];
            for (NSDictionary *paymentsDic in payments) {
                Payments *paymentsItem = [AccountManager parsePaymentsItemFromJson:paymentsDic];
                [paymentsArray addObject:paymentsItem];
            }
            completionHandler(paymentsArray);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetPaymentsRecordWithPageIndex:(NSInteger)pageIndex withCompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/accounting_journals/%ld/page/%ld", (long)self.account.accountID, pageIndex];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
       //  DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *paymentsArray = [[NSMutableArray alloc] init];
            NSArray *payments = [jsonRespDic objectForKey:@"accounting_journals"];
            for (NSDictionary *paymentsDic in payments) {
                Payments *paymentsItem = [AccountManager parsePaymentsItemFromJson:paymentsDic];
                [paymentsArray addObject:paymentsItem];
            }
            completionHandler(paymentsArray);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetPaymentsRecordWithPageIndex:(NSInteger)pageIndex withSize:(NSInteger)pageSize withCompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/accounting_journals/%ld/page/%ld/size/%ld", (long)self.account.accountID, pageIndex, pageSize];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *paymentsArray = [[NSMutableArray alloc] init];
            NSArray *payments = [jsonRespDic objectForKey:@"accounting_journals"];
            for (NSDictionary *paymentsDic in payments) {
                Payments *paymentsItem = [AccountManager parsePaymentsItemFromJson:paymentsDic];
                [paymentsArray addObject:paymentsItem];
            }
            completionHandler(paymentsArray);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetMyTemplatesWithCompletionHandler:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/templates";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            NSMutableArray *templates = [[NSMutableArray alloc] init];
            NSArray *templateDics = [jsonRespDic objectForKey:@"templates"];
            for (NSDictionary *templateDic in templateDics) {
                TemplateModel *template = [AccountManager parseTemplateModelFromJson:templateDic];
                [templates addObject:template];
            }
            
            completionHandler(templates);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncSaveTemplateWith:(TemplateModel *)templateModel CompletionHandler:(void (^)(TemplateModel *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/templates";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:templateModel.name forKey:@"name"];
    [paramDic setValue:@(templateModel.age) forKeyPath:@"age"];
    [paramDic setValue:@(templateModel.sex) forKeyPath:@"sex"];
    [paramDic setValue:@(templateModel.last_time) forKeyPath:@"last_time"];
    [paramDic setValue:@(templateModel.symptomDescription) forKeyPath:@"description"];
    [paramDic setValue:@(templateModel.images) forKeyPath:@"images"];
    [paramDic setValue:templateModel.fields forKeyPath:@"fields"];
//    [paramDic setValue:@(templateModel.category.categoryId) forKey:@"category_id"];
    
    NSLog(@"json is:%@", [paramDic JSONString]);
    
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            TemplateModel *templageModel = [AccountManager parseTemplateModelFromJson:jsonRespDic];
            
            completionHandler(templageModel);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
    
}

- (void)asyncGetTemplateCategoriesWithCompletionHandler:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/template_categories";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            NSMutableArray *categories = [[NSMutableArray alloc] init];
            NSArray *categoryDics = [jsonRespDic objectForKey:@"categories"];
            for (NSDictionary *categoryDic in categoryDics) {
                
                TemplateCategoryModel *templateCategoryModel = [AccountManager parseTemplateCategoryModelFromJson:categoryDic];
            
                [categories addObject:templateCategoryModel];
            }
            
            completionHandler(categories);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetStandardTemplatesWithTemplateCategoryId:(NSInteger)categoryId CompletionHandler:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/template_categories/%ld/templates", categoryId];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            NSMutableArray *templates = [[NSMutableArray alloc] init];
            NSArray *templateDics = [jsonRespDic objectForKey:@"templates"];
            for (NSDictionary *templateDic in templateDics) {
                TemplateModel *template = [AccountManager parseTemplateModelFromJson:templateDic];
                [templates addObject:template];
            }
            
            completionHandler(templates);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncUpdateTemplate:(TemplateModel *)templateModel CompletionHandler:(void (^)(TemplateModel *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/templates/%ld", templateModel.templateId];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:templateModel.name forKey:@"name"];
    [paramDic setValue:@(templateModel.age) forKeyPath:@"age"];
    [paramDic setValue:@(templateModel.sex) forKeyPath:@"sex"];
    [paramDic setValue:@(templateModel.last_time) forKeyPath:@"last_time"];
    [paramDic setValue:@(templateModel.symptomDescription) forKeyPath:@"description"];
    [paramDic setValue:@(templateModel.images) forKeyPath:@"images"];
    [paramDic setValue:templateModel.fields forKeyPath:@"fields"];
//    [paramDic setValue:@(templateModel.category.categoryId) forKey:@"category_id"];
    
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            TemplateModel *templageModel = [AccountManager parseTemplateModelFromJson:jsonRespDic];
            
            completionHandler(templageModel);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}


- (void)asyncGetHospitalListWithRegionCode:(NSInteger)regionCode
                     withCompletionHandler:(void (^)(NSArray *hospitalListArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/hospitals/region/%ld", (long)regionCode];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *hospitalArray = [[NSMutableArray alloc] init];
            NSArray *hospitals = [jsonRespDic objectForKey:@"hospitals"];
            for (NSDictionary *hospitalItemRespDic in hospitals) {
                [hospitalArray addObject:[AccountManager parseHospitalItemFromJson:hospitalItemRespDic]];
            }
            completionHandler(hospitalArray);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetHospitalWithHospitalID:(NSInteger)hospitalID
                 withCompletionHandler:(void (^)(HospitalItem *hospital))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/hospital/%ld", (long)hospitalID];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            HospitalItem *hospital = [[HospitalItem alloc] init];
            completionHandler(hospital);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
       //  DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetScoreListWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize CompletionHandler:(void (^)(NSArray *scoreModels))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/doctors/score";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(pageIndex),@"page", @(pageSize), @"size",nil];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
       //  DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *scoreModels = [[NSMutableArray alloc] init];
            
            NSArray *scoreDics = [jsonRespDic objectForKey:@"scores"];
            for (NSDictionary *scoreDic in scoreDics) {
                
                ScoreModel *scoreModel = [AccountManager parseScoreModelFromJson:scoreDic];
                [scoreModels addObject:scoreModel];
            }
            completionHandler(scoreModels);
        } else {
            
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetGoodsListWithCompletionHandler:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/score_gifts";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSMutableArray *goodsModels = [[NSMutableArray alloc] init];
            
            NSArray *goodsDics = [jsonRespDic objectForKey:@"score_gifts"];
            for (NSDictionary *goodDic in goodsDics) {
                
                GoodsModel *goodsModel = [AccountManager parseGoodsModelFromJson:goodDic];
                [goodsModels addObject:goodsModel];
            }
            completionHandler(goodsModels);
        } else {
            
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncExchangeGoodsWithGoodsId:(NSInteger)goodsId withCompletionHandler:(void (^)(NSInteger))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/score_gifts/%ld/actions/exchange", (long)goodsId];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            NSInteger remainScore = [[ManagerUtil filterObject:[jsonRespDic objectForKey:@"remain_score"]] integerValue];
//            NSString *description = [ManagerUtil filterObject:[jsonRespDic objectForKey:@"decsription"]];
            
            completionHandler(remainScore);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncExchangeMoney:(NSInteger)money withCompletionHandler:(void (^)(Account *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler {
    
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/score_gifts/%ld/actions/exchange_balance", (long)money];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            
            NSInteger remainScore = [[ManagerUtil filterObject:[jsonRespDic objectForKey:@"remain_score"]] integerValue];
            NSInteger remainBalance = [[ManagerUtil filterObject:[jsonRespDic objectForKey:@"balance"]] integerValue];
            //            NSString *description = [ManagerUtil filterObject:[jsonRespDic objectForKey:@"decsription"]];
            
            self.account.score = remainScore;
            self.account.balance = remainBalance;
            
            completionHandler(self.account);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}


- (void)asyncUploadImage:(UIImage *)image
   withCompletionHandler:(void (^)(ImageHandle *imageHandle))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/images";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0f);
    [paramDic setValue:[imageData base64Encoding] forKey:@"image"];
    [paramDic setValue:@"image/jpeg" forKey:@"mimetype"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST"];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            ImageHandle *imageHandleResult = [AccountManager parseImageHandleFromJson:jsonRespDic];
            completionHandler(imageHandleResult);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncDownloadImage:(NSString *)imagePath
     withCompletionHandler:(void (^)(UIImage *image))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    if (!imagePath || [imagePath isKindOfClass:[NSNull class]] || [imagePath length] == 0) {
        return ;
    }
    
    NSString *urlPath = [ NSString stringWithFormat:@"/upload/%@", [imagePath lastPathComponent]];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET"];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        completionHandler(operation.responseImage);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncDownloadImageWithURLString:(NSString *)imageURLString
                  withCompletionHandler:(void (^)(UIImage *image))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    if (!imageURLString || [imageURLString isKindOfClass:[NSNull class]] || [imageURLString length] == 0) {
        return ;
    }
    
    MKNetworkOperation *op = [self.networkEngine operationWithURLString:imageURLString];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        completionHandler(operation.responseImage);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
       //  DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncDownThumbnailImageWithURLString:(NSString *)imageURLString
          withCompletionHandler:(void (^)(UIImage *image))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    if (!imageURLString || [imageURLString isKindOfClass:[NSNull class]] || [imageURLString length] == 0) {
        return ;
    }
    
    // http://img.ihaoyisheng.com/1b605ecb3b3d21a4fa45ba7ea709c306.jpeg@128w_128h.jpg
    // http://img.ihaoyisheng.com/1b605ecb3b3d21a4fa45ba7ea709c306.jpeg@!thumbnail
    NSString *urlPath = [ NSString stringWithFormat:@"%@@64w_64h.jpg", imageURLString];
    MKNetworkOperation *op = [self.networkEngine operationWithURLString:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        completionHandler(operation.responseImage);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}


#pragma mark - Quick Question

- (void)asyncAddComment:(NSString *)commentText withQuestionID:(NSInteger)quectionID
  withCompletionHandler:(void (^)(Comment *comment))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/quickly_asks/%ld/comments", (long)quectionID];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:commentText forKey:@"description"];
    
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST"];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            Comment *commentItem = [AccountManager parseCommentFromJson:jsonRespDic];
            completionHandler(commentItem);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetQuickQuestionListWithPage:(NSInteger)page size:(NSInteger)size department:(NSString *)department CompletionHandler:(void (^)(NSArray *quickQuestionList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSInteger regionID = self.account.region.code;
    NSString *urlPath = [NSString stringWithFormat:@"/api/v3/regions/%ld/quickly_asks", (long)regionID];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:@(page) forKey:@"page"];
    [paramDic setValue:@(size) forKey:@"size"];
    if (department) {
        [paramDic setValue:department forKey:@"department"];
    }
    
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSArray *responseList = [jsonRespDic objectForKey:@"quickly_asks"];
            NSMutableArray *list = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDic in responseList) {
                QuickQuestion *question = [AccountManager parseQuickQuestionFromJson:itemDic];
                [list addObject:question];
            }
            completionHandler(list);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncGetMyRepliedQuickQuestionListWithPage:(NSInteger)page size:(NSInteger)size department:(NSString *)department CompletionHandler:(void (^)(NSArray *quickQuestionList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }

    NSString *urlPath = @"/api/v3/quickly_asks";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:@(page) forKey:@"page"];
    [paramDic setValue:@(size) forKey:@"size"];
    if (department) {
        [paramDic setValue:department forKey:@"department"];
    }
    
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if  (0 == statusCode) {
            NSArray *responseList = [jsonRespDic objectForKey:@"quickly_asks"];
            NSMutableArray *list = [[NSMutableArray alloc] init];
            
            for (NSDictionary *itemDic in responseList) {
                QuickQuestion *question = [AccountManager parseQuickQuestionFromJson:itemDic];
                [list addObject:question];
            }
            completionHandler(list);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}



#pragma mark - UrgentCall

- (void)asyncGetUrgentCallListWithCompletionHandler:(void (^)(NSArray *urgentCallList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = @"/api/urgency_calls";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSArray *responseList = [jsonRespDic objectForKey:@"urgency_calls"];
            NSMutableArray *list = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDic in responseList) {
                UrgentCallInfo *callInfo = [AccountManager parseUrgentCallInfoFromJson:itemDic];
                [list addObject:callInfo];
            }
            completionHandler(list);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncAcceptUrgentCall:(NSInteger)callID withCompletionHandler:(void (^)(UrgentCallInfo *urgentCallInfo))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/urgency_calls/%ld", (long)callID];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            UrgentCallInfo *info = [AccountManager parseUrgentCallInfoFromJson:jsonRespDic];
            completionHandler(info);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

- (void)asyncCallPatientWithUserID:(NSInteger)userID withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/my_patients/%ld/call", (long)userID];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST"];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            completionHandler(YES);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
       // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}


#pragma mark - FollowUp

- (void)asyncGetFollowUpReportListWithType:(NSString *)type
                     withCompletionHandler:(void (^)(NSArray *reportList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/follow_ups?follow_up_type=%@", type];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"GET" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            NSArray *responseList = [jsonRespDic objectForKey:@"follow_ups"];
            NSMutableArray *list = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDic in responseList) {
                FollowUpReport *reports = [AccountManager parseFollowUpReportFromJson:itemDic];
                [list addObject:reports];
            }
            completionHandler(list);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
       // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

- (void)asyncReceiveFollowUpItemWithItemID:(NSInteger)itemID
                     withCompletionHandler:(void (^)(FollowUpItem *followUpItem))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    if (![self isNetworkReachableWithErrorHandler:errorHandler]) {
        return ;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/follow_up_items/%ld", (long)itemID];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"PUT" ssl:NO];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        // DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            FollowUpItem *item = [AccountManager parseFollowUpItemFromJson:jsonRespDic];
            completionHandler(item);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        // DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];

}

@end
