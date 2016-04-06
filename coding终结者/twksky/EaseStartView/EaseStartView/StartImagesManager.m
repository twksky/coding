//
//  StartImagesManager.m
//  EaseStartView
//
//  Created by twksky on 15/11/4.
//  Copyright © 2015年 twksky. All rights reserved.
//

#import "StartImagesManager.h"
#import <objc/runtime.h>

@interface NSURL (Common)

@end

@implementation NSURL (Common)

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if ([[NSFileManager defaultManager] fileExistsAtPath: [URL path]])
    {
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1")) {
            NSError *error = nil;
            BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
            if(error){
                NSLog(@"addSkipBackupAttributeToItemAtURL: %@, error: %@", [URL lastPathComponent], error);
            }
            return success;
//        }
        
//        if (SYSTEM_VERSION_GREATER_THAN(@"5.0")) {
//            const char* filePath = [[URL path] fileSystemRepresentation];
//            const char* attrName = "com.apple.MobileBackup";
//            u_int8_t attrValue = 1;
//            int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//            return result == 0;
//        }
    }
    return NO;
}

@end

@interface StartImagesManager ()
@property (strong, nonatomic) NSMutableArray *imageLoadedArray;
@property (strong, nonatomic) StartImage *startImage;
@end

@implementation StartImagesManager
+ (instancetype)shareManager{
    static StartImagesManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createFolder:[self downloadPath]];
        [self loadStartImages];
    }
    return self;
}

//从一个路径得到一个文件夹
- (BOOL)createFolder:(NSString *)path{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir == YES && existed == YES)){
        isCreated = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        isCreated = YES;
    }
    if (isCreated) {
        [NSURL addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path isDirectory:YES]];
    }
    return isCreated;
}

//得到一个本地的沙河路径用来下载图片的
-(NSString *)downloadPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadPath = [documentPath stringByAppendingPathComponent:@"Coding_StartImages"];
    return downloadPath;
}

-(void)loadStartImages{
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:[self pathOfSTPlist]];
    plistArray = [self arrayMapFromArray:plistArray forPropertyName:@"StartImage"];//id转obj
    
    NSMutableArray *imageLoadedArray = [[NSMutableArray alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for (StartImage *curST in plistArray) {
        if ([fm fileExistsAtPath:curST.pathDisk]) {
            [imageLoadedArray addObject:curST];
        }
    }
    
    //    上一次显示的图片，这次就应该把它换掉
    NSString *preDisplayImageName = [self getDisplayImageName];
    if (preDisplayImageName && preDisplayImageName.length > 0) {
        NSUInteger index = [imageLoadedArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([[(StartImage *)obj fileName] isEqualToString:preDisplayImageName]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        if (index != NSNotFound && imageLoadedArray.count > 1) {//imageLoadedArray.count > 1 是因为，如果一共就一张图片，那么即便上次显示了这张图片，也应该再次显示它
            [imageLoadedArray removeObjectAtIndex:index];
        }
    }
    self.imageLoadedArray = imageLoadedArray;
}

- (NSString *)pathOfSTPlist{
    return [[self downloadPath] stringByAppendingPathComponent:@"STARTIMAGE.plist"];
}

-(NSMutableArray *)arrayMapFromArray:(NSArray *)nestedArray forPropertyName:(NSString *)propertyName {
    // Set Up
    NSMutableArray *objectsArray = [@[] mutableCopy];
    
    // Removes "ArrayOf(PropertyName)s" to get to the meat
    //NSString *filteredProperty = [propertyName substringWithRange:NSMakeRange(0, propertyName.length - 1)]; /* TenEight */
    //NSString *filteredProperty = [propertyName substringWithRange:NSMakeRange(7, propertyName.length - 8)]; /* AlaCop */
    
    // Create objects
    for (int xx = 0; xx < nestedArray.count; xx++) {
        // If it's an NSDictionary
        if ([nestedArray[xx] isKindOfClass:[NSDictionary class]]) {
            // Create object of filteredProperty type
            id nestedObj = [[NSClassFromString(propertyName) alloc] init];
            
            // Iterate through each key, create objects for each
            for (NSString *newKey in [nestedArray[xx] allKeys]) {
                // If it's an Array, recur
                if ([[nestedArray[xx] objectForKey:newKey] isKindOfClass:[NSArray class]]) {
                    //添加属性判断，防止运行时崩溃
                    objc_property_t property = class_getProperty([NSClassFromString(propertyName) class], [@"propertyArrayMap" UTF8String]);
                    if (!property) {
                        continue;
                    }
                    NSString *propertyType = [nestedObj valueForKeyPath:[NSString stringWithFormat:@"propertyArrayMap.%@", newKey]];
                    if (!propertyType) {
                        continue;
                    }
                    [nestedObj setValue:[NSObject arrayMapFromArray:[nestedArray[xx] objectForKey:newKey]  forPropertyName:propertyType] forKey:newKey];
                }
                // If it's a Dictionary, create an object, and send to [self objectFromJSON]
                else if ([[nestedArray[xx] objectForKey:newKey] isKindOfClass:[NSDictionary class]]) {
                    NSString *type = [nestedObj classOfPropertyNamed:newKey];
                    if (!type) {
                        continue;
                    }
                    
                    id nestedDictObj = [NSObject objectOfClass:type fromJSON:[nestedArray[xx] objectForKey:newKey]];
                    [nestedObj setValue:nestedDictObj forKey:newKey];
                }
                // Else, it is an object
                else {
                    NSString *tempNewKey;
                    if ([newKey isEqualToString:@"description"]) {
                        tempNewKey = [newKey stringByAppendingString:@"_mine"];
                    }else{
                        tempNewKey = newKey;
                    }
                    objc_property_t property = class_getProperty([NSClassFromString(propertyName) class], [tempNewKey UTF8String]);
                    if (!property) {
                        continue;
                    }
                    NSString *classType = [self typeFromProperty:property];
                    // check if NSDate or not
                    if ([classType isEqualToString:@"T@\"NSDate\""]) {
                        //                        1970年的long型数字
                        NSObject *obj = [nestedArray[xx] objectForKey:newKey];
                        if ([obj isKindOfClass:[NSNumber class]]) {
                            NSNumber *timeSince1970 = (NSNumber *)obj;
                            NSTimeInterval timeSince1970TimeInterval = timeSince1970.doubleValue/1000;
                            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSince1970TimeInterval];
                            [nestedObj setValue:date forKey:tempNewKey];
                        }else{
                            //                            日期字符串
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:OMDateFormat];
                            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
                            
                            NSString *dateString = [[nestedArray[xx] objectForKey:newKey] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                            [nestedObj setValue:[formatter dateFromString:dateString] forKey:tempNewKey];
                        }
                    }
                    else {
                        [nestedObj setValue:[nestedArray[xx] objectForKey:newKey] forKey:tempNewKey];
                    }
                }
            }
            
            // Finally add that object
            [objectsArray addObject:nestedObj];
        }
        
        // If it's an NSArray, recur
        else if ([nestedArray[xx] isKindOfClass:[NSArray class]]) {
            [objectsArray addObject:[NSObject arrayMapFromArray:nestedArray[xx] forPropertyName:propertyName]];
        }
        
        // Else, add object directly
        else {
            [objectsArray addObject:nestedArray[xx]];
        }
    }
    
    // This is now an Array of objects
    return objectsArray;
}





















@end
