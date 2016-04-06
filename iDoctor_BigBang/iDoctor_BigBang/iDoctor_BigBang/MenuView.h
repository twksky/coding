//
//  MenuView.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/2/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RegionFilterBlock)(NSNumber *regionId);
typedef void(^CategoryFilterBlock)(NSString *categoryName, NSNumber *rank);

@class MenuButton;
@interface MenuView : UIView

@property(nonatomic, copy)RegionFilterBlock regionFilterBlock;
@property(nonatomic, copy)CategoryFilterBlock categoryFilterBlock;

- (void)hideMenu;

- (void)setRegionFilterBlock:(RegionFilterBlock)regionFilterBlock;

- (void)setCategoryFilterBlock:(CategoryFilterBlock)categoryFilterBlock;
@end
