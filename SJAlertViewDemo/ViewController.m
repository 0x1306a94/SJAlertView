//
//  ViewController.m
//  SJAlertViewDemo
//
//  Created by king on 2017/4/27.
//  Copyright © 2017年 king. All rights reserved.
//

#import "ViewController.h"
@import SJAlertView;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.view.backgroundColor = [UIColor orangeColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click:(id)sender {
    
//    CGSize size = [UIScreen mainScreen].bounds.size;
//    SJSuccessAnimatedView *view = [[SJSuccessAnimatedView alloc] initWithFrame:CGRectMake((size.width - 70) * 0.5, (size.height - 70) * 0.5, 70, 70)];
//    
//    [self.view addSubview:view];
//    [view animate];
    
//    [SJAlertView showAlert:@"Good, King" subTitle:@" 啊控件索卡均富凯爱康科技奥卡福建安费捡垃圾刷卡缴费卡,拉放假啦会计分录马拉加放辣椒开饭啦,卡拉飞机啊浪费空间阿里,楼房吉安路" alertStyle:SJAlertStyleSuccess];
    
    [SJAlertView showAlert:@"Good, King" subTitle:@"拉放假啦会计分录马拉加放辣椒开饭啦,卡拉飞机啊浪费空间阿里,楼房吉安路" button:@"OK" otherButton:@"Good, King" alertStyle:SJAlertStyleSuccess action:^(BOOL b){
        
        [SJAlertView showAlertSubTitle:@"拉放假啦会计分录马拉加放辣椒开饭啦,卡拉飞机啊浪费空间阿里,楼房吉安路拉放假啦会计分录马拉加放辣椒开饭啦,卡拉飞机啊浪费空间阿里,楼房吉安路拉放假啦会计分录马拉加放辣椒开饭啦,卡拉飞机啊浪费空间阿里,楼房吉安路"];
    }];
}


@end
