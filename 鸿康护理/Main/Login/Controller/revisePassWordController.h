//
//  revisePassWordController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/27.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface revisePassWordController : BaseController {
    
    __weak IBOutlet UITextField *revisePW;
    __weak IBOutlet UITextField *sureRevisePW;
    __weak IBOutlet UIButton *submitButton;
    __weak IBOutlet UIView *backView;
    __weak IBOutlet UITextField *oldPWText;
    __weak IBOutlet NSLayoutConstraint *topline;
    
}
- (IBAction)commitButtonClick:(id)sender;

@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *promulgator_id;
@end
