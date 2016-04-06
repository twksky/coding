//
//  DXMessageToolBar.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "DXMessageToolBar.h"

@interface DXMessageToolBar()<UITextViewDelegate
, DXFaceDelegate//, EMIdiomViewDelegate
>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (nonatomic) CGFloat version;

/**
 *  背景
 */
//@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
//@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  按钮、输入框、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;
//@property (strong, nonatomic) UIButton *styleChangeButton;//最左边的录音和键盘切换，这个版本不要
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *faceButton;
//@property (strong, nonatomic) UIButton *recordButton;
//@property (strong, nonatomic) UIButton *idiomButton;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@end

@implementation DXMessageToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xebecee);
        [self setupConfigure];
    }
    return self;
}

//重新setget方法
- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupSubviews];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - getter

//- (UIImageView *)backgroundImageView
//{
//    if (_backgroundImageView == nil) {
//        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _backgroundImageView.backgroundColor = [UIColor clearColor];
//        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    }
//    
//    return _backgroundImageView;
//}
//
//- (UIImageView *)toolbarBackgroundImageView
//{
//    if (_toolbarBackgroundImageView == nil) {
//        _toolbarBackgroundImageView = [[UIImageView alloc] init];
//        _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
//        _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    }
//    return _toolbarBackgroundImageView;
//}

- (UIView *)toolbarView
{
    if (_toolbarView == nil) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = [UIColor clearColor];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xcccccc);
        [_toolbarView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(0);
            make.height.equalTo(1);
        }];
    }
    return _toolbarView;
}

#pragma mark - setter

//- (void)setBackgroundImage:(UIImage *)backgroundImage
//{
//    _backgroundImage = backgroundImage;
//    self.backgroundImageView.image = backgroundImage;
//}
//
//- (void)setToolbarBackgroundImage:(UIImage *)toolbarBackgroundImage
//{
//    _toolbarBackgroundImage = toolbarBackgroundImage;
//    self.toolbarBackgroundImageView.image = toolbarBackgroundImage;
//}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    self.faceButton.selected = NO;
//    self.idiomButton.selected = NO;
//    self.styleChangeButton.selected = NO;
    self.moreButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.inputTextView.text = @"";
            self.inputTextView.backgroundColor = UIColorFromRGB(0xebecee);
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.inputTextView.text;
    
    if (!isDelete && str.length > 0) {
        self.inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        if (chatText.length >= 2)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([(DXFaceView *)self.faceView stringIsFace:subStr]) {
                self.inputTextView.text = [chatText substringToIndex:chatText.length-2];
                
                return;
            }
        }
        
        if (chatText.length > 0) {
            self.inputTextView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    
    [self textViewDidChange:self.inputTextView];
}

- (void)sendFace
{
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
    }
}

//#pragma mark - EMIdiomViewDelegate
//
//- (void)idiomView:(EMIdiomView *)idiomView didSelectIdiom:(NSString *)idiomText
//{
//    NSMutableString *text = [[NSMutableString alloc] initWithString:[self.inputTextView text]];
//    [text appendString:idiomText];
//    [self.inputTextView setText:text];
//    //[- (void)buttonAction:(id)sender]
//    [self performSelector:@selector(buttonAction:) withObject:self.idiomButton];
//    
//    [self textViewDidChange:self.inputTextView];
//    //[self.delegate didSendText:text];
//}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

#pragma mark - private

/**
 *  设置初始属性
 */
