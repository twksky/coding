/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 60
#define INSETS 8

@implementation DXChatBarMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    NSInteger buttonIndex = 0;
    
    UIView *containerPhotoView = [[UIView alloc] initWithFrame:CGRectMake(insets * (buttonIndex + 1) + CHAT_BUTTON_SIZE * buttonIndex, 10, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE + 30.0f)];
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(0, 0, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_more_photo2"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_more_photo2Selected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *photoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 30.0f)];
    photoTitle.text = @"图片";
    photoTitle.textColor = UIColorFromRGB(0xc8c8cd);
    photoTitle.textAlignment = NSTextAlignmentCenter;
    photoTitle.font = [UIFont systemFontOfSize:14.0f];
    
    [containerPhotoView addSubview:_photoButton];
    [containerPhotoView addSubview:photoTitle];
    [self addSubview:containerPhotoView];
    buttonIndex++;

    //[_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
    //[_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
//    [_photoButton setImage:[UIImage imageNamed:@"chatBar_more_photo2"] forState:UIControlStateNormal];
//    [_photoButton setImage:[UIImage imageNamed:@"chatBar_more_photo2Selected"] forState:UIControlStateHighlighted];
//    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_photoButton];
//    buttonIndex++;
    /*
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(insets * (buttonIndex + 1) + CHAT_BUTTON_SIZE * buttonIndex, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationButton];
    buttonIndex++;
    */
    
    UIView *containerMyTemplateView = [[UIView alloc] initWithFrame:CGRectMake(insets * (buttonIndex + 1) + CHAT_BUTTON_SIZE * buttonIndex, 10, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE + 30.0f)];
    
    _mTemplateButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_mTemplateButton setFrame:CGRectMake(0, 0, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    //[_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
    //[_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_mTemplateButton setImage:[UIImage imageNamed:@"chatBar_mTemplate"] forState:UIControlStateNormal];
    [_mTemplateButton setImage:[UIImage imageNamed:@"chatBar_mTemplateSelected"] forState:UIControlStateHighlighted];
    [_mTemplateButton addTarget:self action:@selector(myTemplateAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *mTemplateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 30.0f)];
    mTemplateTitle.text = @"模板";
    mTemplateTitle.textColor = UIColorFromRGB(0xc8c8cd);
    mTemplateTitle.textAlignment = NSTextAlignmentCenter;
    mTemplateTitle.font = [UIFont systemFontOfSize:14.0f];
    
    [containerMyTemplateView addSubview:_mTemplateButton];
    [containerMyTemplateView addSubview:mTemplateTitle];
    [self addSubview:containerMyTemplateView];
    buttonIndex++;
    /*
    _videoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_videoButton setFrame:CGRectMake(insets * (buttonIndex + 1) + CHAT_BUTTON_SIZE * buttonIndex, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_videoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_video"] forState:UIControlStateNormal];
    [_videoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoSelected"] forState:UIControlStateHighlighted];
    [_videoButton addTarget:self action:@selector(takeVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_videoButton];
     */
    
//    UIView *containerAddTemplateView = [[UIView alloc] initWithFrame:CGRectMake(insets * (buttonIndex + 1) + CHAT_BUTTON_SIZE * buttonIndex, 10, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE + 30.0f)];
//    
//    _addTemplateButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_addTemplateButton setFrame:CGRectMake(0, 0, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_addTemplateButton setImage:[UIImage imageNamed:@"chatBar_addTemplate"] forState:UIControlStateNormal];
//    [_addTemplateButton setImage:[UIImage imageNamed:@"chatBar_addTemplateSelected"] forState:UIControlStateHighlighted];
//    [_addTemplateButton addTarget:self action:@selector(addTemplateAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *addTemplateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 30.0f)];
//    addTemplateTitle.text = @"新增模板";
//    addTemplateTitle.textColor = UIColorFromRGB(0xc8c8cd);
//    addTemplateTitle.textAlignment = NSTextAlignmentCenter;
//    addTemplateTitle.font = [UIFont systemFontOfSize:14.0f];
//    
//    [containerAddTemplateView addSubview:_addTemplateButton];
//    [containerAddTemplateView addSubview:addTemplateTitle];
//    [self addSubview:containerAddTemplateView];
//    buttonIndex++;
    
//    UIView *containerQuickAnswerView = [[UIView alloc] initWithFrame:CGRectMake(insets * (buttonIndex + 1) + CHAT_BUTTON_SIZE * buttonIndex, 10, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE + 30.0f)];
//    
//    _quickAnswerButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_quickAnswerButton setFrame:CGRectMake(0, 0, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_quickAnswerButton setImage:[UIImage imageNamed:@"chatBar_quickAnswer"] forState:UIControlStateNormal];
//    [_quickAnswerButton setImage:[UIImage imageNamed:@"chatBar_quickAnswerSelected"] forState:UIControlStateHighlighted];
//    [_quickAnswerButton addTarget:self action:@selector(quickAnswerAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *quickAnswerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 30.0f)];
//    quickAnswerTitle.text = @"快速回答";
//    quickAnswerTitle.textColor = UIColorFromRGB(0xc8c8cd);
//    quickAnswerTitle.textAlignment = NSTextAlignmentCenter;
//    quickAnswerTitle.font = [UIFont systemFontOfSize:14.0f];
//    
//    [containerQuickAnswerView addSubview:_quickAnswerButton];
//    [containerQuickAnswerView addSubview:quickAnswerTitle];
//    [self addSubview:containerQuickAnswerView];
//    buttonIndex++;
    
//    UIView *containerAddAnswerView = [[UIView alloc] initWithFrame:CGRectMake(insets, 110, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE + 30.0f)];
//    
//    _addAnswerButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_addAnswerButton setFrame:CGRectMake(0, 0, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_addAnswerButton setImage:[UIImage imageNamed:@"chatBar_addAnswer"] forState:UIControlStateNormal];
//    [_addAnswerButton setImage:[UIImage imageNamed:@"chatBar_addAnswerSelected"] forState:UIControlStateHighlighted];
//    [_addAnswerButton addTarget:self action:@selector(addAnswerAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *addAnswerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE, 30.0f)];
//    addAnswerTitle.text = @"新增回答";
//    addAnswerTitle.textColor = UIColorFromRGB(0xc8c8cd);
//    addAnswerTitle.textAlignment = NSTextAlignmentCenter;
//    addAnswerTitle.font = [UIFont systemFontOfSize:14.0f];
//    
//    [containerAddAnswerView addSubview:_addAnswerButton];
//    [containerAddAnswerView addSubview:addAnswerTitle];
//    [self addSubview:containerAddAnswerView];
//    buttonIndex++;
}

#pragma mark - action

- (void)myTemplateAction{
    
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewMyTemplateAction:)]){
        [_delegate moreViewMyTemplateAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)addTemplateAction {
    
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewAddTemplateAction:)]){
        [_delegate moreViewAddTemplateAction:self];
    }
}

- (void)quickAnswerAction {
    
    //TODO 快速回答
}

- (void)addAnswerAction {
    
    //TODO 新增回答
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeVideoAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewVideoAction:self];
    }
}

@end
