//
//  WLARecorderPressView.h
//  ZSAudioCommunication
//
//  Created by 赵帅 on 14-4-2.
//  Copyright (c) 2014年 com.Bayonetta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WLARecorderDelegate <NSObject>

- (void)pressBegan;

- (void)pressMove;

- (void)pressEnd;

@end


@interface WLARecorderPressView : UIView 

@property (nonatomic, strong) id recorderDelegate;

- (void)setup:(UIView *)parentView;

@end
