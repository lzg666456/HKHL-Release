//
//  LoginController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "LoginController.h"
#import "HomeController.h"
#import "AppDelegate.h"
#import "Utility.h"

@interface LoginController ()<UITextFieldDelegate>

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userName.placeholder = @"手机号 ";
    _userName.delegate = self;
    _userName.keyboardType = UIKeyboardTypeNumberPad;
    _password.placeholder = @"请输入登录密码";
    _password.delegate = self;
    _password.secureTextEntry = YES;
    longInButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.454f blue:0.999f alpha:1.00f];
    
    NSString *isremeber = [[NSUserDefaults standardUserDefaults] objectForKey:@"isRemeber"];
    if ([isremeber integerValue] == 1) {
        _userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        _password.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
        remeberButton.selected = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)loginButton:(id)sender {
    NSDictionary *params = @{@"phone":_userName.text,@"pwd":_password.text};
    [SVProgressHUD showWithStatus:@""];
    [DataService requestURL:@"http://hk.zgcainiao.cn/index.php/admin/api/promulgatorLogin" httpMethod:@"POST" timeout:30 params:params responseSerializer:nil completion:^(id result, NSError *error) {
        if ([result[@"err"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            NSDictionary *dic = result[@"promulgator"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:selfMSGKey];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"avatar"] forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:_userName.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:@"pwd"];
            HomeController *HVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeController"];
            [self.navigationController pushViewController:HVC animated:YES];
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
        }
    }];


}

- (IBAction)rememberPassword:(UIButton *)sender {
    remeberButton.selected = !remeberButton.selected;
    if (remeberButton.selected == YES) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isRemeber"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isRemeber"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _userName) {
        if (![Utility isValidateMobile:_userName.text]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码错误"];
        }
    }
    else if (textField == _password) {
        if ((textField.text).length < 6) {
            [SVProgressHUD showErrorWithStatus:@"密码位数过少"];
        }
    }
}
@end
