//
//  SJErrorAnimatedView.m
//  SJAlertView
//
//  Created by king on 2017/4/27.
//  Copyright © 2017年 king. All rights reserved.
//

#import "SJErrorAnimatedView.h"
#import "AnimatableView.h"
#import "SJMacro.h"

@interface SJErrorAnimatedView ()<AnimatableView>
@property (nonatomic, strong) CAShapeLayer *crossPathLayer;
@property (nonatomic, strong) CAShapeLayer *outlineLayer;
@property (nonatomic, strong) UIBezierPath *circlePath;
@property (nonatomic, strong) UIBezierPath *outlinePath;
@end

@implementation SJErrorAnimatedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self comminit];
    }
    return self;
}
- (void)comminit {
    self.backgroundColor = [UIColor whiteColor];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500.0;
    t = CATransform3DRotate(t, ((90.0 * M_PI) / 180.0), 1, 0, 0);
    self.outlineLayer.transform = t;
    self.crossPathLayer.opacity = 0.0;
}

- (void)setupLayers {
    
    CGSize size = self.frame.size;
    self.outlineLayer.path = self.outlinePath.CGPath;
    self.outlineLayer.fillColor = [UIColor clearColor].CGColor;
    self.outlineLayer.strokeColor = ColorFromRGB(0xF27474).CGColor;
    self.outlineLayer.lineCap = kCALineCapRound;
    self.outlineLayer.lineWidth = 4.0;
    self.outlineLayer.frame = CGRectMake(0, 0, size.width, size.height);
    self.outlineLayer.position = CGPointMake(size.width * 0.5, size.height * 0.5);
    [self.layer addSublayer:self.outlineLayer];
    
    self.crossPathLayer.path = self.circlePath.CGPath;
    self.crossPathLayer.fillColor = [UIColor clearColor].CGColor;
    self.crossPathLayer.strokeColor = ColorFromRGB(0xF27474).CGColor;
    self.crossPathLayer.lineCap = kCALineCapRound;
    self.crossPathLayer.lineWidth = 4.0;
    self.crossPathLayer.frame = CGRectMake(0, 0, size.width, size.height);
    self.crossPathLayer.position = CGPointMake(size.width * 0.5, size.height * 0.5);
    [self.layer addSublayer:self.crossPathLayer];
    
}
- (void)animate {
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500.0;
    t = CATransform3DRotate(t, (90.0 * M_PI) / 180.0, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = 1.0 / -500.0;
    t2 = CATransform3DRotate(t2, -M_PI, 1, 0, 0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    animation.fromValue = [NSValue valueWithCATransform3D:t];
    animation.toValue = [NSValue valueWithCATransform3D:t2];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.outlineLayer addAnimation:animation forKey:@"transform"];
    
    CATransform3D scale = CATransform3DIdentity;
    scale = CATransform3DScale(scale, 0.3, 0.3, 0);
    
    CABasicAnimation *crossAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    crossAnimation.duration = 0.3;
    crossAnimation.beginTime = CACurrentMediaTime() + 0.3;
    crossAnimation.fromValue = [NSValue valueWithCATransform3D:scale];
    crossAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.8 :0.7 :2.0];
    crossAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    [self.crossPathLayer addAnimation:crossAnimation forKey:@"scale"];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 0.3;
    fadeInAnimation.beginTime = CACurrentMediaTime() + 0.3;
    fadeInAnimation.fromValue = @(0.3);
    fadeInAnimation.toValue = @(1.0);
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode = kCAFillModeForwards;
    [self.crossPathLayer addAnimation:fadeInAnimation forKey:@"opacity"];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupLayers];
}
#pragma mark -lazy
- (CAShapeLayer *)crossPathLayer {
    if (!_crossPathLayer) {
        _crossPathLayer = [CAShapeLayer layer];
    }
    return _crossPathLayer;
}
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
    }
    return _outlinePath;
}

- (UIBezierPath *)circlePath {
    if (!_circlePath) {
        _circlePath = [UIBezierPath bezierPath];
        CGFloat factor = self.frame.size.width / 5.0;
        CGFloat h = self.frame.size.height;
        [_circlePath moveToPoint:CGPointMake(h * 0.5 - factor, h * 0.5 - factor)];
        [_circlePath addLineToPoint:CGPointMake(h * 0.5 + factor, h * 0.5 + factor)];
        [_circlePath moveToPoint:CGPointMake(h * 0.5 + factor, h * 0.5 - factor)];
        [_circlePath addLineToPoint:CGPointMake(h * 0.5 - factor, h * 0.5 + factor)];
    }
    return _circlePath;
}

@end
