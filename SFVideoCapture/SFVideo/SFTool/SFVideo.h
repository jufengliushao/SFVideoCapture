//
//  SFVideo.h
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFVideoLayerView.h"
typedef NS_ENUM(NSInteger, SFVideoPresent) {
    SFVideoPresentHigh, // 最高质量
    SFVideoPresentMedium, // 中等质量
    SFVideoPresentLow // 低质量
};

@interface SFVideo : NSObject
+ (SFVideo *)videoFuncManager;

@property (nonatomic, assign) SFVideoPresent present; // 录像质量 默认中等质量

// 开始录制视频
- (void)sf_startVideo;
// 停止录制视频
- (void)sf_stopVideo;
// 获取展示页面
- (SFVideoLayerView *)sf_getVideoLayer;

/**
 * 切换摄像头
 * YES 前置
 * NO 后置
 */
- (void)sf_changeCamera:(BOOL)isFront;
@end
