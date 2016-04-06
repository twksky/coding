//
//  HeaderManger.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "HeaderManger.h"

#define kManger [HeaderManger sharedManger]
@interface HeaderManger ()
{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}
@property(nonatomic, strong) UITableView* tableView;
@property(nonatomic, strong) UIView* view;
@end

@implementation HeaderManger

+ (instancetype)sharedManger
{
    static HeaderManger *_manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manger = [[self alloc] init];
    });
    return _manger;
}

+ (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view
{
    [kManger stretchHeaderForTableView:tableView withView:view];
}
+  (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [kManger scrollViewDidScroll:scrollView];
}
+ (void)resizeView
{
    [kManger resizeView];
}

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view
{
    _tableView = tableView;
    _view = view;
    
    initialFrame       = _view.frame;
    defaultViewHeight  = initialFrame.size.height;
    
    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    _tableView.tableHeaderView = emptyTableHeaderView;
    
    [_tableView addSubview:_view];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGRect f = _view.frame;
    f.size.width = _tableView.frame.size.width;
    _view.frame = f;
    
    if(scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        initialFrame.origin.y = offsetY * -1;
        initialFrame.size.height = defaultViewHeight + offsetY;
        _view.frame = initialFrame;
    }
}

- (void)resizeView
{
    initialFrame.size.width = _tableView.frame.size.width;
    _view.frame = initialFrame;
}
@end