- (void)setupConfigure
{
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
//    self.backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
//    [self addSubview:self.backgroundImageView];
    
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
//    self.toolbarBackgroundImageView.frame = self.toolbarView.bounds;
//    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
////    self.toolbarBackgroundImageView.backgroundColor = [UIColor grayColor]
    [self addSubview:self.toolbarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubviews
{
    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 6.0;
    
    //转变输入样式
    //左边的录音和键盘切换
//    self.styleChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
//    self.styleChangeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    [self.styleChangeButton setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
//    [self.styleChangeButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
//    [self.styleChangeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.styleChangeButton.tag = 0;
//    allButtonWidth += CGRectGetMaxX(self.styleChangeButton.frame);
//    textViewLeftMargin += CGRectGetMaxX(self.styleChangeButton.frame);
    
    //更多(加号，可以发照片)
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kHorizontalPadding - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.moreButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_moreSelected"] forState:UIControlStateHighlighted];
    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self.moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton.tag = 2;
    allButtonWidth += CGRectGetWidth(self.moreButton.frame) + kHorizontalPadding * 2.5;
    
    //表情按钮
    self.faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.moreButton.frame) - kInputTextViewMinHeight - kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.faceButton.backgroundColor = [UIColor redColor];//TODO
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_faceSelected"] forState:UIControlStateHighlighted];
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.faceButton.tag = 1;
//    [self.faceButton setHidden:YES];    // 隐藏表情按钮
//    allButtonWidth += CGRectGetWidth(self.faceButton.frame) + kHorizontalPadding * 1.5; // 暂不参与计算宽度
    self.faceButton.hidden = YES;
    
//    // 常用语 (占用表情的位置)
//    self.idiomButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.moreButton.frame) - kInputTextViewMinHeight - kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
//    self.idiomButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
//    [self.idiomButton setImage:[UIImage imageNamed:@"icon_text"] forState:UIControlStateNormal];
//    [self.idiomButton setImage:[UIImage imageNamed:@"icon_text"] forState:UIControlStateHighlighted];
//    [self.idiomButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
//    [self.idiomButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.idiomButton.tag = 3;
//    allButtonWidth += CGRectGetWidth(self.idiomButton.frame) + kHorizontalPadding * 1.5;
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));
    // 初始化输入框
    self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //    self.inputTextView.contentMode = UIViewContentModeCenter;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _inputTextView.placeHolder = @"";
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 6.0f;
    
    _inputTextView.inputAccessoryView = [[UIView alloc] init];
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    
//    //录制
//    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
//    self.recordButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [self.recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [self.recordButton setBackgroundImage:[[UIImage imageNamed:@"chatBar_recordBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
//    [self.recordButton setBackgroundImage:[[UIImage imageNamed:@"chatBar_recordSelectedBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
//    [self.recordButton setTitle:kTouchToRecord forState:UIControlStateNormal];
//    [self.recordButton setTitle:kTouchToFinish forState:UIControlStateHighlighted];
//    self.recordButton.hidden = YES;
//    [self.recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
//    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
//    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//    [self.recordButton addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
//    [self.recordButton addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
//    self.recordButton.hidden = YES;
    
    
#warning 更多
    if (!self.moreView) {
//                self.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 210)];
        self.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 110)];
//                self.moreView.backgroundColor = [UIColor lightGrayColor];
        self.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
//    if (!self.faceView) {
//        self.faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 200)];
//        [(DXFaceView *)self.faceView setDelegate:self];
//        self.faceView.backgroundColor = [UIColor lightGrayColor];
//        self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    }
    
//    if (!self.recordView) {
//        self.recordView = [[DXRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
//    }
    
//    if (!self.idiomView) {
//        self.idiomView = [[EMIdiomView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 160.0f)];
//        ((EMIdiomView *)self.idiomView).delegate = self;
//        self.idiomView.backgroundColor = [UIColor lightGrayColor];
//        self.idiomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    }
//    [self.toolbarView addSubview:self.styleChangeButton];//左边键盘和录音模式的切换
    [self.toolbarView addSubview:self.moreButton];//加号➕
    [self.toolbarView addSubview:self.faceButton];//表情
//    [self.toolbarView addSubview:self.idiomButton];//常用语
    [self.toolbarView addSubview:self.inputTextView];//键盘
//    [self.toolbarView addSubview:self.recordButton];//录音
}

#pragma mark - change frame 扩展页
//扩展页
- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    self.frame = toFrame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
        [_delegate didChangeFrameToHeight:toHeight];
    }
}

- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        if (self.version < 7.0) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
            [_delegate didChangeFrameToHeight:self.frame.size.height];
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - action

- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    
    switch (tag){
//    {
//        case 0://切换状态，录音和键盘，这个版本不要需要
//        {
//            if (button.selected) {
//                self.faceButton.selected = NO;
////                self.idiomButton.selected = NO;
//                self.moreButton.selected = NO;
//                //录音状态下，不显示底部扩展页面
//                [self willShowBottomView:nil];
//                
//                //将inputTextView内容置空，以使toolbarView回到最小高度
//                self.inputTextView.text = @"";
//                [self textViewDidChange:self.inputTextView];
//                [self.inputTextView resignFirstResponder];
//            }
//            else{
//                //键盘也算一种底部扩展页面
//                [self.inputTextView becomeFirstResponder];
//            }
            
//            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
////                self.recordButton.hidden = !button.selected;
//                self.inputTextView.hidden = button.selected;
//            } completion:^(BOOL finished) {
//                
//            }];
            
            //录音
//            if ([self.delegate respondsToSelector:@selector(didStyleChangeToRecord:)]) {
//                [self.delegate didStyleChangeToRecord:button.selected];
//            }
            
//        }
//            break;
//        case 1://表情
//        {
//            if (button.selected) {
//                self.moreButton.selected = NO;
////                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
////                if (self.styleChangeButton.selected) {
////                    self.styleChangeButton.selected = NO;
////                }
////                else{//如果处于文字输入状态，使文字输入框失去焦点
////                    [self.inputTextView resignFirstResponder];
////                }
//                [self.inputTextView resignFirstResponder];
//                [self willShowBottomView:self.faceView];
//                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
////                    self.recordButton.hidden = button.selected;
//                    self.inputTextView.hidden = !button.selected;
//                } completion:^(BOOL finished) {
//                    
//                }];
//            } else {
////                if (!self.styleChangeButton.selected) {
////                    [self.inputTextView becomeFirstResponder];
////                }
////                else{
//                    [self willShowBottomView:nil];
////                }
//            }
//        }
//            break;
        case 2://更多
        {
            if (button.selected) {
//                self.faceButton.selected = NO;//表情按钮
//                self.idiomButton.selected = NO;//常语按钮
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
//                if (self.styleChangeButton.selected) {
//                    self.styleChangeButton.selected = NO;
//                }
//                else{//如果处于文字输入状态，使文字输入框失去焦点
                    [self.inputTextView resignFirstResponder];
//                }
                
                [self willShowBottomView:self.moreView];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.recordButton.hidden = button.selected;
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
//                self.styleChangeButton.selected = NO;
                [self.inputTextView becomeFirstResponder];
            }
        }
            break;
//        case 3://常用语
//        {
//            if (button.selected) {
//                self.moreButton.selected = NO;
//                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
////                if (self.styleChangeButton.selected) {
////                    self.styleChangeButton.selected = NO;
////                }
////                else{//如果处于文字输入状态，使文字输入框失去焦点
//                    [self.inputTextView resignFirstResponder];
////                }
//                
////                [self willShowBottomView:self.idiomView];
//                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
////                    self.recordButton.hidden = button.selected;
//                    self.inputTextView.hidden = !button.selected;
//                } completion:^(BOOL finished) {
//                    
//                }];
//            } else {
//                self.styleChangeButton.selected = NO;
//                [self.inputTextView becomeFirstResponder];
//            }
//            
//        }
//            break;
        default:
            break;
    }
}

#pragma mark - 发语音录音的功能
//- (void)recordButtonTouchDown
//{
//    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
//        [(DXRecordView *)self.recordView recordButtonTouchDown];
//    }
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]) {
//        [_delegate didStartRecordingVoiceAction:self.recordView];
//    }
//}

//- (void)recordButtonTouchUpOutside
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)])
//    {
//        [_delegate didCancelRecordingVoiceAction:self.recordView];
//    }
//    
//    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
//        [(DXRecordView *)self.recordView recordButtonTouchUpOutside];
//    }
//    
//    [self.recordView removeFromSuperview];
//}
//
//- (void)recordButtonTouchUpInside
//{
//    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
//        [(DXRecordView *)self.recordView recordButtonTouchUpInside];
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)])
//    {
//        [self.delegate didFinishRecoingVoiceAction:self.recordView];
//    }
//    
//    [self.recordView removeFromSuperview];
//}
//
//- (void)recordDragOutside
//{
//    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
//        [(DXRecordView *)self.recordView recordButtonDragOutside];
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction:)])
//    {
//        [self.delegate didDragOutsideAction:self.recordView];
//    }
//}
//
//- (void)recordDragInside
//{
//    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
//        [(DXRecordView *)self.recordView recordButtonDragInside];
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(didDragInsideAction:)])
//    {
//        [self.delegate didDragInsideAction:self.recordView];
//    }
//}


#pragma mark - public

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    self.faceButton.selected = NO;
//    self.idiomButton.selected = NO;
    self.moreButton.selected = NO;
    [self willShowBottomView:nil];
    
    return result;
}

/**
 *  取消触摸录音键
 */
//- (void)cancelTouchRecord
//{
//    //    self.recordButton.selected = NO;
//    //    self.recordButton.highlighted = NO;
//    if ([_recordView isKindOfClass:[DXRecordView class]]) {
//        [(DXRecordView *)_recordView recordButtonTouchUpInside];
//        [_recordView removeFromSuperview];
//    }
//}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

@end
