//
//  PatientsModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/6/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "PatientsModel.h"

@implementation PatientsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"patient_medicals" : [PatientModel class], @"receive_doctor_list":[NSNumber class]};
}
@end


@implementation PatientModel
- (NSString *)updated_at
{
    NSString *year = [_updated_at substringWithRange:NSMakeRange(2, 2)];
    NSString *month = [_updated_at substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [_updated_at substringWithRange:NSMakeRange(8, 2)];
    NSString *hour = [_updated_at substringWithRange:NSMakeRange(10, 6)];
    return [NSString stringWithFormat:@"%@/%@/%@%@",year, month, day, hour];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end


@implementation LabelModel
//- (NSString *)check_item
//{
//    return @"减肥的快速拉近疯狂";
//}
//- (NSString *)disease_time
//{
//    return @"发大水了";
//}
//- (NSString *)operation
//{8
//    return @"房的拉萨";
//}
//- (NSString *)symptom
//{
//    return @"范德萨了";
//}
//- (NSString *)medical_history
//{
//    return @"附近的快奋斗";
//}
//- (NSString *)follow_symptom
//{
//    return @"附近的离开奋斗范德萨";
//}
//- (NSString *)treatment
//{
//    return @"附近的快乐";
//}
@end


