//
//  EaseStartView.h
//  EaseStartView
//
//  Created by twksky on 15/11/4.
//  Copyright © 2015年 twksky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseStartView : UIView

+ (instancetype)startView;

- (void)startAnimationWithCompletionBlock:(void(^)(EaseStartView *easeStartView))completonHandler;


@end
