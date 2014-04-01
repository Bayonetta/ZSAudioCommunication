//
//  WLAFormatConverter.h
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAFormatConverter : NSObject

+ (BOOL)convertWaveToAmr:(NSString *)wavePath AmrFilePath:(NSString *)amrPath;

+ (BOOL)convertAmrToWave:(NSString *)amrPath WaveFilePath:(NSString *)wavePath;

@end
