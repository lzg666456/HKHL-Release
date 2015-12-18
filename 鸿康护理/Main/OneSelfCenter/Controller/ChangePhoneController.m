//
//  ChangePhoneController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/12/2.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ChangePhoneController.h"
#import "Utility.h"
@interface ChangePhoneController () {
    UITextField *pwdText;
    UITextField *newPhoneText;
    UITextField *testNumberText;
    UIButton *changeButton;
    NSInteger testNum;
    NSTimer *aTimer;
    NSInteger time;
    NSDictionary *infoDic;
}

@end

@implementation ChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号码";
    self.view.backgroundColor = [UIColor colorWithRed:0.933f green:0.933f blue:0.933f alpha:1.00f];
    
    infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];;
    
    time = 60;
    pwdText = [[UITextField alloc]init];
    pwdText.placeholder = @"      输入密码";
    pwdText.frame = CGRectMake(20, 10, self.view.width-40, 50);
    pwdText.backgroundColor = [UIColor whiteColor];
    pwdText.secureTextEntry = YES;
    [self.view addSubview:pwdText];
    
    
    newPhoneText = [[UITextField alloc]init];
    newPhoneText.placeholder = @"      新手机号";
    newPhoneText.keyboardType = UIKeyboardTypeNumberPad;
    newPhoneText.backgroundColor = [UIColor whiteColor];
    newPhoneText.frame = CGRectMake(20, pwdText.bottom+10, self.view.width-140, 50);
    [self.view addSubview:newPhoneText];
    
    UIButton *getTestNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    getTestNumber.frame = CGRectMake(newPhoneText.right+10, pwdText.bottom+10, 80, 50);
    getTestNumber.titleLabel.font = [UIFont systemFontOfSize:15];
    [getTestNumber setBackgroundImage:[UIImage imageNamed:@"验证码按钮底_xhdpi"] forState:UIControlStateNormal];
    getTestNumber.titleLabel.numberOfLines = 2;
    [getTestNumber setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [getTestNumber setTitleColor:[UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f] forState:UIControlStateNormal];
    [getTestNumber setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [getTestNumber setTitle:@"(60)点击获取验证码" forState:UIControlStateSelected];
    [getTestNumber addTarget:self action:@selector(getTestNumberClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getTestNumber];
    
    testNumberText = [[UITextField alloc]init];
    testNumberText.backgroundColor = [UIColor whiteColor];
    testNumberText.placeholder = @"      输入验证码";
    testNumberText.keyboardType = UIKeyboardTypeNumberPad;
    testNumberText.frame = CGRectMake(20, newPhoneText.bottom+10, self.view.width-40, 50);
    [self.view addSubview:testNumberText];
    
    changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame = CGRectMake(20, testNumberText.bottom + 10, self.view.width-40, 40);
    [changeButton setTitle:@"确认修改" forState:UIControlStateNormal];
    changeButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changePhoneSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
}


- (void)getTestNumberClick:(UIButton *)button {
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    if ([password isEqualToString:pwdText.text]) {
        if ([Utility isValidateMobile:newPhoneText.text] && ![newPhoneText.text isEqualToString:infoDic[@"phone"]]) {
        button.selected = YES;
        [DataService requestURL:[NSString stringWithFormat:@"%@getVcode",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"phone":newPhoneText.text} responseSerializer:nil completion:^(id result, NSError *error) {
            if ([result[@"err"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
                testNum = [result[@"vcode"] integerValue];
            }
        }];
        aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange:) userInfo:button repeats:YES];
        button.userInteractionEnabled = NO;
        }
        else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号且不能与原手机号相同"];
        }
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"密码错误"];
    }
}

- (void)timeChange:(NSTimer *)timer {
    time --;
    UIButton *button = timer.userInfo;
    [button setTitle:[NSString stringWithFormat:@"%lds后重新获取",(long)time] forState:UIControlStateSelected];
    if (time == 0) {
        time = 60;
        [timer invalidate];
        button.selected = NO;
        button.userInteractionEnabled = YES;
    }
}

- (void)changePhoneSure {
    if ([testNumberText.text integerValue] == testNum) {
        [DataService requestURL:[NSString stringWithFormat:@"%@modPromulgatorInfo",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":infoDic[@"promulgator_id"],@"phone":newPhoneText.text} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:changePhoneNoticifition object:nil userInfo:@{@"newPhone":newPhoneText.text}];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }
        }];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
    }
}


@end
