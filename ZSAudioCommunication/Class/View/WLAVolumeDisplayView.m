//
//  WLAVolumeDisplayView.m
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "WLAVolumeDisplayView.h"

const static CGFloat animationTime = 0.3f;

@interface WLAVolumeDisplayView ()

@property (nonatomic, readonly) CAGradientLayer *gradientLayer;

@end


@implementation WLAVolumeDisplayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithMaskImage:(UIImage *)maskImage {
    self = [self initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self) {
        [self setMaskView:maskImage];
    }
    return self;
}

- (void)setupView {
    [self setProgress:0.3f];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setColors:@[[UIColor grayColor], [UIColor greenColor]]];
    
    self.gradientLayer.startPoint = CGPointMake(0.5f, 0.0f);
    self.gradientLayer.endPoint   = CGPointMake(0.5f, 1.0f);
}

- (void)setColors:(NSArray *)colors {
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)[color CGColor]];
    }
    self.gradientLayer.colors = cgColors;
}


- (NSArray *)colors {
    NSMutableArray *uiColors = [NSMutableArray arrayWithCapacity:self.gradientLayer.colors.count];
    for (id color in self.gradientLayer.colors) {
        [uiColors addObject:[UIColor colorWithCGColor:(CGColorRef)color]];
    }
    return uiColors;
}


+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)setMaskView:(UIImage *)maskImage {
    CGImageRef cgImageWithAlpha = [maskImage CGImage];
    CALayer *maskingLayer = [CALayer layer];
    maskingLayer.contents = (__bridge id)cgImageWithAlpha;
    
    CALayer *layerToBeMasked = self.layer;
    layerToBeMasked.mask = maskingLayer;
    maskingLayer.frame = layerToBeMasked.bounds;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}


- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    CGFloat normalizedProgress = 1 - MIN(MAX(progress, 0.f), 1.f);
    NSArray* newLocations = @[@(normalizedProgress), @(normalizedProgress)];
    
    if (animated) {
        NSTimeInterval duration = animationTime;
        [UIView animateWithDuration:duration animations:^{
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.duration = duration;
            animation.delegate = self;
            animation.fromValue = self.gradientLayer.locations;
            animation.toValue = newLocations;
            [self.gradientLayer addAnimation:animation forKey:@"animateLocations"];
        }];
    } else {
        [self.gradientLayer setNeedsDisplay];
    }
    
    self.gradientLayer.locations = newLocations;
}

@end
