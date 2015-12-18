//
//  ForgetPassWordController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ForgetPassWordController.h"
#import <SMS_SDK/SMSSDK.h>
#import "revisePassWordController.h"
#import "Utility.h"
@interface ForgetPassWordController ()<UITextFieldDelegate> {
    NSInteger time;
    NSTimer *aTimer;
    UITextField *taskNumber;
    UITextField *_phoneNumberText;
    NSNumber *testNum;
}

@end

@implementation ForgetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor colorWithRed:0.933f green:0.933f blue:0.933f alpha:1.00f];
    
    time = 60;
    _phoneNumberText = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, self.view.width-120, 50)];
    _phoneNumberText.placeholder = @"      输入手机号码";
    _phoneNumberText.delegate = self;
    _phoneNumberText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberText.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_phoneNumberText];
    
    UIButton *getTestNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    getTestNumber.frame = CGRectMake(_phoneNumberText.right+10, 70, 80, 50);
    getTestNumber.titleLabel.font = [UIFont systemFontOfSize:15];
    [getTestNumber setBackgroundImage:[UIImage imageNamed:@"验证码按钮底_xhdpi"] forState:UIControlStateNormal];
    getTestNumber.titleLabel.numberOfLines = 2;
    [getTestNumber setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [getTestNumber setTitleColor:[UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f] forState:UIControlStateNormal];
    [getTestNumber setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [getTestNumber setTitle:@"(60)点击获取验证码" forState:UIControlStateSelected];
    [getTestNumber addTarget:self action:@selector(getTestNumberClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getTestNumber];
    
    taskNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, _phoneNumberText.bottom+10, self.view.width-20, 50)];
    taskNumber.placeholder = @"      请输入验证码";
    taskNumber.keyboardType = UIKeyboardTypeNumberPad;
    taskNumber.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:taskNumber];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(20, taskNumber.bottom+20, self.view.width-40, 50);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f]];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

- (void)getTestNumberClick:(UIButton *)button {
    if ([Utility isValidateMobile:_phoneNumberText.text]) {
        button.selected = YES;
        [DataService requestURL:[NSString stringWithFormat:@"%@getVcode",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"phone":_phoneNumberText.text} responseSerializer:nil completion:^(id result, NSError *error) {
            if ([result[@"err"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
                testNum = result[@"vcode"];
            }
        }];
        aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange:) userInfo:button repeats:YES];
        button.userInteractionEnabled = NO;
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"输入手机号码不正确"];
    }
}

- (void)nextButtonClick {
    NSInteger i = [testNum integerValue];
    if (i == [taskNumber.text integerValue]) {
        [SVProgressHUD showSuccessWithStatus:@"验证成功"];
        revisePassWordController *RPWVC = [self.storyboard instantiateViewControllerWithIdentifier:@"revisePassWordController"];
        RPWVC.phone = _phoneNumberText.text;
        [self.navigationController pushViewController:RPWVC animated:YES];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"验证失败"];
    }
    
}

- (void)timeChange:(NSTimer *)timer {
    time --;
    UIButton *button = timer.userInfo;
    [button setTitle:[NSString stringWithFormat:@"%lds后重新获取",time] forState:UIControlStateSelected];
    if (time == 0) {
        time = 60;
        [timer invalidate];
        button.selected = NO;
        button.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}



//- (IBAction)getTextnumber:(id)sender {
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumberText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
//        if (error==nil) {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"短信发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//        else {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"短信发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//    }];
//}
//- (IBAction)commitButton:(id)sender {
//    [SMSSDK commitVerificationCode:_testNumber.text phoneNumber:_phoneNumberText.text zone:@"86" result:^(NSError *error) {
//        if (error == nil) {
//            revisePassWordController *rpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"revisePassWordController"];
//            [self.navigationController pushViewController:rpVC animated:YES];
//        }
//        else {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//            
//        }
//    }];
//}
@end
