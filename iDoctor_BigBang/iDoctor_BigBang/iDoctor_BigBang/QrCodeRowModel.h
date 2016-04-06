//
//  QrCodeRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ArrowRowModel.h"

@interface QrCodeRowModel : ArrowRowModel

@property(nonatomic, strong) UIImage *qrCodeImage;

+ (instancetype)qrCodelModelWithTitle:(NSString *)title qrCodeImage:(UIImage *)qrCodeImage destVC:(Class)destVC;
@end
