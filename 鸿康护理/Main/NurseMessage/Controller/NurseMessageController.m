//
//  NurseMessageController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "NurseMessageController.h"
#import "SelectedCell.h"
#import "NurseDetailsCell.h"
#import "NurseDetialController.h"
#import "MJRefresh.h"
@interface NurseMessageController () {
    NSMutableArray *_hospital;
    NSString *identy;
    UINib *nib;
    NSArray *jobTime;
    NSMutableArray *proTitle;
    NSInteger index;
    __weak IBOutlet UIButton *surePai;
    UIButton *button;
    UITableView *taskSelectTableView;
    UIView *taskView;
    NSArray *taskArray;
    
    NSString *hospitalID;
    NSInteger expeID;
    NSString *proTitleID;
    NSMutableDictionary *params;
    NSMutableArray *isSelect;
    
    NSDictionary *infoDic;
    
    NSString *taskID;
    
    NSMutableArray *nurseIDArr;
    
    NSInteger page;
    
    NSInteger topMJ;
}

@end



@implementation NurseMessageController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"护士信息";
    
    page = 1;
    
    topMJ = 0;
    
    infoDic = [[NSUserDefaults standardUserDefaults]objectForKey:selfMSGKey];
    nurseIDArr = @[].mutableCopy;
    _dataArr = @[].mutableCopy;
    
    isSelect = @[].mutableCopy;
    
    surePai.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    index = 0;
    expeID = 0;
    button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"指派" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(appointButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    params = [[NSMutableDictionary alloc]init];
    taskArray = @[].copy;
    
    [self _loadData];
    
    [self _loadNurseData];
    
    identy = @"allSelected_cell";
    
    jobTime = @[@"所有",@"1年-5年",@"5年-10年",@"10年以上"];
    nib = [UINib nibWithNibName:@"SelectedCell" bundle:nil];
    [nurseMessageTableView registerNib:[UINib nibWithNibName:@"NurseDetailsCell" bundle:nil] forCellReuseIdentifier:@"NurseDetails_Cell"];
    nurseMessageTableView.showsHorizontalScrollIndicator = NO;
    nurseMessageTableView.showsVerticalScrollIndicator = NO;
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    nurseMessageTableView.tableFooterView = foot;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectButtonClick:) name:selectButtonClickNoticifition object:nil];
    
    taskView = [[UIView alloc]initWithFrame:self.view.bounds];
    taskView.backgroundColor = [UIColor grayColor];
    taskView.alpha = 0.9;
    taskView.hidden = YES;
    [self.view addSubview:taskView];
    
    
    taskSelectTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, 100, self.view.width-80, self.view.height-200) style:UITableViewStylePlain];
    taskSelectTableView.dataSource = self;
    taskSelectTableView.delegate = self;
    [taskSelectTableView registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellReuseIdentifier:@"taskSelected_cell"];
    [taskView addSubview:taskSelectTableView];
    
    
    __weak typeof(self) weakSelf = self;
    [nurseMessageTableView addLegendHeaderWithRefreshingBlock:^{
        topMJ = 0;
        page = 1;
        [weakSelf _loadNurseData];
    }];
    [nurseMessageTableView addLegendFooterWithRefreshingBlock:^{
        page = page + 1;
        topMJ = 1;
        [weakSelf _loadNurseData];
    }];
}


- (void)_loadNurseData {
    [params setObject:@(page) forKey:@"p"];
    [DataService requestURL:[NSString stringWithFormat:@"%@getNurseList",BaseUrl] httpMethod:@"POST" timeout:30 params:params responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                if (topMJ == 0) {
                    _dataArr = [NSMutableArray array];
                }
                for (NSDictionary *msgdic in result[@"list"]) {
                        [_dataArr addObject:msgdic];
                }
                for (int i = 0; i<self.dataArr.count; i++) {
                    NSString *boolStr = @"0";
                    [isSelect addObject:boolStr];
                }
                [nurseMessageTableView reloadData];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            if (error.code == 3840) {
                [SVProgressHUD showErrorWithStatus:@"无数据"];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络出错"];
            }
        }
        [nurseMessageTableView.legendHeader endRefreshing];
        [nurseMessageTableView.legendFooter endRefreshing];
    }];

}

