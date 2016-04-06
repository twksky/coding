//
//  HeaderManger.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeaderManger : NSObject

+ (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view;
+  (void)scrollViewDidScroll:(UIScrollView*)scrollView;
+ (void)resizeView;

@end
