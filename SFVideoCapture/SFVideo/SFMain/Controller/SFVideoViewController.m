//
//  SFVideoViewController.m
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import "SFVideoViewController.h"
#import "SFVideo.h"
#import "Masonry.h"
#import "UIButton+SFButton.h"
@interface SFVideoViewController (){
    BOOL isRecoding;
}

@end

@implementation SFVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isRecoding = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    SFVideoLayerView *layerView = [[SFVideo videoFuncManager] sf_getVideoLayer];
    layerView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.view = layerView;
    
    [layerView bringSubviewToFront:layerView.toolView];
    WS(ws);
    [layerView.toolView.recordBtn addTargetAction:^(UIButton *sender) {
        NSLog(@"开始录制");
        [ws recordingAction];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)recordingAction{
    if (!isRecoding) {
        [[SFVideo videoFuncManager] sf_startVideo];
        isRecoding = YES;
    }else{
        [[SFVideo videoFuncManager] sf_stopVideo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
