//
//  BaseController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f] ;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
//                                                                    NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _leftButton = [[UIButton alloc]init];
    [_leftButton setImage:[UIImage imageNamed:@"back_xhdpi.png"] forState:UIControlStateNormal];
    _leftButton.frame = CGRectMake(0, 0, 30, 30);
    [_leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
}
- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}


@end
