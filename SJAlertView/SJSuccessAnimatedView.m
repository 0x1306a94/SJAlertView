//
//  SJSuccessAnimatedView.m
//  SJAlertView
//
//  Created by king on 2017/4/27.
//  Copyright © 2017年 king. All rights reserved.
//

#import "SJSuccessAnimatedView.h"
#import "AnimatableView.h"

@interface SJSuccessAnimatedView ()<AnimatableView>
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *outlineLayer;
@property (nonatomic, strong) UIBezierPath *circlePath;
@property (nonatomic, strong) UIBezierPath *outlinePath;
@end

@implementation SJSuccessAnimatedView

#pragma mark -init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self comminit];
    }
    return self;
}
- (void)comminit {
    self.backgroundColor = [UIColor clearColor];
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.circleLayer.strokeStart = 0.0;
    self.circleLayer.strokeEnd = 0.0;
    
}

- (void)setupLayers {
    
    self.outlineLayer.position = CGPointMake(0, 0);
    self.outlineLayer.path = self.outlinePath.CGPath;
    self.outlineLayer.fillColor = [UIColor clearColor].CGColor;
    self.outlineLayer.strokeColor = [UIColor colorWithRed:(155.0 / 255.0) green:(216.0 / 255.0) blue:(115.0 / 255.0) alpha:1.0].CGColor;
    self.outlineLayer.lineCap = kCALineCapRound;
    self.outlineLayer.lineWidth = 4;
    self.outlineLayer.opacity = 0.1;
    [self.layer addSublayer:self.outlineLayer];
    
    self.circleLayer.position = CGPointMake(0, 0);
    self.circleLayer.path = self.circlePath.CGPath;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.strokeColor = [UIColor colorWithRed:(155.0 / 255.0) green:(216.0 / 255.0) blue:(115.0 / 255.0) alpha:1.0].CGColor;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.lineWidth = 4;
    self.circleLayer.actions = @{@"strokeStart" : [NSNull null],
                                 @"strokeEnd" : [NSNull null],
                                 @"transform" : [NSNull null]};
    [self.layer addSublayer:self.circleLayer];
    
}

- (void)animate {
    
    CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    CGFloat factor = 0.045;
    strokeEnd.fromValue = @(0.00);
    strokeEnd.toValue = @(0.93);
    strokeEnd.duration = 10.0 * factor;
    strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.6 :0.8 :1.2];
    
    strokeStart.fromValue = @(0.0);
    strokeStart.toValue = @(0.68);
    strokeStart.duration = 7.0 * factor;
    strokeStart.beginTime = CACurrentMediaTime() + 3.0 * factor;
    strokeStart.fillMode = kCAFillModeBackwards;
    strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.6 :0.8 :1.2];
    self.circleLayer.strokeStart = 0.68;
    self.circleLayer.strokeEnd = 0.93;
    [self.circleLayer addAnimation:strokeEnd forKey:@"strokeEnd"];
    [self.circleLayer addAnimation:strokeStart forKey:@"strokeStart"];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupLayers];
}
#pragma mark -lazy
- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
    }
    return _circleLayer;
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
        CGFloat startAngle = 60.0 / 180.0 * M_PI;
        CGFloat endAngle = 200.0 / 180.0 * M_PI;
        CGPoint point = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        CGFloat radius = self.frame.size.width * 0.5;
        [_circlePath addArcWithCenter:point radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
        [_circlePath addLineToPoint:CGPointMake(36.0 - 10.0, 60.0 - 10.0)];
        [_circlePath addLineToPoint:CGPointMake(85.0 - 20, 30.0 - 20.0)];
    }
    return _circlePath;
}
@end
