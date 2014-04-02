//
//  WLARecorderPressView.m
//  ZSAudioCommunication
//
//  Created by 赵帅 on 14-4-2.
//  Copyright (c) 2014年 com.Bayonetta. All rights reserved.
//

#import "WLARecorderPressView.h"
#import "WLAVolumeDisplayView.h"
#import "WLAAudioController.h"
#import "WLARecorder.h"


@interface WLARecorderPressView ()

@property (nonatomic) BOOL hasSeted;

@property (nonatomic) BOOL isOutSide;

@property (nonatomic) BOOL isRecording;

@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, strong) WLAVolumeDisplayView *volumeView;

@property (nonatomic, weak) MBProgressHUD *hud;

@property (nonatomic, weak) NSTimer *levelsTimer;

@property (nonatomic, strong) WLARecorder *recorder;

@end

@implementation WLARecorderPressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setup:(UIView *)parentView {
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    gestureRecognizer.minimumPressDuration = 0.3f;
    [self addGestureRecognizer:gestureRecognizer];
    self.parentView = parentView;
    
    WLAVolumeDisplayView *volumeView = [[WLAVolumeDisplayView alloc]initWithMaskImage:[UIImage imageNamed:@"RecordingBkg"]];
    self.volumeView = volumeView;
    
    self.recorder = [[WLARecorder alloc] initWithAudioController:[WLAAudioController sharedInstance]];
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    CGPoint locationPoint = [recognizer locationInView:self];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if ([self.recorderDelegate respondsToSelector:@selector(pressBegan)]) {
                [self.recorderDelegate pressBegan];
            }
            
            self.isRecording = YES;
            NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
            [dateformat setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [dateformat stringFromDate:[NSDate date]];
            self.recorder.audioFileName  = dateString;
            self.recorder.documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            [self.recorder recordBegin];
            
            self.backgroundColor = [UIColor redColor];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentView animated:YES];
            hud.square = YES;
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = self.volumeView;
            hud.labelText = @"Recording...";
            self.hud = hud;
            self.levelsTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLevels:) userInfo:nil repeats:YES];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            if (!self.hasSeted) {
                if ([self.recorderDelegate respondsToSelector:@selector(pressMove)]) {
                    [self.recorderDelegate pressMove];
                }
                self.hasSeted = YES;
            }
            
            if (CGRectContainsPoint(self.bounds, locationPoint)) {
                if (self.isOutSide) {
                    self.hud.customView = self.volumeView;
                    self.hud.labelText = @"Recording...";
                    self.isOutSide = NO;
                }
                
            } else {
                
                if (!self.isOutSide) {
                    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordCancel"]];
                    self.hud.labelText = @"delete...";
                    self.isOutSide = YES;
                }
            }
            
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            if ([self.recorderDelegate respondsToSelector:@selector(pressEnd)]) {
                [self.recorderDelegate pressEnd];
            }
            self.backgroundColor = [UIColor greenColor];
            self.isRecording = NO;
            
            if (self.isOutSide) {
                [self.recorder recordStop];
                
            } else {
                [self.recorder recordEnd];
            }
            [self.levelsTimer invalidate];
            [MBProgressHUD hideAllHUDsForView:self.parentView animated:YES];
            break;
        }
            
        default:
            break;
    }
}


- (void)updateLevels:(NSTimer *)timer {
    Float32 avgPower;
    [[WLAAudioController sharedInstance] inputAveragePowerLevel:&avgPower peakHoldLevel:nil ];
    
    CGFloat level = 0;
    if (avgPower >= -35 && avgPower < -30)
        level = 0.1f;
    else if (avgPower >= -30 && avgPower < -25)
        level = 0.2f;
    else if (avgPower >= -25 && avgPower < -20)
        level = 0.3f;
    else if (avgPower >= -20 && avgPower < -15)
        level = 0.4f;
    else if (avgPower >= -15 && avgPower < -10)
        level = 0.5f;
    else if (avgPower >= -10 && avgPower < -5)
        level = 0.6f;
    else if (avgPower >= -5 && avgPower < 0)
        level = 0.7f;
    else if (avgPower >= 0 && avgPower < 5)
        level = 0.8f;
    else if (avgPower >= 5 && avgPower < 10)
        level = 0.9f;
    else
        level = 1.0f;
    
    [self.volumeView setProgress:level animated:NO];
}



- (void)dealloc {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:recognizer];
    }
    
    if (self.isRecording) {
        [self.recorder recordStop];
    }
}
@end
