//
//  ChatSendHelper.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "ChatSendHelper.h"
#import "ConvertToCommonEmoticonsHelper.h"

#define kRecentlyContactChangedNotification     @"14C2E8A3-74C2-4480-AB43-B3B5B5416C77"

@interface ChatImageOptions : NSObject<IChatImageOptions>

@property (assign, nonatomic) CGFloat compressionQuality;

@end

@implementation ChatImageOptions

@end

@implementation ChatSendHelper

+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
{
    // 表情映射。
    NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:str];
    EMChatText *text = [[EMChatText alloc] initWithText:willSendText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
}

+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
{
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image.jpg"];
    id <IChatImageOptions> options = [[ChatImageOptions alloc] init];
    [options setCompressionQuality:0.6];
    [chatImage setImageOptions:options];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
}

//+(EMMessage *)sendVoice:(EMChatVoice *)voice
//             toUsername:(NSString *)username
//            isChatGroup:(BOOL)isChatGroup
//      requireEncryption:(BOOL)requireEncryption
//{
//    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
//    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
//}

//+(EMMessage *)sendVideo:(EMChatVideo *)video
//             toUsername:(NSString *)username
//            isChatGroup:(BOOL)isChatGroup
//      requireEncryption:(BOOL)requireEncryption
//{
//    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithChatObject:video];
//    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
//}

//+(EMMessage *)sendLocationLatitude:(double)latitude
//                         longitude:(double)longitude
//                           address:(NSString *)address
//                        toUsername:(NSString *)username
//                       isChatGroup:(BOOL)isChatGroup
//                 requireEncryption:(BOOL)requireEncryption
//{
//    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude longitude:longitude address:address];
//    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
//    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption];
//}

// 发送消息
+(EMMessage *)sendMessage:(NSString *)username
              messageBody:(id<IEMMessageBody>)body
              isChatGroup:(BOOL)isChatGroup
        requireEncryption:(BOOL)requireEncryption
{
    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:username bodies:[NSArray arrayWithObject:body]];
    retureMsg.requireEncryption = requireEncryption;
//    retureMsg.isGroup = isChatGroup;
    
    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:retureMsg progress:nil];
    
    return message;
}


#pragma mark - iDoctor客户端扩展消息

+ (EMMessage *)sendCustomTextMessageWithString:(NSString *)str toUsername:(NSString *)username
{
    EMChatText *userObject = [[EMChatText alloc] initWithText:str];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:userObject];
    EMMessage *msg = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    
    NSMutableDictionary *vcardProperty = [NSMutableDictionary dictionary];
    // obj:需要发送object   objKey:obj对应的key
   	[vcardProperty setObject:[NSNumber numberWithInteger:0] forKey:@"type"];        // 0:文本
    msg.ext = vcardProperty;
    // 发送消息
    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
    return message;
}

+ (EMMessage *)sendCustomMedicalRecordWithString:(NSString *)str toUsername:(NSString *)username
{
    EMChatText *userObject = [[EMChatText alloc] initWithText:str];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:userObject];
    EMMessage *msg = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    
    NSMutableDictionary *vcardProperty = [NSMutableDictionary dictionary];
    // obj:需要发送object   objKey:obj对应的key
   	[vcardProperty setObject:[NSNumber numberWithInteger:1] forKey:@"type"];        // 1:病例
    msg.ext = vcardProperty;
    // 发送消息
    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
    return message;
}

//+ (EMMessage *)sendCustomHandselFlowerWithString:(NSString *)str withFlowerNumber:(NSInteger)number withDealID:(NSInteger)dealID toUsername:(NSString *)username
//{
//    EMChatText *userObject = [[EMChatText alloc] initWithText:str];
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:userObject];
//    EMMessage *msg = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
//    
//    NSMutableDictionary *vcardProperty = [NSMutableDictionary dictionary];
//    // obj:需要发送object   objKey:obj对应的key
//   	[vcardProperty setObject:[NSNumber numberWithInteger:2] forKey:@"type"];        // 2:送花
//    [vcardProperty setObject:[NSNumber numberWithInteger:number] forKey:@"nums"];
//    [vcardProperty setObject:[NSNumber numberWithInteger:dealID] forKey:@"flower_id"];
//    [vcardProperty setObject:str forKey:@"message"];
//    msg.ext = vcardProperty;
//    // 发送消息
//    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
//    return message;
//}

//+ (EMMessage *)sendCustomAcceptFlowerWithString:(NSString *)str toUsername:(NSString *)username
//{
//    EMChatText *userObject = [[EMChatText alloc] initWithText:str];
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:userObject];
//    EMMessage *msg = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
//    
//    NSMutableDictionary *vcardProperty = [NSMutableDictionary dictionary];
//    // obj:需要发送object   objKey:obj对应的key
//   	[vcardProperty setObject:[NSNumber numberWithInteger:3] forKey:@"type"];        // 3:接受花
//    msg.ext = vcardProperty;
//    // 发送消息
//    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
//    return message;
//}

//+ (EMMessage *)sendCustomRefuseFlowerWithString:(NSString *)str toUsername:(NSString *)username
//{
//    EMChatText *userObject = [[EMChatText alloc] initWithText:str];
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:userObject];
//    EMMessage *msg = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
//    
//    NSMutableDictionary *vcardProperty = [NSMutableDictionary dictionary];
//    // obj:需要发送object   objKey:obj对应的key
//   	[vcardProperty setObject:[NSNumber numberWithInteger:3] forKey:@"type"];        // 4:拒绝花
//    msg.ext = vcardProperty;
//    // 发送消息
//    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
//    return message;
//}

@end