- (void)_loadData {
    
        //医院信息
    [DataService requestURL:[NSString stringWithFormat:@"%@getHospital",BaseUrl] httpMethod:@"GET" timeout:30 params:nil responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                _hospital = [NSMutableArray arrayWithObject:@"所有"];
                [_hospital addObjectsFromArray:result[@"hospital_list"]];
                [hospitalTableView reloadData];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }
    }];
    // 职称
    [DataService requestURL:[NSString stringWithFormat:@"%@getJobtitle",BaseUrl] httpMethod:@"GET" timeout:30 params:@{@"type":@"0"} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                proTitle = [NSMutableArray arrayWithObject:@"所有"];
                [proTitle addObjectsFromArray:result[@"jobtitle_list"]];
                [proTitleTableView reloadData];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }

    }];
    
    [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorAssignTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":infoDic[@"promulgator_id"]} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                taskArray = result[@"list"];
                [taskSelectTableView reloadData];
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

//指派按钮
- (void)appointButtonClick {
    
    taskView.hidden = NO;
    hospitalTableView.hidden = YES;
    proTitleTableView.hidden = YES;
    jobTimeTableView.hidden = YES;
    hospitalSelectButton.selected = NO;
    jobTimeSelectButton.selected = NO;
    proTitleSelectButton.selected = NO;
}

- (void)selectButtonClick:(NSNotification *)aNotification {
    NSDictionary *dic = aNotification.userInfo;
    NSString *str = dic[@"row"];
    NSInteger i = [str integerValue];
    NSString *isSelected = isSelect[i];
    if ([isSelected integerValue] == 0) {
        index ++;
        isSelect[i] = @"1";
        [nurseIDArr addObject:[_dataArr[i] objectForKey:@"id"]];
    }else {
        index --;
        isSelect[i] = @"0";
        [nurseIDArr removeObject:[_dataArr[i] objectForKey:@"id"]];
    }
    [nurseMessageTableView reloadData];
    [sureButton setTitle:[NSString stringWithFormat:@"确认指派(%ld人)",(long)index] forState:UIControlStateNormal];

}

//医院选择
- (IBAction)hospitalSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    hospitalTableView.hidden = !hospitalTableView.hidden;
    if (hospitalTableView == nil) {
        hospitalTableView = [[UITableView alloc]initWithFrame:CGRectMake(hospitalSelectButton.origin.x,selectView.bottom , hospitalSelectButton.width+30, 120) style:UITableViewStylePlain];
        hospitalTableView.dataSource = self;
        hospitalTableView.delegate = self;
        [hospitalTableView registerNib:nib forCellReuseIdentifier:identy];
        [self.view addSubview:hospitalTableView];
    }
}
//工作时间选择
- (IBAction)jobTimeSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    jobTimeTableView.hidden = !jobTimeTableView.hidden;
    if (jobTimeTableView == nil) {
        jobTimeTableView = [[UITableView alloc]initWithFrame:CGRectMake(jobTimeSelectButton.origin.x, selectView.bottom, jobTimeSelectButton.width+30,120) style:UITableViewStylePlain];
        jobTimeTableView.dataSource = self;
        jobTimeTableView.delegate = self;
        [jobTimeTableView registerNib:nib forCellReuseIdentifier:identy];
        [self.view addSubview:jobTimeTableView];
    }
}
//职称选择
- (IBAction)proTitleSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    proTitleTableView.hidden = !proTitleTableView.hidden;
    if (proTitleTableView == nil) {
        proTitleTableView = [[UITableView alloc]initWithFrame:CGRectMake(proTitleSelectButton.origin.x, selectView.bottom, proTitleSelectButton.width+60, 120) style:UITableViewStylePlain];
        proTitleTableView.dataSource = self;
        proTitleTableView.delegate = self;
        [proTitleTableView registerNib:nib forCellReuseIdentifier:identy];
        [self.view addSubview:proTitleTableView];
    }
}


