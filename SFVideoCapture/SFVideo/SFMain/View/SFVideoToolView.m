//
//  SFVideoToolView.m
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import "SFVideoToolView.h"
#import "Masonry.h"
#import "SFVideo.h"
#import "UIButton+SFButton.h"
#import "LGAlertView.h"

@interface SFVideoToolView()<LGAlertViewDelegate, UIGestureRecognizerDelegate>{
    NSInteger curSecond; // 当前秒数
}

@property (nonatomic, strong) NSTimer *secTimer; // 定时器

@end

@implementation SFVideoToolView
- (instancetype)init{
    if (self  = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        curSecond = 0;
        [self buttonAction];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws);
        make.bottom.mas_equalTo(-50);
        make.width.height.mas_equalTo(50);
    }];
    [self.cameraFront mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(45);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(30);
    }];
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.trailing.mas_equalTo(-45);
        make.height.mas_equalTo(30);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-30);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-45);
    }];
    [super drawRect:rect];
}

#pragma mark - 点击事件
- (void)buttonAction{
    WS(ws);
    // 开始按钮
    [self.recordBtn addTargetAction:^(UIButton *sender) {
        NSLog(@"开始录制");
        sender.selected = !sender.isSelected;
        if (sender.isSelected) {
            [[SFVideo videoFuncManager] sf_startVideo];
            [ws createTimer];
        }else{
            [[SFVideo videoFuncManager] sf_stopVideo];
            [self stopTimer];
        }
    }];
    
    // 摄像头切换事件
    [self.cameraFront addTargetAction:^(UIButton *sender) {
        sender.selected = !sender.isSelected;
        [[SFVideo videoFuncManager] sf_changeCamera:sender.isSelected];
    }];
    
    // 闪光灯打开
    [self.flashBtn addTargetAction:^(UIButton *sender) {
        sender.selected = !sender.isSelected;
        if (![[SFVideo videoFuncManager] sf_cameraTouch:sender.isSelected]) {
            [ws alert];
        }
    }];
}

- (void)alert{
    LGAlertView *av = [[LGAlertView alloc] initWithTitle:@"提示" message:@"你的设备不支持闪光灯" style:(LGAlertViewStyleAlert) buttonTitles:nil cancelButtonTitle:@"知道了" destructiveButtonTitle:nil delegate:self];
    av.tag = SF_ALTER_TAG_FLASH_NOHAVE;
    [av showAnimated:YES completionHandler:nil];
}

#pragma mark - 获取点击坐标
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *set = [event allTouches];
    UITouch *touch = [set anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint po = CGPointMake(point.x / self.width, point.y / self.height);
    NSLog(@"%.2f-%.2f", po.x, po.y);
    [[SFVideo videoFuncManager] sf_cameraFocus:po];
}

#pragma mark - 创建定时器
- (void)createTimer{
    self.secTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    curSecond = 0;
    [self.secTimer invalidate];
    self.secTimer = nil;
}

- (void)timerAction:(NSTimer *)sender{
    curSecond += 1;
    self.timeLabel.text = [NSString stringWithFormat:@"0:%02ld/0:30", curSecond];
    NSLog(@"运行了");
}

#pragma mark - LGAlertViewDelegate
- (void)alertViewCancelled:(LGAlertView *)alertView {
    
}


#pragma mark - 懒加载
- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_recordBtn setTitle:@"开始" forState:(UIControlStateNormal)];
        [_recordBtn setTitle:@"停止" forState:(UIControlStateSelected)];
        _recordBtn.selected = NO;
        [self addSubview:_recordBtn];
    }
    return _recordBtn;
}

- (UIButton *)cameraFront{
    if (!_cameraFront) {
        _cameraFront = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cameraFront setTitle:@"切换摄像头" forState:(UIControlStateNormal)];
        _cameraFront.titleLabel.font = [UIFont systemFontOfSize:13];
        _cameraFront.selected = NO;
        [self addSubview:_cameraFront];
    }
    return _cameraFront;
}

- (UIButton *)flashBtn{
    if(!_flashBtn){
        _flashBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_flashBtn setTitle:@"闪光灯打开" forState:(UIControlStateNormal)];
        [_flashBtn setTitle:@"闪光灯关闭" forState:(UIControlStateSelected)];
        _flashBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _flashBtn.selected = NO;
        [self addSubview:_flashBtn];
    }
    return _flashBtn;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"0:00/0:30";
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}
@end
