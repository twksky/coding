//
//  TagLabel.m
//  iDoctor_BigBang
//
//  Created by hexy on 6/31/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TagLabel.h"

@implementation TagLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
//        self.textColor = GDRandomColor;
        self.font = GDFont(11);
        self.textAlignment = NSTextAlignmentCenter;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 9;
        self.layer.borderWidth = 1;
//        self.layer.borderColor = self.textColor.CGColor;
    }
    
    return self;
}

-(void)setText:(NSString *)text maxBoundingWith:(CGFloat)maxBoundingWith
{
    super.text = text;
//    self.textColor = [UIColor redColor];
     self.layer.borderColor = self.textColor.CGColor;
    NSDictionary *dict = @{NSFontAttributeName: GDFont(11)};
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(maxBoundingWith, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    self.frame = CGRectMake(self.fX, self.fY, size.width + 10, size.height + 4);
}
- (void)setText:(NSString *)text textColor:(UIColor *)textColor maxBoundingWith:(CGFloat)maxBoundingWith
{
    super.text = text;
    self.textColor = textColor;
    self.layer.borderColor = self.textColor.CGColor;
    NSDictionary *dict = @{NSFontAttributeName: GDFont(11)};
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(maxBoundingWith, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    self.frame = CGRectMake(self.fX, self.fY, size.width + 10, size.height + 4);
}
@end
