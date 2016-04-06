//
//  MasterDiagnoseDetailCell.m
//  iDoctor_BigBang
//
//  Created by tianxiewuhua on 15/10/28.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "MasterDiagnoseDetailCell.h"
#import "MasterDiagnose.h"

@interface MasterDiagnoseDetailCell ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *noteDetailLabel;

@end

@implementation MasterDiagnoseDetailCell

- (void)setupView {
    [super setupView];
    
    UIView *contentView = self;
    
    [contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(contentView);
        make.top.equalTo(self.imagesCollectionView.bottom);
        make.height.equalTo(0.7f);
    }];
    
    [contentView addSubview:self.noteDetailLabel];
    [self.noteDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line.bottom).with.offset(15.0f);
        make.left.equalTo(contentView).with.offset(15.0f);
        make.right.equalTo(contentView).with.offset(-15.0f);
    }];
}

#pragma mark - cellHeight
+ (CGFloat)cellHeightWithMasterDiagnose:(MasterDiagnose *)masterDiagnose {
    CGFloat superHeight = [[super class] cellHeightWithQuickDiagnose:masterDiagnose];
    CGFloat finalHeight = superHeight + [[super class] textHeightWithContent:masterDiagnose.ask_for_consultation_remark] + 20.0f;
    
    return finalHeight;
}

#pragma mark - loadData
- (void)loadDataWithMasterDiagnose:(MasterDiagnose *)masterDiagnose {
    [super loadData:masterDiagnose imageBlock:^(NSString *image_url) {
        
    }];
    
    self.noteDetailLabel.text = masterDiagnose.ask_for_consultation_remark;
}

#pragma mark - Properties
- (UILabel *)noteDetailLabel {
    
	if(_noteDetailLabel == nil) {
        
		_noteDetailLabel = [[UILabel alloc] init];
        _noteDetailLabel.font = [UIFont systemFontOfSize:13.0f];
        _noteDetailLabel.textColor = UIColorFromRGB(0x91b8b9);
	}
	return _noteDetailLabel;
}

- (UIView *)line {
    
	if(_line == nil) {
        
		_line = [[UIView alloc] init];
        _line.backgroundColor = UIColorFromRGB(0xbfbfbf);
	}
	return _line;
}

@end
