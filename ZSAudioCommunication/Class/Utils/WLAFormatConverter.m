//
//  WLAFormatConverter.m
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "WLAFormatConverter.h"
#import "wav.hpp"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@implementation WLAFormatConverter

+ (BOOL)convertWaveToAmr:(NSString *)wavePath AmrFilePath:(NSString *)amrPath {
    
    return EncodeWAVEFileToAMRFile([wavePath cStringUsingEncoding:NSASCIIStringEncoding], [amrPath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16);
}


+ (BOOL)convertAmrToWave:(NSString *)amrPath WaveFilePath:(NSString *)wavePath {

    return DecodeAMRFileToWAVEFile([amrPath cStringUsingEncoding:NSASCIIStringEncoding], [wavePath cStringUsingEncoding:NSASCIIStringEncoding]);
}


@end
