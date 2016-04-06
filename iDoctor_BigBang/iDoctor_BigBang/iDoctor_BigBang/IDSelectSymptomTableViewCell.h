//
//  IDSelectSymptomTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/13.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDDoctorIsGoodAtDiseaseModel;

@protocol IDSelectSymptomTableViewCellDelegate <NSObject>

- (void)deleteButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexPath;

@end


@interface IDSelectSymptomTableViewCell : UITableViewCell

+ (IDSelectSymptomTableViewCell *)cellWithTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexpath;

- (void)createCellWithModel:(IDDoctorIsGoodAtDiseaseModel *)model indexPath:(NSIndexPath *)indexPath;


@property (nonatomic, assign) id<IDSelectSymptomTableViewCellDelegate> delegate;


@end
