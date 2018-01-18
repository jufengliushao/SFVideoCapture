//
//  SFVideoToolView.h
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFVideoToolView : UIView

@property (nonatomic, strong) UIButton *recordBtn; // 录制与停止按钮
@property (nonatomic, strong) UIButton *cameraFront; // 摄像头切换
@property (nonatomic, strong) UIButton *flashBtn; // 闪光灯按钮
@property (nonatomic, strong) UILabel *timeLabel; // 计时显示文本

@end
