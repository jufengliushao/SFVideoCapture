//
//  SFVideoManager.m
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import "SFVideoManager.h"
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import "LGAlertView.h"
@interface SFVideoManager()<LGAlertViewDelegate>

@end

static SFVideoManager *videoManager = nil;

@implementation SFVideoManager
#pragma mark - 系统方法
+ (SFVideoManager *)videoManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!videoManager) {
            videoManager = [[SFVideoManager alloc] init];
        }
    });
    return videoManager;
}

#pragma mark - 权限检查
#pragma mark - 录制视频所需权限
- (void)sf_getAllVideoRight{
    AVAuthorizationStatus audioStatus = [self sf_private_askAudioRightStuts];
    [self sf_private_CamerRight:audioStatus type:(AVMediaTypeAudio)];
    AVAuthorizationStatus cameraStatus = [self sf_private_askCameraRightStuts];
    [self sf_private_CamerRight:cameraStatus type:(AVMediaTypeVideo)];
}

#pragma mark - 私有方法
// 获取手机相机权限
- (AVAuthorizationStatus)sf_private_askCameraRightStuts{
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];;
}

// 获取手机麦克风权限
- (AVAuthorizationStatus)sf_private_askAudioRightStuts{
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
}

//相机权限
- (void)sf_private_getCamerRight{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
}

//麦克风权限
- (void)sf_private_getAudioRight{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
}
#pragma mark - 权限事件处理
- (void)sf_private_CamerRight:(AVAuthorizationStatus)camerS type:(AVMediaType)type{
    switch (camerS) {
        case AVAuthorizationStatusNotDetermined:{
            // 未询问用户
            if (type == AVMediaTypeAudio) {
                [self sf_private_getAudioRight];
            }else{
                [self sf_private_getCamerRight];
            }
        }
            break;
            
        case AVAuthorizationStatusRestricted:{
            // 设备有问题，请叫家长
            LGAlertView *alter = [[LGAlertView alloc] initWithTitle:@"提示" message:@"请找家长" style:(LGAlertViewStyleAlert) buttonTitles:nil cancelButtonTitle:@"确认" destructiveButtonTitle:nil delegate:self];
            alter.tag = SF_ALTER_TAG_CAMER_Restricted;
            [alter showAnimated:YES completionHandler:nil];
        }
            break;
            
        case AVAuthorizationStatusDenied:{
            // 用户拒绝
            LGAlertView *alter = [[LGAlertView alloc] initWithTitle:@"提示" message:@"请到设置进行授权" style:(LGAlertViewStyleAlert) buttonTitles:@[@"前往"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil delegate:self];
            alter.tag = SF_ALTER_TAG_CAMER_DEFINE;
            [alter showAnimated:YES completionHandler:nil];
        }
            break;
            
        case AVAuthorizationStatusAuthorized:{
            // 用户已授权
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 方法跳转
- (void)sf_private_skipSetting{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([UIDevice currentDevice].systemVersion.doubleValue > 10.0) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
}

#pragma mark - LGAlertViewDelegate
- (void)alertView:(LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title {
    switch (alertView.tag) {
        case SF_ALTER_TAG_CAMER_DEFINE:{
            // 跳转到应用权限设置中心
            [self sf_private_skipSetting];
        }
            break;
            
        default:
            break;
    }
}

- (void)alertViewCancelled:(LGAlertView *)alertView {
    
}

- (void)alertViewDestructed:(LGAlertView *)alertView {
    
}
@end
