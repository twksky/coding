//
//  IDPartView.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDPartView : UIView

// 下面的文字
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithName:(NSString *)name;

- (void)changeColorAndTextColor;

@end
