//
//  SJWarningAnimatedView.m
//  SJAlertView
//
//  Created by king on 2017/4/27.
//  Copyright © 2017年 king. All rights reserved.
//

#import "SJWarningAnimatedView.h"
#import "AnimatableView.h"
#import "SJMacro.h"

@interface SJWarningAnimatedView ()<AnimatableView>
@property (nonatomic, strong) CAShapeLayer *outlineLayer;
@property (nonatomic, strong) UIBezierPath *outlinePath;
@end

@implementation SJWarningAnimatedView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self comminit];
    }
    return self;
}
- (void)comminit {
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setupLayers {
    self.outlineLayer.path = self.outlinePath.CGPath;
    self.outlineLayer.fillColor = [UIColor clearColor].CGColor;
    self.outlineLayer.strokeColor = ColorFromRGB(0xF8D486).CGColor;
    self.outlineLayer.lineCap = kCALineCapRound;
    self.outlineLayer.lineWidth = 4;
    self.outlineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.outlineLayer.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [self.layer addSublayer:self.outlineLayer];
}
- (void)animate {
    
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    colorAnimation.duration = 1.0;
    colorAnimation.repeatCount = HUGE;
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    colorAnimation.autoreverses = YES;
    colorAnimation.fromValue = (__bridge id _Nullable)ColorFromRGB(0xF2A665).CGColor;
    colorAnimation.toValue = (__bridge id _Nullable)ColorFromRGB(0xF2A665).CGColor;
    [self.outlineLayer addAnimation:colorAnimation forKey:@"strokeColor"];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupLayers];
}
#pragma mark -lazy
- (CAShapeLayer *)outlineLayer {
    if (!_outlineLayer) {
        _outlineLayer = [CAShapeLayer layer];
    }
    return _outlineLayer;
}
- (UIBezierPath *)outlinePath {
    if (!_outlinePath) {
        _outlinePath = [UIBezierPath bezierPath];
        CGFloat startAngle = 0.0 / 180.0 * M_PI;
        CGFloat endAngle = 360.0 / 180.0 * M_PI;
        CGPoint point = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        CGFloat radius = self.frame.size.width * 0.5;
        [_outlinePath addArcWithCenter:point radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
        
        CGFloat w = self.frame.size.width;
        CGFloat factor = self.frame.size.width / 1.5;
        [_outlinePath moveToPoint:CGPointMake(w * 0.5, 15.0)];
        [_outlinePath addLineToPoint:CGPointMake(w * 0.5, factor)];
        [_outlinePath moveToPoint:CGPointMake(w * 0.5, factor + 10.0)];
        [_outlinePath addArcWithCenter:CGPointMake(w * 0.5, factor + 10.0) radius:1.0 startAngle:startAngle endAngle:endAngle clockwise:YES];
    }
    return _outlinePath;
}

@end
