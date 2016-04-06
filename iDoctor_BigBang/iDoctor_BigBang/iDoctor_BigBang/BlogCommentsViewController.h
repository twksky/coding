//
//  BlogCommentsViewController.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

/*
看评论，不是去写评论
 */

#import "BaseViewController.h"
@class HomeInfoModel;

@interface BlogCommentsViewController : BaseViewController

- (instancetype)initWithBlog:(HomeInfoModel *)blog;

@end


