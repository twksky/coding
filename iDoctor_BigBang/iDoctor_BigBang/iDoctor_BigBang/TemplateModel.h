//
//  TemplateModel.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateModel : NSObject
@property (nonatomic, assign) NSInteger templateId;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL last_time;
@property (nonatomic, assign) BOOL age;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, assign) BOOL symptomDescription;
@property (nonatomic, assign) BOOL images;
@property (nonatomic, strong) NSArray *fields;
@end
