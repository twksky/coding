//
//  SectionModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject

@property(nonatomic, strong) NSArray *rowModels;

+ (instancetype)sectionModelWithRowModelArray:(NSArray *)rowModelArray;
@end
