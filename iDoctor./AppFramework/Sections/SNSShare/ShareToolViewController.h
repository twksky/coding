//
//  ShareToolViewController.h
//  AppFramework
//
//  Created by ABC on 8/4/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kShareTool_WeiXinFriends = 0, // 微信好友
    kShareTool_WeiXinCircleFriends, // 微信朋友圈
} ShareToolType;

@protocol ShareToolViewControllerDelegate <NSObject>

@end

@interface ShareToolViewController : UIViewController<UIActionSheetDelegate>
{
    
}

@property (nonatomic, retain)NSString *shareTitle;
@property (nonatomic, retain)NSString *detailInfo;
@property (nonatomic, retain)UIImage *shareImage;
@property (nonatomic, retain)NSString *shareImageURL;


@property (nonatomic, assign)id<ShareToolViewControllerDelegate> delegate;


- (void)initWhithTitle:(NSString *)title detailInfo:(NSString*)detailInfo image:(UIImage *)image imageUrl:(NSString *)imageUrl;

@end

