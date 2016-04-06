//
//  DXChatBarMoreView.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;//照片
@property (nonatomic, strong) UIButton *takePhotoButton;//拍照
@property (nonatomic, strong) UIButton *mTemplateButton;//模板
//@property (nonatomic, strong) UIButton *addTemplateButton;//添加模板
//@property (nonatomic, strong) UIButton *quickAnswerButton;//快速提问
//@property (nonatomic, strong) UIButton *addAnswerButton;//回复

//@property (nonatomic, strong) UIButton *locationButton;//位置信息
//@property (nonatomic, strong) UIButton *videoButton;//音频

- (void)setupSubviews;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>

@required
//- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView;//照片
- (void)moreViewTakePhotoAction:(DXChatBarMoreView *)moreView;//拍照
- (void)moreViewMyTemplateAction:(DXChatBarMoreView *)moreView;//模板
//- (void)moreViewAddTemplateAction:(DXChatBarMoreView *)moreView;
//- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView;
//- (void)moreViewVideoAction:(DXChatBarMoreView *)moreView;

@end
