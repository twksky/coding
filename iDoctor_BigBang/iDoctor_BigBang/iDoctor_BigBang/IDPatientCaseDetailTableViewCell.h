//
//  IDPatientCaseDetailTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/19.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

typedef void(^webViewDidFinishBlock)(void);

@class IDPatientMedicalsModel;
@interface IDPatientCaseDetailTableViewCell : UITableViewCell<UIWebViewDelegate>


@property (nonatomic, copy) webViewDidFinishBlock block;

#pragma mark - 第1组  每个元素
@property (nonatomic, strong) UIWebView *webView;

// 根据不同的行列 进行相应的布局
- (void)setupUIWithIndexPath:(NSIndexPath *)indexPath;


// 根据不同的行  加载不同的东西
- (void)dataCellWithModel:(IDPatientMedicalsModel *)model indexpath:(NSIndexPath *)indexpath;

// webView 的高度
+ (CGFloat)height;

@end
