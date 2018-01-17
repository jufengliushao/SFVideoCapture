//
//  SFVideoToolView.m
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import "SFVideoToolView.h"
#import "Masonry.h"
@implementation SFVideoToolView
- (instancetype)init{
    if (self  = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
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
//    self.recordBtn.frame = CGRectMake(100, 100, 50, 50);
    [super drawRect:rect];
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

@end
