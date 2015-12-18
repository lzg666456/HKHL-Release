//
//  SelfCenterController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/30.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface SelfCenterController : BaseController<UITableViewDataSource,UITableViewDelegate> {
    
    __weak IBOutlet UIButton *preserveButton;
    
    __weak IBOutlet UIButton *exitButton;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)preserveMessage:(id)sender;
- (IBAction)endLogin:(id)sender;

@end
