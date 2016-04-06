//
//  TagLabel.h
//  iDoctor_BigBang
//
//  Created by hexy on 6/31/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagLabel : UILabel

-(void)setText:(NSString *)text maxBoundingWith:(CGFloat)maxBoundingWith;
-(void)setText:(NSString *)text textColor:(UIColor *)textColor maxBoundingWith:(CGFloat)maxBoundingWith;

@end
