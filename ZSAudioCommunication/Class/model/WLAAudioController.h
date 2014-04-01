//
//  WLAAudioController.h
//  test
//
//  Created by 赵帅 on 14-3-25.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAAudioController : NSObject

+ (AEAudioController *)sharedInstance;

+ (void)checkRecordPremission;

@end