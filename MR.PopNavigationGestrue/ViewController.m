//
//  ViewController.m
//  MR.PopNavigationGestrue
//
//  Created by mac on 15/12/28.
//  Copyright © 2015年 MR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ %lu", self.title, self.navigationController.viewControllers.count];
    self.view.backgroundColor = [UIColor whiteColor];
    
   // self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.view.frame.size.width - 200)/2, (self.view.frame.size.height - 50)/2, 200, 50);
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn setTitle:[NSString stringWithFormat:@"%@ -- %lu", self.title, self.navigationController.viewControllers.count] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)navigationShouldPopOnBackButton{
    return YES;
}



- (void)pressBtn:(UIButton *)sender
{
    ViewController *vc = [[ViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = self.title;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
