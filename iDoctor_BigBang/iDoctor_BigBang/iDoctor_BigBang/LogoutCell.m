//
//  LogoutCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "LogoutCell.h"
#import "LogoutModel.h"
@interface LogoutCell ()
@property(nonatomic, strong) UIButton *logoutBtn;
@end

@implementation LogoutCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    LogoutModel *logout = (LogoutModel *)model;
    [self.logoutBtn setTitle:logout.title forState:UIControlStateNormal];
    [self.logoutBtn setImage:logout.icon forState:UIControlStateNormal];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"LogoutCell";
    LogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[LogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self setUpAllViews];
    }
    return self;
}
- (void)setUpAllViews
{
    [self.contentView addSubview:self.logoutBtn];
    [self.logoutBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
    }];
}

- (UIButton *)logoutBtn
{
    if (_logoutBtn == nil) {
        _logoutBtn = [[UIButton alloc] init];
//        _logoutBtn.backgroundColor = GDRandomColor;
//        _logoutBtn.tintColor = UIColorFromRGB(0x353d3f);
        [_logoutBtn setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
        _logoutBtn.userInteractionEnabled = NO;
        _logoutBtn.titleLabel.font = GDFont(15);
        _logoutBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    }
    return _logoutBtn;
}

@end
