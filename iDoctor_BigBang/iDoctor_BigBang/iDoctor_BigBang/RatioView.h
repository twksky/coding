//
//  RatioView.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/7/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseBtnClickBlock)(NSInteger recruitId);
@class RecruitDetail;
@interface RatioView : UIView

@property(nonatomic, copy)CloseBtnClickBlock closeBtnClickBlock;
- (void)setDataWithRecruitDetail:(RecruitDetail *)recruitDetail;

-(void)setCloseBtnClickBlock:(CloseBtnClickBlock)closeBtnClickBlock;
@end
