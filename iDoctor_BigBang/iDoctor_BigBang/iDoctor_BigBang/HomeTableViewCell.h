//
//  HomeTableViewCell.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/15.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
