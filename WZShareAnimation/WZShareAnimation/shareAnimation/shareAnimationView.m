//
//  shareAnimationView.m
//  WZShareAnimation
//
//  Created by wangzixiao on 16/6/24.
//  Copyright © 2016年 WangZiXiao. All rights reserved.
//
#import "shareAnimationView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
static NSInteger const buttonTag = 1000;

@interface shareAnimationView ()

@property(nonatomic,strong) NSArray *imageArray;
@property(nonatomic,strong) NSMutableArray *buttonArray;
@property(nonatomic,strong) UIVisualEffectView *backView;
@property(nonatomic,strong) ClickShareButtonBlock btnBlock;
@end
@implementation shareAnimationView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray didShareButtonBlock:(ClickShareButtonBlock)index{
    if (self = [super initWithFrame:frame]) {
        _imageArray = imageArray;
        self.btnBlock =index;
        [self stupView];
    }
    return self;
}

- (void)stupView{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _backView = [[UIVisualEffectView alloc]initWithEffect:blur];
    _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:_backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
    [_backView addGestureRecognizer:tap];
    
    UIView *circle = [[UIView alloc]init];
    circle.bounds   = CGRectMake(0, 0, 220, 220);
    circle.center  = self.center;
    circle.layer.cornerRadius = circle.frame.size.width/2;
    circle.clipsToBounds = YES;
    [self addSubview:circle];
    
    _buttonArray = [NSMutableArray array];
    for (int i = 0; i <_imageArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds              = CGRectMake(0, 0, 48, 48);
        btn.center             = self.center;
        btn.layer.cornerRadius = btn.frame.size.width/2;
        btn.clipsToBounds      = YES;
        btn.tag                = buttonTag+i;
        btn.alpha              = 0;
        [btn setImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_buttonArray addObject:btn];
        
    }
}

-(void)show{
    NSArray *winArr = [UIApplication sharedApplication].windows;
    UIWindow *window = winArr[0];
    [window addSubview:self];
    
    CGPoint center  = self.center;
    CGFloat centerX = center.x;
    CGFloat centerY = center.y;
    NSInteger padding = 70; //半径长度
    CGFloat degrees = 360 / (_buttonArray.count);//角度间隔
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        for (int i = 0; i<_buttonArray.count; i++) {
            UIButton *btn = _buttonArray[i];
            
            btn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
            btn.alpha = 0;
            
        [UIView animateWithDuration:0.3 delay:0.2*i usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
            CGFloat x  = sinf((degrees * i *M_PI) /180) *padding;
            CGFloat y  = cosf((degrees * i *M_PI) /180) *padding;
            CGPoint center    = CGPointMake(centerX +x, centerY -y);
            btn.center    = center;
            btn.transform = transform;
            btn.alpha     = 1;
        } completion:^(BOOL finished) {
            
        }];
        }
    }];
    
}

- (void)hidden{
    [self viewHiddenAnimation:NO buttonTag:-1];
}

- (void)clickButton:(UIButton *)btn{
    [self viewHiddenAnimation:YES buttonTag:btn.tag];
}

- (void)viewHiddenAnimation:(BOOL)isAnimation buttonTag:(NSInteger)tag{
    CGPoint center = self.center;
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
    for (int i = 0; i <_buttonArray.count; i++) {
        UIButton *btn = _buttonArray[i];
        [UIView animateWithDuration:0.3 delay:0.1*i usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.center    = center;
            btn.transform = transform;
            btn.alpha     = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
              if (i == _imageArray.count-1) {
                [self removeFromSuperview];
                if (isAnimation) {
                    if (self.btnBlock) {
                        self.btnBlock (tag - buttonTag);
                    }
                    
                }
              }
            }];
            
        }];
    }
}


@end
