//
//  revisePassWordController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/27.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "revisePassWordController.h"
#import "LoginController.h"

@interface revisePassWordController ()<UITextFieldDelegate>

@end

@implementation revisePassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    revisePW.placeholder = @"请输入新密码";
    revisePW.secureTextEntry = YES;
    revisePW.delegate = self;
    revisePW.keyboardType = UIKeyboardTypeASCIICapable;
    sureRevisePW.placeholder = @"确认新密码";
    sureRevisePW.secureTextEntry = YES;
    sureRevisePW.delegate = self;
    sureRevisePW.secureTextEntry = UIKeyboardTypeASCIICapable;
    oldPWText.placeholder = @"输入旧密码";
    oldPWText.hidden = YES;
    oldPWText.delegate = self;
    oldPWText.keyboardType = UIKeyboardTypeASCIICapable;
    submitButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    backView.backgroundColor = [UIColor clearColor];
    if (_phone == nil) {
        oldPWText.hidden = NO;
        topline.constant = 58;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)commitButtonClick:(id)sender {
    if (_phone != nil) {
        if ([revisePW.text isEqualToString:sureRevisePW.text]) {
            [DataService requestURL:[NSString stringWithFormat:@"%@resetPromulgatorPassword",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"phone":_phone,@"new":revisePW.text} responseSerializer:nil completion:^(id result, NSError *error) {
                if ([result[@"err"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        }
    }
    else {
        if (![oldPWText.text isEqualToString:revisePW.text]){
            if ([revisePW.text isEqualToString:sureRevisePW.text]) {
            [DataService requestURL:[NSString stringWithFormat:@"%@modPromulgatorPassword",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":_promulgator_id,@"new":revisePW.text,@"old":oldPWText.text} responseSerializer:nil completion:^(id result, NSError *error) {
                if ([result[@"err"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
                    LoginController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }];

        }
            else {
             [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"新密码与原密码一致"];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    
    else {
        
        if (textField.text.length - range.length + string.length > 16) {
            return NO;
        }
        else {
            return YES;
        }
    }
}
@end
