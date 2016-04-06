//
//  IDPatientCaseCommentTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IDPatientMedicalsModel,IDPatientMedicalsCommentsModel;
@interface IDPatientCaseCommentTableViewCell : UITableViewCell

// 评论
- (void)dataCellCommentWithModel:(IDPatientMedicalsModel *)model row:(NSInteger)row;

// 评论
- (void)dataCellCommentWithModel:(IDPatientMedicalsCommentsModel *)model;

@end
