//
//  QrCodeRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "QrCodeRowModel.h"

@implementation QrCodeRowModel
+ (instancetype)qrCodelModelWithTitle:(NSString *)title qrCodeImage:(UIImage *)qrCodeImage destVC:(Class)destVC
{
    QrCodeRowModel *qrCode = [self arrowRowWithTitle:title destVC:destVC];
    qrCode.qrCodeImage = qrCodeImage;
    return qrCode;
}
@end
