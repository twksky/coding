//
//  ConvertToCommonEmoticonsHelper.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertToCommonEmoticonsHelper : NSObject
+ (NSString *)convertToCommonEmoticons:(NSString *)text;
+ (NSString *)convertToSystemEmoticons:(NSString *)text;
@end
