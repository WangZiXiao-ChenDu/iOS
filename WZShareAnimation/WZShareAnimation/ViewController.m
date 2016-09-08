//
//  ViewController.m
//  WZShareAnimation
//
//  Created by wangzixiao on 16/6/24.
//  Copyright © 2016年 WangZiXiao. All rights reserved.
//

#import "ViewController.h"
#import "shareAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"123"].CGImage);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor cyanColor];
    btn.bounds           = CGRectMake(0, 0, 60, 60);
    btn.center           = self.view.center;
    btn.layer.cornerRadius = 30;
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)click{
    NSArray *arr = @[@"wechat",@"friendquan",@"qqzone"];
    shareAnimationView *share = [[shareAnimationView alloc]initWithFrame:self.view.frame imageArray:arr didShareButtonBlock:^(NSInteger tag) {
        NSLog(@"____%ld",tag);
    }];
    [share show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
