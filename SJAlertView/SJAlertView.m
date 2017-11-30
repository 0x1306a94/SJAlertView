//
//  SJAlertView.m
//  SJAlertView
//
//  Created by king on 2017/4/27.
//  Copyright © 2017年 king. All rights reserved.
//

#import "SJAlertView.h"
#import "AnimatableView.h"
#import "SJSuccessAnimatedView.h"
#import "SJErrorAnimatedView.h"
#import "SJWarningAnimatedView.h"
#import "SJMacro.h"

static CGFloat const kAnimatedViewHeight      = 70.0;
static CGFloat const kHeightMargin            = 10.0;
static CGFloat const kWidthMargin             = 10.0;
static CGFloat const kMaxHeight               = 300.0;
static CGFloat const kContentWidth            = 300.0;
static CGFloat const kButtonHeight            = 35.0;
static CGFloat const kTitleHeight             = 30.0;
static CGFloat const KTopMargin               = 20.0;
static CGFloat const kButtonMaxWidth          = 135.0;
static NSString *const kFontName              = @"Helvetica";

@interface SJAlertView ()
@property (nonatomic, strong) id(^strongSelf)();
@property (nonatomic, copy) void(^action)(BOOL isOtherButtonClick);
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabelView;
@property (nonatomic, strong) UILabel *subTitleView;
@property (nonatomic, strong) UIView<AnimatableView> *animatedView;
@property (nonatomic, strong) NSMutableArray<NSValue *> *buttons;

@property (nonatomic, assign) NSTimeInterval delayDuration;
@end

@implementation SJAlertView
- (void)dealloc {
#if DEBUG
    NSLog(@"[SJAlertView dealloc]");
#endif
}
#pragma mark -init
- (instancetype)init {
    if (self == [super init]) {
        
        self.view.frame = [UIScreen mainScreen].bounds;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-retain-cycles"
        // The use of block features to ensure that the current box object is not released during the show
        self.strongSelf = ^id{
            return self;
        };
#pragma clang diagnostic pop
        [self comminit];
    }
    return self;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layout];
}
#pragma mark -lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius= 5;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
- (void)setupTitleLabel {
    self.titleLabelView = [[UILabel alloc] init];
    self.titleLabelView.numberOfLines = 1;
    self.titleLabelView.font = [UIFont fontWithName:kFontName size:25];
    self.titleLabelView.textColor = [UIColor blackColor];
    self.titleLabelView.textAlignment = NSTextAlignmentCenter;
}
- (void)setupSubTitleTextView {
    self.subTitleView = [[UILabel alloc] init];
    self.subTitleView.numberOfLines = 0;
    self.subTitleView.textAlignment = NSTextAlignmentCenter;
    self.subTitleView.textColor = [UIColor blackColor];
    self.subTitleView.font = [UIFont fontWithName:kFontName size:16];
}

- (void)comminit {
    
    [self.view addSubview:self.contentView];
}

