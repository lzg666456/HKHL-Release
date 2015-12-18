//
//  HomeController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface HomeController : BaseController{
    UIView *_issueMessage;
    UIView *_noticification;
    UIView *_nurseMessage;
    UIView *_oneselfCenter;
    __weak IBOutlet UILabel *contentLabel;
    
}

@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIImageView *mainPic;
@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,strong)NSArray *ADList;
@end
