//
//  SFGlobalheader.h
//  SFVideoCapture
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 com.easyhospital. All rights reserved.
//

#ifndef SFGlobalheader_h
#define SFGlobalheader_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

// weak self
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
// block self
#define BS(blockSelf) __block __typeof(&*self)blockSelf = self;

#endif /* SFGlobalheader_h */
