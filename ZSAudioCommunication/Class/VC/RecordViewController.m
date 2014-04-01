//
//  FormalReViewController.m
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "RecordViewController.h"
#import "WLARecorder.h"
#import "WLAAudioController.h"
#import "WLAVolumeDisplayView.h"

@interface RecordViewController ()

@property (weak, nonatomic) IBOutlet UIView *recorderView;

@property (nonatomic) BOOL isRecording;

@property (nonatomic) BOOL isOutSide;

@property (nonatomic, weak) MBProgressHUD *hud;

@property (nonatomic, strong) WLAVolumeDisplayView *volumeView;

@property (nonatomic, weak) NSTimer *levelsTimer;

@property (nonatomic, strong) WLARecorder *recorder;

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WLAAudioController checkRecordPremission];
    
    self.recorder = [[WLARecorder alloc] initWithAudioController:[WLAAudioController sharedInstance]];
    WLAVolumeDisplayView *volumeView = [[WLAVolumeDisplayView alloc]initWithMaskImage:[UIImage imageNamed:@"RecordingBkg"]];
    self.volumeView = volumeView;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.isRecording) {
        [self.recorder recordStop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.recorderView];
    if (CGRectContainsPoint(self.recorderView.bounds, location)) {
        NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
        [dateformat setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [dateformat stringFromDate:[NSDate date]];
        self.recorder.audioFileName  = dateString;
        self.recorder.documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        self.recorderView.backgroundColor = [UIColor redColor];
        [self.recorder recordBegin];
        self.isRecording = YES;
        self.isOutSide = NO;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.square = YES;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = self.volumeView;
        hud.labelText = @"Recording...";
        self.hud = hud;
        self.levelsTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLevels:) userInfo:nil repeats:YES];
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.recorderView];
    if (self.isRecording) {
        if (!CGRectContainsPoint(self.recorderView.bounds, location)) {
            self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordCancel"]];
            self.hud.labelText = @"delete...";
            self.isOutSide = YES;
        }
        else {
            self.hud.customView = self.volumeView;
            self.hud.labelText = @"Recording...";
            self.isOutSide = NO;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isRecording) {
        if (!self.isOutSide) {
            [self.recorder recordEnd];
//            NSLog(@"end");
        }
        else {
            [self.recorder recordStop];
//            NSLog(@"delete");
        }
        self.recorderView.backgroundColor = [UIColor greenColor];
        self.isRecording = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.levelsTimer invalidate];
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isRecording) {
        [self.recorder recordStop];
        self.recorderView.backgroundColor = [UIColor greenColor];
//        NSLog(@"cancel");
        self.isRecording = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.levelsTimer invalidate];
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

@end
