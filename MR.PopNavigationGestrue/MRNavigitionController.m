//
//  MRNavigitionController.m
//  MR.PopNavigationGestrue
//
//  Created by mac on 15/12/28.
//  Copyright © 2015年 MR. All rights reserved.


#import "MRNavigitionController.h"

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow
#define xOff [UIApplication sharedApplication].keyWindow.frame.size.width
#define TOP_VIEW   [UIApplication sharedApplication].keyWindow.rootViewController.view

@interface MRNavigitionController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *lastScreenShotView;
@property (nonatomic, strong) UIView *blackMask;

@property (nonatomic, strong) NSMutableArray *screenShotStack;
@property (nonatomic, assign) CGPoint locatorPoint;
@property (nonatomic, assign) BOOL isMoving;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) float time;

@end

@implementation MRNavigitionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotStack = [NSMutableArray array];
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            [self.view removeGestureRecognizer:self.interactivePopGestureRecognizer];
            
            UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestruerRecognize:)];
            recognizer.delegate = self;
            [recognizer delaysTouchesBegan];
            [self.view addGestureRecognizer:recognizer];
        }
    }
    return self;
}

- (UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(TOP_VIEW.bounds.size, TOP_VIEW.opaque, 0.0);
    [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIImage *captureImage = [self capture];
    if (captureImage) {
        [self.screenShotStack addObject:captureImage];
    }
    
    if (self.viewControllers.count  >= 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 80, 44);
        [btn setImage:[UIImage imageNamed:@"ic_navigate_before_white_36dp"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 40)];
        [btn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.screenShotStack removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Action - Target 
- (void)panGestruerRecognize:(UIPanGestureRecognizer *)recognizer {
    if (self.viewControllers.count <= 1) return;
    //get pan gestrue position at the window's coordinate
    CGPoint touchPoint = [recognizer locationInView:KEY_WINDOW];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        _locatorPoint = touchPoint;
        
        if (!self.backgroundView) {
            CGRect frame = TOP_VIEW.frame;
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
            
            _blackMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            _blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:_blackMask];
        }

        self.backgroundView.hidden = NO;
        if (_lastScreenShotView) {
            [_lastScreenShotView removeFromSuperview];
        }
        
        UIImage *lastScreenShot = [self.screenShotStack lastObject];
        _lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:_lastScreenShotView belowSubview:_blackMask];
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (touchPoint.x - _locatorPoint.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:xOff];
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                CGRect frame = TOP_VIEW.frame;
                frame.origin.x = 0;
                TOP_VIEW.frame = frame;
                
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving= NO;
                self.backgroundView.hidden = YES;
            }];
        }
        return;
    }else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - _locatorPoint.x];
    }
}

- (void)popViewController {
    [UIView animateWithDuration:0.3 animations:^{
        if (!self.backgroundView) {
            CGRect frame = TOP_VIEW.frame;
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
            
            _blackMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            _blackMask.backgroundColor = [UIColor purpleColor];
            [self.backgroundView addSubview:_blackMask];
        }
        
        self.backgroundView.hidden = NO;
        if (_lastScreenShotView) {
            [_lastScreenShotView removeFromSuperview];
        }
        
        UIImage *lastScreenShot = [self.screenShotStack lastObject];
        _lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:_lastScreenShotView belowSubview:_blackMask];

        _time = 0;
        _timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(backAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    } completion:^(BOOL finished) {
    }];
}

- (void)backAnimation {
    _time += 1;
    [self moveViewWithX:xOff/6 * _time];
    
    if (_time == 6) {
        [self popViewControllerAnimated:NO];
        CGRect frame = TOP_VIEW.frame;
        frame.origin.x = 0;
        TOP_VIEW.frame = frame;
        self.backgroundView.hidden = YES;
        [_timer invalidate];
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_timer invalidate];
//    });
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    x = x>xOff? xOff:x;
    x = x<0? 0:x;

    CGRect frame = TOP_VIEW.frame;
    frame.origin.x = x;
    TOP_VIEW.frame = frame;
    
    float scale = x/xOff * 0.05 + 0.95;
    float alpha = 0.4 - x/xOff*0.4;
    
    if (self.transformStyle == horizTranform) {
        //horizontally transform
        _lastScreenShotView.transform = CGAffineTransformMakeTranslation(-xOff/2+ x/2, 0);
    }else if (self.transformStyle == scaleTransform) {
        //scale transform
         _lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    }
    _blackMask.alpha = alpha;
 }

@end




























