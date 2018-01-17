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

- (void)sf_startVideo;
- (void)sf_stopVideo;
- (SFVideoLayerView *)sf_getVideoLayer;
@end