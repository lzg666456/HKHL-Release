//
//  NurseDetialController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/11/6.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface NurseDetialController : BaseController {
    
    __weak IBOutlet UIView *colorView;
    __weak IBOutlet UIScrollView *scrollView;
}

@property (nonatomic,copy)NSString *nurseID;
@property (nonatomic,strong)NSDictionary *nurseDic;
@end
