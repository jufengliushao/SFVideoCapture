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
@implementation SFVideoToolView
- (instancetype)init{
    if (self  = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
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
        }else{
            [[SFVideo videoFuncManager] sf_stopVideo];
        }
    }];
    
    // 摄像头切换事件
    [self.cameraFront addTargetAction:^(UIButton *sender) {
        sender.selected = !sender.isSelected;
        [[SFVideo videoFuncManager] sf_changeCamera:sender.isSelected];
    }];
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
@end
