//
//  IDExchangeSuccessView.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/5.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDExchangeSuccessView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id delegateVC;

- (instancetype)initWithImageName:(NSString *)imageName;


@end
