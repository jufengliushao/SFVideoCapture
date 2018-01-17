//
//  SFVideoManager.h
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFVideoManager : NSObject
+ (SFVideoManager *)videoManager;

- (void)sf_getAllVideoRight;
@end
