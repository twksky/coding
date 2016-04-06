//
//  SectionModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "SectionModel.h"

@implementation SectionModel

+ (instancetype)sectionModelWithRowModelArray:(NSArray *)rowModelArray
{
    SectionModel *section = [[self alloc] init];
    section.rowModels = rowModelArray;
    return section;
}
@end
