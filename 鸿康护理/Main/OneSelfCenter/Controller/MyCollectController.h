//
//  MyCollectController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/11/3.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface MyCollectController : BaseController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *data;
@property (nonatomic,copy)NSString *taskID;
@end
