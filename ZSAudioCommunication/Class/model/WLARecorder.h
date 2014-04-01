//
//  WLARecorder.h
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLARecorder : NSObject

@property (nonatomic, copy) NSString *audioFileName;

@property (nonatomic, copy) NSString *documentPath;

- (instancetype)initWithAudioController:(AEAudioController *)audioController;

- (void)recordBegin;

- (void)recordEnd;

- (void)recordStop;

@end
