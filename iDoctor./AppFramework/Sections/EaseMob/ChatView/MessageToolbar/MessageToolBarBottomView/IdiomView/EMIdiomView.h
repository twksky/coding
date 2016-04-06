//
//  EMIdiomView.h
//  AppFramework
//
//  Created by ABC on 7/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMIdiomView;

@protocol EMIdiomViewDelegate <NSObject>

- (void)idiomView:(EMIdiomView *)idiomView didSelectIdiom:(NSString *)idiomText;

@end

@interface EMIdiomView : UIView

@property (nonatomic, weak) id<EMIdiomViewDelegate> delegate;

@end
