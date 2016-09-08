//
//  shareAnimationView.h
//  WZShareAnimation
//
//  Created by wangzixiao on 16/6/24.
//  Copyright © 2016年 WangZiXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickShareButtonBlock)(NSInteger tag);
@interface shareAnimationView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray didShareButtonBlock:(ClickShareButtonBlock)index;

- (void)show;
@end
