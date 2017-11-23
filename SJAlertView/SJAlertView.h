//
//  SJAlertView.h
//  SJAlertView
//
//  Created by king on 2017/4/27.
//  Copyright © 2017年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<SJAlertView/SJAlertView.h>)
FOUNDATION_EXPORT double SJAlertViewVersionNumber;
FOUNDATION_EXPORT const unsigned char SJAlertViewVersionString[];
#endif

typedef NS_ENUM(NSUInteger, SJAlertStyle) {
    SJAlertStyleNone,
    SJAlertStyleSuccess,
    SJAlertStyleError,
    SJAlertStyleWarning
};

@interface SJAlertView : UIViewController  
+ (SJAlertView *)showAlert:(NSString *)title;

+ (SJAlertView *)showAlert:(NSString *)title alertStyle:(SJAlertStyle)style;

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle;

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle alertStyle:(SJAlertStyle)style;

+ (SJAlertView *)showAlertSubTitle:(NSString *)subTitle;

+ (SJAlertView *)showAlertSubTitle:(NSString *)subTitle alertStyle:(SJAlertStyle)style;

+ (SJAlertView *)showAlert:(NSString *)title button:(NSString *)buttonTitle;

+ (SJAlertView *)showAlert:(NSString *)title button:(NSString *)buttonTitle alertStyle:(SJAlertStyle)style;

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle;

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle alertStyle:(SJAlertStyle)style;

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle otherButton:(NSString *)otherButtonTitle;

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle otherButton:(NSString *)otherButtonTitle alertStyle:(SJAlertStyle)style;

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle otherButton:(NSString *)otherButtonTitle alertStyle:(SJAlertStyle)style action:(void(^)(BOOL isOtherButtonClick))action;

+ (SJAlertView *)showAlert:(NSString *)title subTitle:(NSString *)subTitle button:(NSString *)buttonTitle otherButton:(NSString *)otherButtonTitle buttonColor:(UIColor *)buttonColor otherButtonColor:(UIColor *)otherButtonColor alertStyle:(SJAlertStyle)style action:(void(^)(BOOL isOtherButtonClick))action;


/**
 Disappear automatically

 @param delayDuration delayDuration less than zero is invalid
 */
- (void)autoDisappearWithDelayDuration:(NSTimeInterval)delayDuration;
@end
