//
//  FormalReViewController.m
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "RecordViewController.h"
#import "WLAAudioController.h"
#import "WLARecorderPressView.h"

@interface RecordViewController () <WLARecorderDelegate>

@property (weak, nonatomic) IBOutlet WLARecorderPressView *recorderView;

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WLAAudioController checkRecordPremission];
    [self.recorderView setup:self.view];
    self.recorderView.recorderDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pressBegan {
    NSLog(@"begin");
}

- (void)pressMove {
    NSLog(@"move");
}

- (void)pressEnd {
    NSLog(@"end");
}

@end
