//
//  WLAVolumeDisplayView.h
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLAVolumeDisplayView : UIView

- (instancetype)initWithMaskImage:(UIImage *)maskImage;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