- (void)layout {
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    self.view.frame = [UIScreen mainScreen].bounds;
    
    CGFloat x = kWidthMargin;
    CGFloat y = KTopMargin;
    CGFloat w = kContentWidth - (kWidthMargin * 2);
    if (self.animatedView) {
        self.animatedView.frame = CGRectMake((kContentWidth - kAnimatedViewHeight) * 0.5, y, kAnimatedViewHeight, kAnimatedViewHeight);
        [self.contentView addSubview:self.animatedView];
        y += kAnimatedViewHeight + kHeightMargin;
    }
    
    if (self.titleLabelView.text.length > 0) {
        self.titleLabelView.frame = CGRectMake(x, y, w, kTitleHeight);
        [self.contentView addSubview:self.titleLabelView];
        y += kTitleHeight + kHeightMargin;
    }
    
    
    if (self.subTitleView.text.length > 0) {
        CGSize stringSize = [self.subTitleView sizeThatFits:CGSizeMake(w, CGFLOAT_MAX)];
        CGFloat textViewHeight = ceil(stringSize.height) + 10.0;
        self.subTitleView.frame = CGRectMake(x, y, w, textViewHeight);
        [self.contentView addSubview:self.subTitleView];
        y += textViewHeight + kHeightMargin;
    }
    
    
    if (self.buttons && self.buttons.count > 0) {
        NSMutableArray<NSNumber *> *buttonWidths = [NSMutableArray<NSNumber *> array];
        for (NSValue *value in self.buttons) {
            UIButton *button = (UIButton *)value;
            NSString *str = [button titleForState:UIControlStateNormal];
            CGFloat w = [str boundingRectWithSize:CGSizeMake(135, 0.0)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName : button.titleLabel.font}
                                          context:nil].size.width + 20.0;
            [buttonWidths addObject:[NSNumber numberWithFloat:w]];
        }
        
        
        switch (buttonWidths.count) {
            case 1:
            {
                UIButton *btn = (UIButton *)self.buttons.firstObject.nonretainedObjectValue;
                CGFloat w = buttonWidths.firstObject.floatValue;
                btn.frame = CGRectMake((kContentWidth - w) * 0.5, y, w, kButtonHeight);
                y += kButtonHeight + kHeightMargin;
                break;
            }
            case 2:
            {
                UIButton *fristBtn = (UIButton *)self.buttons.firstObject.nonretainedObjectValue;
                UIButton *lastBtn = (UIButton *)self.buttons.lastObject.nonretainedObjectValue;
                CGFloat firstW = buttonWidths.firstObject.floatValue;
                CGFloat lastW = buttonWidths.lastObject.floatValue;
                
                if (firstW >= kButtonMaxWidth && lastW >= kButtonMaxWidth) {
                    
                    fristBtn.frame = CGRectMake(kWidthMargin, y, kButtonMaxWidth, kButtonHeight);
                    lastBtn.frame = CGRectMake(kWidthMargin + kButtonMaxWidth + kWidthMargin, y, kButtonMaxWidth, kButtonHeight);
                } else {
                    
                    CGFloat x = (kContentWidth - firstW - kWidthMargin - lastW) * 0.5;
                    fristBtn.frame = CGRectMake(x, y, firstW, kButtonHeight);
                    lastBtn.frame  = CGRectMake(x + firstW + kWidthMargin, y, lastW, kButtonHeight);
                }
                y += kButtonHeight + kHeightMargin;
                break;
            }
            default:
                break;
        }
        
        if (y > kMaxHeight) {
            
            CGFloat diff = y - kMaxHeight;
            CGRect origFrame = self.subTitleView.frame;
            origFrame.size.height = origFrame.size.height - diff;
            self.subTitleView.frame = origFrame;
            
            if (self.buttons && self.buttons.count > 0) {
                for (NSValue *value in self.buttons) {
                    UIButton *btn = (UIButton *)value.nonretainedObjectValue;
                    origFrame = btn.frame;
                    origFrame.origin.y = origFrame.origin.y - diff;
                    btn.frame = origFrame;
                }
            }
            
            y = kMaxHeight;
        }
    }
    
    
    self.contentView.frame = CGRectMake((mainSize.width - kContentWidth) * 0.5, (mainSize.height - y) * 0.5, kContentWidth, y);
    self.contentView.clipsToBounds = YES;
}

- (void)animateAlert {
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1.0;
    }];
    
    CGAffineTransform previousTransform = self.contentView.transform;
    self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0);
                if (self.animatedView) {
                    [self.animatedView animate];
                }
            } completion:^(BOOL finished) {
                self.contentView.transform = previousTransform;
                
                if (self.delayDuration > 0.0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self closeAlert:nil];
                    });
                }
            }];
        }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.buttons || self.buttons.count == 0) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:touch.view];
        point = [self.contentView convertPoint:point toView:self.view];
        if (!CGRectContainsPoint(self.contentView.frame, point)) {
            [self closeAlert:nil];
        }
    }
}
- (void)closeAlert:(UIButton *)btn {
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self clearAlert];
        // Empty block to ensure the current frame object normal release
        self.strongSelf = nil;
        if (self.action) {
            self.action(btn.tag == 1);
            self.action = nil;
        }
    }];
}
- (void)clearAlert {
    if (self.animatedView) {
        [self.animatedView removeFromSuperview];
        self.animatedView = nil;
    }
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    [self.buttons removeAllObjects];
    self.buttons = nil;
}

#pragma mark -public

