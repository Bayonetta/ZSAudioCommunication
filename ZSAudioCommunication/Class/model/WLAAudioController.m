//
//  WLAAudioController.m
//  test
//
//  Created by 赵帅 on 14-3-25.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "WLAAudioController.h"
#import "AERecorder.h"


@interface WLAAudioController ()

@end

@implementation WLAAudioController

#pragma mark - init

+ (AEAudioController *)sharedInstance {
    static AEAudioController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AudioStreamBasicDescription des = [AEAudioController nonInterleaved16BitStereoAudioDescription];
        des.mChannelsPerFrame = 1;
        des.mSampleRate = 8000;
        AEAudioController *audioController = [[AEAudioController alloc] initWithAudioDescription:des inputEnabled:YES];
        audioController.preferredBufferDuration = 0.005;
        [audioController start:nil];
        _sharedInstance = audioController;
    });
    return _sharedInstance;
}


+ (void)checkRecordPremission{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"未开启麦克风权限，请去设置界面调整"
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil] show];
            }
        }];
    }
}

@end
