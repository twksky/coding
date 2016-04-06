//
//  IDpatientMsgTopTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//


// 患者病例顶部的cell
#import "IDpatientMsgTopTableViewCell.h"
#import "IDGetPatientInformation.h"

@interface IDpatientMsgTopTableViewCell()

// 左边的label
@property (nonatomic, strong) UILabel *leftLabel;

// 右边的label
@property (nonatomic, strong) UILabel *rightLabel;

@end


@implementation IDpatientMsgTopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    
    return self;
}

// 创建相应的UI
- (void)setupUI
{
    // sleep(50);
    // 左边的label
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(18);
        
    }];
    
    // 中间的分割线
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftLabel.right).with.offset(18);
        make.top.equalTo(self.contentView).with.offset(18);
        make.size.equalTo(CGSizeMake(1, 16));
        
    }];
    
    // 右边的label
    [self.contentView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(segment.right).with.offset(18);
        make.top.equalTo(self.contentView).with.offset(18);
        
    }];

}

+ (IDpatientMsgTopTableViewCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ident = @"patientMsgTopTableViewCell";
    
    IDpatientMsgTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        
        cell = [[IDpatientMsgTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
    }
    
    return cell;
    
}


- (void)dataWithName:(NSString *)name patientInfo:(IDGetPatientInformation *)patientInfo IndexPath:(NSIndexPath *)indexPath;
{
    self.leftLabel.text = name;
    
    NSString *string = nil;
    
    switch (indexPath.row) {
        case 0:{
            string = patientInfo.realname;
        
        }break;
        case 1:{
            string = patientInfo.sex;
            
        }break;
        case 2:{

            NSArray *array = [patientInfo.birth componentsSeparatedByString:@"-"];
            if (array.count != 3) {
                
                string = @"1991年1月1号";
            } else {
            
                string =[NSString stringWithFormat:@"%@年%@月%@日",array[0],array[1],array[2]];
            }
  
        }break;
        case 3:{
            
            string = [NSString stringWithFormat:@"%ldCM",(long)patientInfo.height];
            
        }break;
        case 4:{
            string = [NSString stringWithFormat:@"%ldKG",(long)patientInfo.weight];
            
        }break;
        default:
            break;
    }
    
    self.rightLabel.text = string;
    
}



#pragma mark - 懒加载
- (UILabel *)leftLabel
{
    if (_leftLabel == nil) {
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:15.0f];
        _leftLabel.textColor = UIColorFromRGB(0x353d3f);

    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:15.0f];
        _rightLabel.textColor = UIColorFromRGB(0xa8a8aa);
    }
    
    return _rightLabel;
}


@end
