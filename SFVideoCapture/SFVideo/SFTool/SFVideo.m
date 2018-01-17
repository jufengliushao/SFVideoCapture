//
//  SFVideo.m
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import "SFVideo.h"
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVFoundation.h>

#import "SFFileManager.h"

@interface SFVideo()<AVCaptureFileOutputRecordingDelegate>{
    NSString *videoPath; // 视频路径
}

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput  *movieFileOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;

@end

static SFVideo *video = nil;
static NSString *fileName = @"baoxiu.mp4";

@implementation SFVideo
#pragma mark - 系统方法
+(SFVideo *)videoFuncManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!video) {
            video = [[SFVideo alloc] init];
        }
    });
    return video;
}

- (instancetype)init{
    if (self = [super init]) {
        self.present = SFVideoPresentMedium; // 中等质量
        [self sf_private_setVideoPresent];
        [[SFFileManager shareInstance] sf_createFile:fileName path: [[SFFileManager shareInstance] sf_getCachePath]];
        videoPath = [fileName stringByAppendingPathComponent:[[SFFileManager shareInstance] sf_getCachePath]];
        NSLog(@"%@", videoPath);
    }
    return self;
}

#pragma mark - 共有方法
- (void)sf_startVideo{
    [self.movieFileOutput startRecordingToOutputFileURL:[NSURL URLWithString:videoPath] recordingDelegate:self];
}

- (void)sf_stopVideo{
    [self.movieFileOutput stopRecording];
    [self.captureSession stopRunning];
}

- (SFVideoLayerView *)sf_getVideoLayer{
    [self sf_private_perpare];
    [self.captureSession startRunning];
    SFVideoLayerView *preView = [[SFVideoLayerView alloc] init];
    self.preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preViewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [preView.layer insertSublayer:self.preViewLayer atIndex:0];
    return preView;
}

#pragma mark - 私有方法
- (void)sf_private_perpare{
    [self sf_private_setVideoIn];
    [self sf_private_getAudioInput];
    [self sf_private_setOutPut];
}

- (void)sf_private_setVideoPresent{
    AVCaptureSessionPreset p = AVCaptureSessionPresetMedium;
    switch (self.present) {
        case SFVideoPresentHigh:{
            p = AVCaptureSessionPresetHigh;
        }
            break;
            
        case SFVideoPresentMedium:{
            p = AVCaptureSessionPresetMedium;
        }
            break;
            
        case SFVideoPresentLow:{
            p = AVCaptureSessionPresetLow;
        }
            break;
            
        default:
            break;
    }
    
    if ([self.captureSession canSetSessionPreset:p]) {
        [self.captureSession setSessionPreset:p];
    }else{
        [self.captureSession setSessionPreset:AVCaptureSessionPresetLow];
    }
}

// 设置视频输入
- (void)sf_private_setVideoIn{
    // 1.1 获取视频输入设备(摄像头)
    AVCaptureDevice *videoCaptureDevice = [self sf_private_getCamera:AVCaptureDevicePositionBack];//取得后置摄像头
    // 1.2 创建视频输入源
    NSError *error=nil;
    self.videoInput= [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&error];
    // 1.3 将视频输入源添加到会话
    if ([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    }
}

// 获取指定的摄像头
- (AVCaptureDevice *)sf_private_getCamera:(AVCaptureDevicePosition)position{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *de = nil;
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == position) {
            de = camera;
            break;
        }
    }
    return de;
}

// 切换摄像头
- (AVCaptureDevice *)sf_private_getCameraDevice:(BOOL)isFront
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == AVCaptureDevicePositionBack) {
            backCamera = camera;
        } else {
            frontCamera = camera;
        }
    }
    
    if (isFront) {
        return frontCamera;
    }
    return backCamera;
}

- (void)sf_private_getAudioInput{
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    NSError *error=nil;
    // 2.2 创建音频输入源
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    // 2.3 将音频输入源添加到会话
    if ([self.captureSession canAddInput:self.audioInput]) {
        [self.captureSession addInput:self.audioInput];
    }
}

- (void)sf_private_setOutPut{
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([_captureSession canAddOutput:_movieFileOutput])
    {
        [_captureSession addOutput:_movieFileOutput];
    }
}

#pragma mark - setter getter
- (void)setPresent:(SFVideoPresent)present{
    _present = present;
    [self sf_private_setVideoPresent];
}

#pragma mark -懒加载
- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}
@end