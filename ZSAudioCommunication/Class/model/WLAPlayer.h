//
//  WLAPlayer.h
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAPlayer : NSObject

@property (nonatomic, copy) NSString *audioFileName;

@property (nonatomic, copy) NSString *documentPath;

@property (nonatomic, copy) void(^playCompletionBlock)();

- (instancetype)initWithAudioController:(AEAudioController *)audioController;
    
- (void)playBegin;

- (void)playStop;

@end
