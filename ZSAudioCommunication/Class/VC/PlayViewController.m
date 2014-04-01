//
//  PlayViewController.m
//  test
//
//  Created by 赵帅 on 14-3-31.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "PlayViewController.h"
#import "WLAPlayer.h"
#import "WLAAudioController.h"
#import "WLAFormatConverter.h"

@interface PlayViewController ()

@property (nonatomic) BOOL isPlay;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) WLAPlayer *player;

@property (weak, nonatomic) IBOutlet UIButton *playOriginButton;

@property (weak, nonatomic) IBOutlet UILabel *wavToAmrLabel;

@property (weak, nonatomic) IBOutlet UIButton *palyConvertButton;

@property (weak, nonatomic) IBOutlet UILabel *amrToWavLabel;

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (id)initWithFilePath:(NSString *)filePath {
    self = [super initWithNibName:NSStringFromClass([PlayViewController class]) bundle:[NSBundle mainBundle]];
    if (self) {
        self.filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    //监听距离传感器状态变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.player = [[WLAPlayer alloc]initWithAudioController:[WLAAudioController sharedInstance]];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isPlay) {
        [self.player playStop];
    }
}

- (IBAction)playOriginAciton:(id)sender {
    self.player.documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.player.audioFileName = [self.filePath stringByDeletingPathExtension];
    
    typeof(self) __weak weakSelf = self;
    if (!self.isPlay) {
        self.player.playCompletionBlock = ^{
            weakSelf.playOriginButton.selected = NO;
            weakSelf.isPlay = NO;
        };
        [self.player playBegin];
        self.playOriginButton.selected = YES;
        self.isPlay = YES;
    }
    else {
        [self.player playStop];
        self.playOriginButton.selected = NO;
        self.isPlay = NO;
    }
}

- (IBAction)wavToAmrAction:(id)sender {
    NSString *originPath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.filePath];
    
    NSString *targetPath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[self.filePath stringByDeletingPathExtension]] stringByAppendingPathExtension:@"amr"];
    
    if ([[[NSFileManager alloc] init] fileExistsAtPath:targetPath]) {
        self.wavToAmrLabel.text = @"已转过";
    } else {
        if ([WLAFormatConverter convertWaveToAmr:originPath AmrFilePath:targetPath]) {
            self.wavToAmrLabel.text = @"成功";
        } else {
            self.wavToAmrLabel.text = @"失败";
        }
    }
}




- (IBAction)amrToWavAction:(id)sender {
    NSString *originPath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[self.filePath stringByDeletingPathExtension]] stringByAppendingPathExtension:@"amr"];
    NSString *targetPath = [[[[NSTemporaryDirectory() stringByAppendingPathComponent:self.filePath] stringByDeletingPathExtension] stringByAppendingString:@"Convert"]stringByAppendingPathExtension:@"wav"];
    
    if ([[[NSFileManager alloc] init] fileExistsAtPath:targetPath]) {
        self.amrToWavLabel.text = @"已转过";
        return;
    } else {
        if ([WLAFormatConverter convertAmrToWave:originPath WaveFilePath:targetPath]) {
            self.amrToWavLabel.text = @"成功";
        } else {
            self.amrToWavLabel.text = @"失败";
        }
    }
}

- (IBAction)playConvertAction:(id)sender {
    NSString *targetPath = [[[[NSTemporaryDirectory() stringByAppendingPathComponent:self.filePath] stringByDeletingPathExtension] stringByAppendingString:@"Convert"]stringByAppendingPathExtension:@"wav"];
    
    if (![[[NSFileManager alloc] init] fileExistsAtPath:targetPath]) return;
    
    self.player.documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.player.audioFileName = [[self.filePath stringByDeletingPathExtension] stringByAppendingString:@"Convert"];
    
    typeof(self) __weak weakSelf = self;
    if (!self.isPlay) {
        self.player.playCompletionBlock = ^{
            weakSelf.palyConvertButton.selected = NO;
            weakSelf.isPlay = NO;
        };
        [self.player playBegin];
        self.palyConvertButton.selected = YES;
        self.isPlay = YES;
    }
    else {
        [self.player playStop];
        self.palyConvertButton.selected = NO;
        self.isPlay = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)sensorStateChange:(NSNotificationCenter *)notification{

    if ([[UIDevice currentDevice] proximityState] == YES) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


@end
