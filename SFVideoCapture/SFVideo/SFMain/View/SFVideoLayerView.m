//
//  SFVideoLayerView.m
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import "SFVideoLayerView.h"

@implementation SFVideoLayerView
- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.toolView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.toolView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    for (CALayer *layer in self.layer.sublayers) {
        layer.frame = rect;
    }
    [super drawRect:rect];
}

- (SFVideoToolView *)toolView{
    if (!_toolView) {
        _toolView = [[SFVideoToolView alloc] init];
    }
    return _toolView;
}

@end
