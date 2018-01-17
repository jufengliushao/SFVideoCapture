//
//  ViewController.m
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import "ViewController.h"
#import "SFVideoManager.h"
#import "SFVideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SFVideoManager videoManager] sf_getAllVideoRight];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipAction:(id)sender {
    SFVideoViewController *videoVC = [[SFVideoViewController alloc] initWithNibName:@"SFVideoViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:videoVC animated:YES completion:^{
        
    }];
}

@end
