//
//  NurseMessageController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface NurseMessageController : BaseController<UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UIButton *hospitalSelectButton;
    __weak IBOutlet UIButton *jobTimeSelectButton;
    __weak IBOutlet UIButton *proTitleSelectButton;//职称
    UITableView *hospitalTableView;
    UITableView *jobTimeTableView;
    UITableView *proTitleTableView;
    __weak IBOutlet UITableView *nurseMsgTableView;
    
    __weak IBOutlet UIView *selectView;
    __weak IBOutlet UITableView *nurseMessageTableView;
    __weak IBOutlet UIButton *sureButton;
    
    
}
- (IBAction)hospitalSelect:(UIButton *)sender;
- (IBAction)jobTimeSelect:(UIButton *)sender;
- (IBAction)proTitleSelect:(UIButton *)sender;
@property (nonatomic,strong)NSMutableArray *dataArr;


@end