#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == hospitalTableView) {
        return _hospital.count;
    }
    else if (tableView == jobTimeTableView) {
        return jobTime.count;
    }
    else if (tableView == proTitleTableView) {
        return proTitle.count;
    }
    else if (tableView == nurseMessageTableView) {
        return _dataArr.count;
    }
    else if (tableView == taskSelectTableView) {
        return taskArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == hospitalTableView) {
        SelectedCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identy];
        if (indexPath.row == 0) {
            
            cell1.lableText = _hospital[indexPath.row];
        }
        else {
            
            NSDictionary *nameDic = _hospital[indexPath.row];
            cell1.lableText = nameDic[@"name"];
        }
        return cell1;
    }
    else if (tableView == jobTimeTableView) {
        SelectedCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identy];
        cell1.lableText = jobTime[indexPath.row];
        return cell1;
    }
    else if (tableView == proTitleTableView) {
        SelectedCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identy];
        if (indexPath.row == 0) {
            
            cell1.lableText = proTitle[0];
        }
        else {
            cell1.lableText = [proTitle[indexPath.row] objectForKey:@"name"];
        }
        return cell1;
    }
    else if  (tableView == nurseMessageTableView) {
        NurseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NurseDetails_Cell"];
        cell.selectButton.tag = indexPath.row;
        cell.isSelect = isSelect[indexPath.row];
        cell.msgDic = _dataArr[indexPath.row];
        return cell;
    }
    else if (tableView == taskSelectTableView) {
        SelectedCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"taskSelected_cell"];
        cell2.lableText = [taskArray[indexPath.row] objectForKey:@"subject"];
        return cell2;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == nurseMessageTableView) {
        return 80;
    }
    else if (tableView == taskSelectTableView) {
        return 50;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == hospitalTableView) {
        if (indexPath.row == 0) {
            
            [hospitalSelectButton setTitle:@"所有" forState:UIControlStateSelected];
            [params removeObjectForKey:@"hospital_id"];
            hospitalID = nil;
        }
        else {
            
            [hospitalSelectButton setTitle:[_hospital[indexPath.row] objectForKey:@"name"] forState:UIControlStateSelected];
            hospitalID = [_hospital[indexPath.row] objectForKey:@"id"];
            [params setObject:hospitalID forKey:@"hospital_id"];
        }
        hospitalSelectButton.selected = YES;
        


        if (expeID != 0) {
            [params setObject:@(expeID) forKey:@"experience"];
        }
        if (proTitleID != nil) {
            [params setObject:proTitleID forKey:@"jobtitle_id"];
        }
        page = 1;
        [SVProgressHUD showWithStatus:@"获取中。。。"];
        [DataService requestURL:[NSString stringWithFormat:@"%@getNurseList",BaseUrl] httpMethod:@"POST" timeout:30 params:params responseSerializer:nil completion:^(id result, NSError *error) {
            [SVProgressHUD dismiss];
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    _dataArr = [NSMutableArray array];
                    for (NSDictionary *msgdic in result[@"list"]) {
                        [_dataArr addObject:msgdic];
                    }
                    isSelect = [[NSMutableArray alloc]init];
                    for (int i = 0; i<_dataArr.count; i++) {
                        NSString *boolStr = @"0";
                        [isSelect addObject:boolStr];
                    }
                    index = 0;
                    [sureButton setTitle:[NSString stringWithFormat:@"确认指派(%ld人)",(long)index] forState:UIControlStateNormal];
                    [nurseMessageTableView reloadData];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                if (error.code == 3840)
                {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }

            }
        }];
        tableView.hidden = YES;
    } else if (tableView == jobTimeTableView) {
        if (indexPath.row == 0) {
            
            [jobTimeSelectButton setTitle:@"所有" forState:UIControlStateSelected];
            [params removeObjectForKey:@"experience"];
            expeID = 0;
        }
        else {
            
            [jobTimeSelectButton setTitle:jobTime[indexPath.row] forState:UIControlStateSelected];
            expeID = indexPath.row;
            [params setObject:@(expeID) forKey:@"experience"];
        }
        jobTimeSelectButton.selected = YES;
        if (hospitalID != nil) {
            [params setObject:hospitalID forKey:@"hospital_id"];
        }
        if (proTitleID != nil) {
            [params setObject:proTitleID forKey:@"jobtitle_id"];
        }
        page = 1;
        [SVProgressHUD showWithStatus:@"获取中。。。"];
        [DataService requestURL:[NSString stringWithFormat:@"%@getNurseList",BaseUrl] httpMethod:@"POST" timeout:30 params:params responseSerializer:nil completion:^(id result, NSError *error) {
            [SVProgressHUD dismiss];
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    _dataArr = [NSMutableArray array];
                    for (NSDictionary *msgdic in result[@"list"]) {
                        [_dataArr addObject:msgdic];
                    }
                    isSelect = [[NSMutableArray alloc]init];
                    for (int i = 0; i<_dataArr.count; i++) {
                        NSString *boolStr = @"0";
                        [isSelect addObject:boolStr];
                    }
                    index = 0;
                    [sureButton setTitle:[NSString stringWithFormat:@"确认指派(%ld人)",(long)index] forState:UIControlStateNormal];
                    [nurseMessageTableView reloadData];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                if (error.code == 3840)
                {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                }
                else {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }
            }
        }];

        tableView.hidden = YES;
    } else if (tableView == proTitleTableView) {
        if (indexPath.row == 0) {
            
            [proTitleSelectButton setTitle:@"所有" forState:UIControlStateSelected];
            [params removeObjectForKey:@"jobtitle_id"];
            proTitleID = nil;
        }
        else {
            
            [proTitleSelectButton setTitle:[proTitle[indexPath.row] objectForKey:@"name"] forState:UIControlStateSelected];
            proTitleID = [proTitle[indexPath.row] objectForKey:@"id"];
            [params setObject:proTitleID forKey:@"jobtitle_id"];
        }
        proTitleSelectButton.selected = YES;
        if (hospitalID != nil) {
            [params setObject:hospitalID forKey:@"hospital_id"];
        }
        if (expeID != 0) {
            [params setObject:@(expeID) forKey:@"experience"];
        }
        page = 1;
        [SVProgressHUD showWithStatus:@"获取中。。。"];
        [DataService requestURL:[NSString stringWithFormat:@"%@getNurseList",BaseUrl] httpMethod:@"POST" timeout:30 params:params responseSerializer:nil completion:^(id result, NSError *error) {
            [SVProgressHUD dismiss];
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    _dataArr = [NSMutableArray array];
                    for (NSDictionary *msgdic in result[@"list"]) {
                        [_dataArr addObject:msgdic];
                    }
                    isSelect = [[NSMutableArray alloc]init];
                    for (int i = 0; i<_dataArr.count; i++) {
                        NSString *boolStr = @"0";
                        [isSelect addObject:boolStr];
                    }
                    index = 0;
                    [sureButton setTitle:[NSString stringWithFormat:@"确认指派(%ld人)",(long)index] forState:UIControlStateNormal];
                    [nurseMessageTableView reloadData];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                if (error.code == 3840)
                {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }

            }
        }];
        tableView.hidden = YES;
    } else if (tableView == nurseMessageTableView) {
        NurseDetialController *NDVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NurseDetialController"];
        NDVC.nurseID = [_dataArr[indexPath.row] objectForKey:@"id"];
        NDVC.nurseDic = _dataArr[indexPath.row];
        [self.navigationController pushViewController:NDVC animated:YES];
    } else if (tableView == taskSelectTableView ) {
        [button setTitle:[taskArray[indexPath.row] objectForKey:@"subject"] forState:UIControlStateNormal];
        taskView.hidden = YES;
        taskID = [taskArray[indexPath.row] objectForKey:@"id"];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    taskView.hidden = YES;
}

- (IBAction)surePaiButtonClick:(id)sender {
    if (nurseIDArr.count == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请先选择护士"];
        return;
    }
    if (taskID == nil) {
        
        taskView.hidden = NO;
        hospitalTableView.hidden = YES;
        proTitleTableView.hidden = YES;
        jobTimeTableView.hidden = YES;
        hospitalSelectButton.selected = NO;
        jobTimeSelectButton.selected = NO;
        proTitleSelectButton.selected = NO;
        return;
    }
    [SVProgressHUD showWithStatus:@"指派中。。。"];
    [DataService requestURL:[NSString stringWithFormat:@"%@taskAssign",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"task_id":taskID,@"promulgator_id":infoDic[@"promulgator_id"],@"nurse_id":nurseIDArr} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"指派成功"];
                [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:.5];
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


@end
