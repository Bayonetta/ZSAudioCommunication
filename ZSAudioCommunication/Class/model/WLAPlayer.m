//
//  WLAPlayer.m
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "WLAPlayer.h"

@interface WLAPlayer ()

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AEAudioFilePlayer *player;

@end


@implementation WLAPlayer


- (instancetype)initWithAudioController:(AEAudioController *)audioController {
    self = [super init];
    if (self) {
        self.audioController = audioController;
    }
    return self;
}

- (void)playBegin {
    
    NSError *error = nil;
    
    self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:[self waveFilePath]] audioController:self.audioController error:&error];
    if (!self.player) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    self.player.removeUponFinish = YES;
    [self.audioController addChannels:[NSArray arrayWithObject:self.player]];
    
    typeof(self) __weak weakSelf = self;
    if (self.playCompletionBlock) {
        self.player.completionBlock = ^{
            weakSelf.playCompletionBlock();
        };
    }
    
}

- (void)playStop {
    [self.audioController removeChannels:[NSArray arrayWithObject:self.player]];
}

- (NSString *)waveFilePath{
    return [[NSTemporaryDirectory() stringByAppendingPathComponent:self.audioFileName] stringByAppendingPathExtension:@"wav"];
}

- (NSString *)amrFilePath{
    return [[self.documentPath stringByAppendingPathComponent:self.audioFileName] stringByAppendingPathExtension:@"amr"];
}

@end
