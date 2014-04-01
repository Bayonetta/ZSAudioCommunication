//
//  WLARecorder.m
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "WLARecorder.h"
#import "AERecorder.h"

@interface WLARecorder ()

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AERecorder *recorder;

@end


@implementation WLARecorder

- (instancetype)initWithAudioController:(AEAudioController *)audioController {
    self = [super init];
    if (self) {
        self.audioController = audioController;
    }
    return self;
}

- (void)recordBegin {
    
    NSError *error = nil;
    NSString *filePath = [self waveFilePath];
    
    if (!self.recorder) {
        self.recorder = [[AERecorder alloc] initWithAudioController:self.audioController];
    }
    
    if ( ![self.recorder beginRecordingToFileAtPath:filePath
                                           fileType:kAudioFileWAVEType
                                              error:&error] ) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start record: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        return;
    }
    [self.audioController addInputReceiver:self.recorder];
    [self.audioController addOutputReceiver:self.recorder];
}

- (void)recordEnd {
    [self.recorder finishRecording];
    [self.audioController removeInputReceiver:self.recorder];
    [self.audioController removeOutputReceiver:self.recorder];
}

- (void)recordStop {
    [self recordEnd];
    
    NSString *filePath = [self waveFilePath];
    if ([[[NSFileManager alloc]init] fileExistsAtPath:filePath]) {
        [[[NSFileManager alloc]init] removeItemAtPath:filePath error:nil];
    }
}

- (void)averagePowerLevel:(Float32 *)avgPower {
    [self.audioController inputAveragePowerLevel:avgPower peakHoldLevel:nil];
}


- (NSString *)waveFilePath{
    return [[NSTemporaryDirectory() stringByAppendingPathComponent:self.audioFileName] stringByAppendingPathExtension:@"wav"];
}

- (NSString *)amrFilePath{
    return [[self.documentPath stringByAppendingPathComponent:self.audioFileName] stringByAppendingPathExtension:@"amr"];
}


@end
