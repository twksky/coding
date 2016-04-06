//
//  TagView.h
//  iDoctor_BigBang
//
//  Created by hexy on 6/31/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagLabel.h"
#import "PatientsModel.h"

@interface TagView : UIView

- (CGFloat)setTagsWithTagsArr:(NSArray *)tagArr wrapWidth:(CGFloat)wrapWidth;

- (CGFloat)setTagsWithlabelModel:(LabelModel *)labelModel wrapWidth:(CGFloat)wrapWidth;
@end
