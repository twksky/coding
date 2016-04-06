//
//  IDSymptomSearchTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/13.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDDoctorIsGoodAtDiseaseModel;
@protocol IDSymptomSearchTableViewCellDelegate <NSObject>

- (void)addButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexPath;

@end


@interface IDSymptomSearchTableViewCell : UITableViewCell

@property (nonatomic, assign) id<IDSymptomSearchTableViewCellDelegate> delegate;

/**
 *  通过相应的Model 创建  相应的Cell
 *
 *  @param model
 *  @param indexPath
 */
- (void)createCellWithModel:(IDDoctorIsGoodAtDiseaseModel *)model indexPath:(NSIndexPath *)indexPath;


@end
