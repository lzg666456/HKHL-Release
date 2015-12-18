//
//  MyCollectController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/3.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MyCollectController.h"
#import "NurseDetailsCell.h"
#import "NurseDetialController.h"
#import "SelectedCell.h"

@interface MyCollectController () {
    UITableView *_tableView;
    NSString *identy;
    NSDictionary *infoDic;
    
    NSMutableArray *isSelect;
    
    NSInteger index;
    
    UIButton *querenzhipaiButton;
    
    NSMutableArray *nurseIDArr;
    
    UIView *garyView;
    
    UITableView *taskTableView;
    
    NSArray *taskARR;
}

@end

@implementation MyCollectController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_taskID == nil) {
        self.title = @"我的收藏";
    }
    else {
        self.title = @"报名列表";
    }
    isSelect = [[NSMutableArray alloc]init];
    
    nurseIDArr = @[].mutableCopy;
    
    infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectButtonClick:) name:selectButtonClickNoticifition object:nil];
    
    if (self.taskID == nil) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 50, 30);
        [rightButton setTitle:@"指派" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(zhipaiButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    else {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 50, 30);
        [rightButton setTitle:@"全选" forState:UIControlStateNormal];
        [rightButton setTitle:@"取消" forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(allSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(16, 0, self.view.width-32, self.view.height-50-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = foot;
    
    identy = @"NurseDetailsCell";
    [_tableView registerNib:[UINib nibWithNibName:@"NurseDetailsCell" bundle:nil] forCellReuseIdentifier:identy];
    [self.view addSubview:_tableView];
    
    
    
    querenzhipaiButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    querenzhipaiButton.frame = CGRectMake(16, _tableView.bottom+5, self.view.width-32, 40);
    [querenzhipaiButton setTitle:@"确认指派(0人)" forState:UIControlStateNormal];
    [querenzhipaiButton setBackgroundColor:[UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f]];
    [querenzhipaiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [querenzhipaiButton addTarget:self action:@selector(sureZhiPai) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:querenzhipaiButton];
    
    garyView = [[UIView alloc]initWithFrame:self.view.bounds];
    garyView.backgroundColor = [UIColor grayColor];
    garyView.alpha = 0.9;
    garyView.hidden = YES;
    [self.view addSubview:garyView];
    
    
    taskTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, 100, self.view.width-80, self.view.height-200) style:UITableViewStylePlain];
    taskTableView.dataSource = self;
    taskTableView.delegate = self;
    [taskTableView registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellReuseIdentifier:@"taskSelected_cell"];
    [garyView addSubview:taskTableView];
    [self _loadData];
}

- (void)_loadData {
    if (_taskID != nil) {
        [DataService requestURL:[NSString stringWithFormat:@"%@getTaskApply",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":infoDic[@"promulgator_id"],@"task_id":_taskID} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    self.data = result[@"list"];
                    for (int i = 0; i<_data.count; i++) {
                        NSString *boolStr = @"0";
                        [isSelect addObject:boolStr];
                    }
                    [_tableView reloadData];

                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                if (error.code == 3840) {
                    [SVProgressHUD showErrorWithStatus:@"暂无人报名"];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    
                }
            }
        }];
    }
    else {
        [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorCollect",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":infoDic[@"promulgator_id"]} responseSerializer:nil completion:^(id result, NSError *error) {
     
            if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                self.data = result[@"collect_list"];
                for (int i = 0; i<_data.count; i++) {
                    NSString *boolStr = @"0";
                    [isSelect addObject:boolStr];
                }
                [_tableView reloadData];
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
}

- (void)selectButtonClick:(NSNotification *)aNotification {
    NSDictionary *dic = aNotification.userInfo;
    NSString *str = dic[@"row"];
    NSInteger i = [str integerValue];
    NSString *isSelected = isSelect[i];
    if ([isSelected integerValue] == 0) {
        index ++;
        isSelect[i] = @"1";
        [nurseIDArr addObject:[_data[i] objectForKey:@"nurse_id"]];
    }else {
        index --;
        isSelect[i] = @"0";
        [nurseIDArr removeObject:[_data[i] objectForKey:@"nurse_id"]];
    }
    NSLog(@"%@",nurseIDArr);
    [_tableView reloadData];
    [querenzhipaiButton setTitle:[NSString stringWithFormat:@"确认指派(%ld人)",(long)index] forState:UIControlStateNormal];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
     return _data.count;
    }
    return taskARR.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        NurseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
        cell.msgDic = _data[indexPath.row];
        cell.isSelect = isSelect[indexPath.row];
        cell.selectButton.tag = indexPath.row;
        return cell;
    }
    else {
        SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskSelected_cell"];
        cell.lableText = [taskARR[indexPath.row] objectForKey:@"subject"];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        NurseDetialController *NDVC = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"NurseDetialController"];
        NDVC.nurseID = [_data[indexPath.row] objectForKey:@"nurse_id"];
        [self.navigationController pushViewController:NDVC animated:YES];
        
//        UIViewController *VC = [[UIViewController alloc]init];
//        VC.view.backgroundColor = [UIColor whiteColor];
//        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (tableView == taskTableView){
        _taskID = [taskARR[indexPath.row] objectForKey:@"id"];
        garyView.hidden = YES;
    }

}

//指派按钮
- (void)zhipaiButtonClick {
    garyView.hidden = !garyView.hidden;
    [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorAssignTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":infoDic[@"promulgator_id"]} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                taskARR = result[@"list"];
                [taskTableView reloadData];
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

//全选按钮
- (void)allSelectButtonClick:(UIButton *)button {
    if (button.selected == YES) {
        for (int i = 0; i<isSelect.count; i++) {
            isSelect[i] = @"0";
            [nurseIDArr removeAllObjects];
        }
        index = 0;
        [_tableView reloadData];
    }
    else {
        for (int i = 0; i<isSelect.count; i++) {
            isSelect[i] = @"1";
            [nurseIDArr addObject:[_data[i] objectForKey:@"nurse_id"]];
        }
        index = isSelect.count;
        [_tableView reloadData];
    }
    [querenzhipaiButton setTitle:[NSString stringWithFormat:@"确认指派(%ld人)",(long)index] forState:UIControlStateNormal];
    button.selected = !button.selected;
}

- (void)sureZhiPai {
    
    if (_taskID == nil) {
        [SVProgressHUD showErrorWithStatus:@"先选择任务"];
        return;
    }
    else {
        [DataService requestURL:[NSString stringWithFormat:@"%@taskAssign",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":infoDic[@"promulgator_id"],@"task_id":_taskID,@"nurse_id":nurseIDArr} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"指派成功"];
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
}



@end
