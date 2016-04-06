//
//  IDpatientCaseTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDMedicaledModel;
@interface IDpatientCaseTableViewCell : UITableViewCell

- (void)getCellWithModel:(IDMedicaledModel *)model;

@end
