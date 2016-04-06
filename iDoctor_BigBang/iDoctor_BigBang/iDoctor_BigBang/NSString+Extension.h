//
//  NSString+Extension.h
//  GoodDoctor
//
//  Created by hexy on 15/7/5.
//  Copyright (c) 2015年 hexy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
#pragma mark - 散列函数
/**
 *  计算MD5散列结果
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)md5String;

/**
 *  计算SHA1散列结果
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)sha1String;

/**
 *  计算SHA256散列结果
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)sha256String;

/**
 *  计算SHA 512散列结果
 *  @return 128个字符的SHA 512散列字符串
 */
- (NSString *)sha512String;

#pragma mark - HMAC 散列函数
/**
 *  计算HMAC MD5散列结果 
 *  @return 32个字符的HMAC MD5散列字符串
 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA1散列结果
 *  @return 40个字符的HMAC SHA1散列字符串
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA256散列结果
 *  @return 64个字符的HMAC SHA256散列字符串
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA512散列结果
 *  @return 128个字符的HMAC SHA512散列字符串
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

#pragma mark - 文件散列函数

/**
 *  计算文件的MD5散列结果
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)fileMD5Hash;

/**
 *  计算文件的SHA1散列结果
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)fileSHA1Hash;

/**
 *  计算文件的SHA256散列结果
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)fileSHA256Hash;
/**
 *  计算文件的SHA512散列结果
 *  @return 128个字符的SHA512散列字符串
 */
- (NSString *)fileSHA512Hash;
/**
 返回base64编码的字符串内容
 */
- (NSString *)base64encode;

/**
 返回base64解码的字符串内容
 */
- (NSString *)base64decode;
/**
 *  返回服务器基本授权字符串
 *   @code
 *   [request setValue:[@"admin:123456" basicAuthString] forHTTPHeaderField:@"Authorization"];
 *   @endcode
 *  @return
 */
- (NSString *)basicAuthString;

@end
