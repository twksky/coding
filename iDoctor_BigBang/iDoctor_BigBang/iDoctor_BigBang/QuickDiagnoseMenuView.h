//
//  QuickDiagnoseMenuView.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/11/2.
//  Copyright © 2015年 YDHL. All rights reserved.
//

@protocol QuickDiagnoseMenuViewDelegate <NSObject>

@required
- (void)didSelectLocation:(NSInteger)regionId;
- (void)didSelectDepartment:(NSString *)department;
- (void)didShowMenuView;
- (void)didHideMenuView;

@end

@interface QuickDiagnoseMenuView : UIView

@property (nonatomic, weak) id<QuickDiagnoseMenuViewDelegate> delegate;

@end
