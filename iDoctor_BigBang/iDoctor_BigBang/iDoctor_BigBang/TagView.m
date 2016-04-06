//
//  TagView.m
//  iDoctor_BigBang
//
//  Created by hexy on 6/31/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TagView.h"

@interface TagView ()
@property(nonatomic, strong) NSDictionary *colorDict;
@property(nonatomic, assign) CGFloat height;
@end
@implementation TagView

- (CGFloat)setTagsWithTagsArr:(NSArray *)tagArr wrapWidth:(CGFloat)wrapWidth
{
    [self removeSubViews];
    CGFloat tWidth = 0.0f;
    CGFloat tHeight = 0.0f;
    
    CGFloat tagHeight = 0.0f;
    for (NSString *tag in tagArr)
    {
        TagLabel *fillLabel = [[TagLabel alloc] initWithFrame:CGRectMake(tWidth, tHeight, 0, 0)];

//        [fillLabel setText:tag maxBoundingWith:wrapWidth];
        [fillLabel setText:tag textColor:UIColorFromRGB(0xc9c9c9) maxBoundingWith:wrapWidth];
        tWidth += fillLabel.fWidth + 6;
        tagHeight = fillLabel.fHeight;
        
        if(tWidth >= wrapWidth)
        {
            tHeight += fillLabel.fHeight + 6;
            tWidth = 0.0f;
            fillLabel.frame = CGRectMake(tWidth, tHeight, fillLabel.fWidth, fillLabel.fHeight);
            tWidth += fillLabel.fWidth + 6;
        }
        [self addSubview:fillLabel];
    }
    tHeight += tagHeight;
    
    self.height = tHeight;
    return tHeight;
}

- (CGFloat)setTagsWithlabelModel:(LabelModel *)labelModel wrapWidth:(CGFloat)wrapWidth
{
    [self removeSubViews];
   __block CGFloat tWidth = 0.0f;
   __block CGFloat tHeight = 0.0f;
    
   __block CGFloat tagHeight = 0.0f;
    
    [labelModel.keyValues enumerateKeysAndObjectsUsingBlock:^(id key, NSString *tag, BOOL *stop) {
        
        TagLabel *fillLabel = [[TagLabel alloc] initWithFrame:CGRectMake(tWidth, tHeight, 0, 0)];
        
        if (![tag isEqualToString:@""]) {
        
            [fillLabel setText:tag textColor:self.colorDict[key] maxBoundingWith:wrapWidth];
            tWidth += fillLabel.fWidth + 6;
            tagHeight = fillLabel.fHeight;
            
            if(tWidth >= wrapWidth)
            {
                tHeight += fillLabel.fHeight + 6;
                tWidth = 0.0f;
                fillLabel.frame = CGRectMake(tWidth, tHeight, fillLabel.fWidth, fillLabel.fHeight);
                tWidth += fillLabel.fWidth + 6;
            }
            [self addSubview:fillLabel];

        }
        
    }];
    tHeight += tagHeight;
    
    self.height = tHeight;

    return tHeight;
}
- (void)removeSubViews
{
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view removeFromSuperview];
        view = nil;
    }];
}

- (void)layoutSubviews
{
    self.fHeight = self.height;
}
- (NSDictionary *)colorDict
{
    if (_colorDict == nil) {
        _colorDict = @{
                       @"check_item"       : UIColorFromRGB(0xf998c4),
                       @"complication"     : UIColorFromRGB(0xf8a884),
                       @"disease_time"     : UIColorFromRGB(0x73d7f5),
                       @"follow_symptom"   : UIColorFromRGB(0xf8bd84),
                       @"medical_history"  : UIColorFromRGB(0x73cff5),
                       @"operation"        : UIColorFromRGB(0xf998b1),
                       @"pathology"        : UIColorFromRGB(0x7398f5),
                       @"stage"            : UIColorFromRGB(0xaea4f1),
                       @"symptom"          : UIColorFromRGB(0x9ae5d1),
                       @"treatment"        : UIColorFromRGB(0xf0a49e)
                       };
    }
    return _colorDict;
}
@end