+ (SJAlertView *)showAlert:(NSString *)title {
    return [self showAlert:title alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlert:(NSString *)title alertStyle:(SJAlertStyle)style {
    return [self showAlert:title subTitle:nil button:nil otherButton:nil alertStyle:style];
}
+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle {
    return [self showAlert:title subTitle:subTitle alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle alertStyle:(SJAlertStyle)style {
    return [self showAlert:title subTitle:subTitle button:nil otherButton:nil alertStyle:style];
}
+ (SJAlertView *)showAlertSubTitle:(NSString *)subTitle {
    return [self showAlertSubTitle:subTitle alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlertSubTitle:(NSString *)subTitle alertStyle:(SJAlertStyle)style {
    return [self showAlert:nil subTitle:subTitle button:nil otherButton:nil alertStyle:style];
}
+ (SJAlertView *)showAlert:(NSString *)title button:(NSString *)buttonTitle {
    return [self showAlert:title subTitle:nil button:buttonTitle otherButton:nil alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlert:(NSString *)title button:(NSString *)buttonTitle alertStyle:(SJAlertStyle)style {
    return [self showAlert:title subTitle:nil button:buttonTitle otherButton:nil alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle {
    return [self showAlert:title subTitle:subTitle button:buttonTitle otherButton:nil alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle alertStyle:(SJAlertStyle)style {
    return [self showAlert:title subTitle:subTitle button:buttonTitle otherButton:nil alertStyle:style];
}
+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle otherButton:(NSString *)otherButtonTitle {
    return [self showAlert:title subTitle:subTitle button:buttonTitle otherButton:otherButtonTitle alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle otherButton:(NSString *)otherButtonTitle alertStyle:(SJAlertStyle)style {
    return [self showAlert:title subTitle:subTitle button:buttonTitle otherButton:otherButtonTitle alertStyle:style action:nil];
}

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle otherButton:(NSString *)otherButtonTitle alertStyle:(SJAlertStyle)style action:(void(^)(BOOL isOtherButtonClick))action {
    
    return [self showAlert:title subTitle:subTitle button:buttonTitle otherButton:otherButtonTitle buttonColor:ColorFromRGB(0xD0D0D0) otherButtonColor:ColorFromRGB(0xDD6B55) alertStyle:style action:action];
}

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle otherButton:(NSString *)otherButtonTitle buttonColor:(UIColor *)buttonColor otherButtonColor:(UIColor *)otherButtonColor alertStyle:(SJAlertStyle)style action:(void(^)(BOOL isOtherButtonClick))action {
    
    if (title.length == 0 && subTitle.length == 0) {
        return nil;
    }

    SJAlertView *alert = [[SJAlertView alloc] init];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:alert.view];
    [keyWindow bringSubviewToFront:alert.view];
    alert.view.frame = keyWindow.bounds;
    alert.action = [action copy];
    switch (style) {
        case SJAlertStyleSuccess:
        {
            alert.animatedView = (UIView<AnimatableView> *)[[SJSuccessAnimatedView alloc] init];
            break;
        }
        case SJAlertStyleError:
        {
            alert.animatedView = (UIView<AnimatableView> *)[[SJErrorAnimatedView alloc] init];
            break;
        }
        case SJAlertStyleWarning:
        {
            alert.animatedView = (UIView<AnimatableView> *)[[SJWarningAnimatedView alloc] init];
            break;
        }
        default:
            alert.animatedView = nil;
            break;
    }
    
    [alert setupTitleLabel];
    [alert setupSubTitleTextView];
    alert.titleLabelView.text = title;
    alert.subTitleView.text = subTitle;
    
    if (buttonTitle || otherButtonTitle) {
        
        alert.buttons = [NSMutableArray<NSValue *> array];
        if (buttonTitle.length > 0) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:kFontName size:15];
            button.tag = 0;
            button.backgroundColor = buttonColor;
            button.layer.cornerRadius = 5.0;
            button.layer.masksToBounds = YES;
            [button addTarget:alert action:@selector(closeAlert:) forControlEvents:UIControlEventTouchUpInside];
            [alert.contentView addSubview:button];
            NSValue *value = [NSValue valueWithNonretainedObject:button];
            [alert.buttons addObject:value];
        }
        
        if (otherButtonTitle.length > 0) {
            UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            [otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            otherButton.titleLabel.font = [UIFont fontWithName:kFontName size:15];
            otherButton.tag = 1;
            otherButton.layer.cornerRadius = 5.0;
            otherButton.layer.masksToBounds = YES;
            otherButton.backgroundColor = otherButtonColor;
            [otherButton addTarget:alert action:@selector(closeAlert:) forControlEvents:UIControlEventTouchUpInside];
            [alert.contentView addSubview:otherButton];
            NSValue *value = [NSValue valueWithNonretainedObject:otherButton];
            [alert.buttons addObject:value];
        }
    }
    
    
    [alert layout];
    [alert animateAlert];
    return alert;
    
}
- (void)autoDisappearWithDelayDuration:(NSTimeInterval)delayDuration {
    self.delayDuration = delayDuration;
}
@end
