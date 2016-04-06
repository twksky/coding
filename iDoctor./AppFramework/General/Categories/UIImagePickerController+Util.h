//
//  UIImagePickerController+Util.h
//  AppFramework
//
//  Created by ABC on 6/18/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImagePickerController (Util)

+ (BOOL)isCameraAvailable;                      // 判断设备是否有摄像头
+ (BOOL)isFrontCameraAvailable;                 // 前面的摄像头是否可用
+ (BOOL)isRearCameraAvailable;                  // 后面的摄像头是否可用
+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;   // 判断是否支持某种多媒体类型：拍照，视频
+ (BOOL)doesCameraSupportShootingVideos;        // 检查摄像头是否支持录像
+ (BOOL)doesCameraSupportTakingPhotos;          // 检查摄像头是否支持拍照
+ (BOOL)isPhotoLibraryAvailable;                // 相册是否可用
+ (BOOL)canUserPickVideosFromPhotoLibrary;      // 是否可以在相册中选择视频
+ (BOOL)canUserPickPhotosFromPhotoLibrary;      // 是否可以在相册中选择照片

@end
