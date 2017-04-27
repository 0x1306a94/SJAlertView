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
/** 利用block 的特性 保证当前弹框不被释放 */
@property (nonatomic, strong) id(^strongSelf)();
@property (nonatomic, strong) void(^action)(BOOL isOtherButtonClick);
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabelView;
@property (nonatomic, strong) UITextView *subTitleTextView;
@property (nonatomic, strong) UIView<AnimatableView> *animatedView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
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
    self.subTitleTextView = [[UITextView alloc] init];
    self.subTitleTextView.textAlignment = NSTextAlignmentCenter;
    self.subTitleTextView.textColor = [UIColor blackColor];
    self.subTitleTextView.font = [UIFont fontWithName:kFontName size:16];
    self.subTitleTextView.editable = NO;
    self.subTitleTextView.scrollEnabled  = NO;
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
    
    
    if (self.subTitleTextView.text.length > 0) {
        CGSize stringSize = [self.subTitleTextView.text boundingRectWithSize:CGSizeMake(w, 0.0)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName : self.subTitleTextView.font}
                                                                     context:nil].size;
        CGFloat textViewHeight = ceil(stringSize.height) + 10.0;
        self.subTitleTextView.frame = CGRectMake(x, y, w, textViewHeight);
        [self.contentView addSubview:self.subTitleTextView];
        y += textViewHeight + kHeightMargin;
    }
    
    
    if (self.buttons && self.buttons.count > 0) {
        NSMutableArray<NSNumber *> *buttonWidths = [NSMutableArray<NSNumber *> array];
        for (UIButton *button in self.buttons) {
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
                UIButton *btn = self.buttons.firstObject;
                CGFloat w = buttonWidths.firstObject.floatValue;
                btn.frame = CGRectMake((kContentWidth - w) * 0.5, y, w, kButtonHeight);
                y += kButtonHeight + kHeightMargin;
                break;
            }
            case 2:
            {
                UIButton *fristBtn = self.buttons.firstObject;
                UIButton *lastBtn = self.buttons.lastObject;
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
            CGRect origFrame = self.subTitleTextView.frame;
            origFrame.size.height = origFrame.size.height - diff;
            self.subTitleTextView.frame = origFrame;
            
            if (self.buttons && self.buttons.count > 0) {
                for (UIButton *btn in self.buttons) {
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
            }];
        }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.buttons || self.buttons.count == 0) {
        [self closeAlert:nil];
    }
}
- (void)closeAlert:(UIButton *)btn {
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self clearAlert];
        // 置空block 保证当前弹框正常释放
        self.strongSelf = nil;
        if (btn && self.action) {
            self.action(btn.tag == 1);
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
}

#pragma mark -public

+ (SJAlertView *)showAlert:(NSString *)title {
    return [self showAlert:title alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlert:(NSString *)title alertStyle:(SJAlertStyle)style {
    return [self showAlert:title subTitle:nil button:@"OK" otherButton:nil alertStyle:style];
}
+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle {
    return [self showAlert:title subTitle:subTitle alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle alertStyle:(SJAlertStyle)style {
    return [self showAlert:title subTitle:subTitle button:@"OK" otherButton:nil alertStyle:style];
}
+ (SJAlertView *)showAlertSubTitle:(NSString *)subTitle {
    return [self showAlertSubTitle:subTitle alertStyle:SJAlertStyleNone];
}
+ (SJAlertView *)showAlertSubTitle:(NSString *)subTitle alertStyle:(SJAlertStyle)style {
    return [self showAlert:nil subTitle:subTitle button:@"OK" otherButton:nil alertStyle:style];
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
    alert.action = action;
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
    alert.subTitleTextView.text = subTitle;
    
    if (buttonTitle || otherButtonTitle) {
        
        alert.buttons = [NSMutableArray<UIButton *> array];
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
            [alert.buttons addObject:button];
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
            [alert.buttons addObject:otherButton];
        }
    }
    
    
    [alert layout];
    [alert animateAlert];
    return alert;
    
}
@end
