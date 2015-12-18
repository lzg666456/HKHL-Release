//
//  LoginController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController {
    
    __weak IBOutlet UIButton *longInButton;
    
    __weak IBOutlet UIButton *remeberButton;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginButton:(id)sender;
- (IBAction)rememberPassword:(UIButton *)sender;


@end
