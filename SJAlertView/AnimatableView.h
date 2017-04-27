//
//  AnimatableView.h
//  SJAlertView
//
//  Created by king on 2017/4/27.
//  Copyright © 2017年 king. All rights reserved.
//

#ifndef AnimatableView_h
#define AnimatableView_h

#import <UIKit/UIKit.h>

@protocol AnimatableView <NSObject>

@required
- (void)animate;
@end

#endif /* AnimatableView_h */
