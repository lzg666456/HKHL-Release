//
//  MyIssusController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/28.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MyIssusController.h"
#import "CSExampleView.h"
#import "MyIssusCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CheckingController.h"
#import "CheckedController.h"
#import "FinishController.h"
#import "HMSegmentedControl.h"

@interface MyIssusController ()<UITableViewDataSource,UITableViewDelegate> {
    NSArray *data;
    NSArray *checkingArr;
    NSArray *checkedArr;
    NSArray *endArr;
    
    UITableView *_tableView;
    NSString *identy;
    UIView *_view;
    HMSegmentedControl *sgC;
    NSDictionary *dic;
    CGFloat checking;
    CGFloat checked;
    CGFloat end;
    
    UIView *bgView;
}
@property (nonatomic,weak) CSExampleView *csExampleView;
@end

@implementation MyIssusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的发布";
    self.view.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    [self _reloadData];
    [self _createView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inspectClick:) name:inspectButttonClickNoticifition object:nil];
    
}

- (void)_reloadData {
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
    [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"status":@"0"} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                checking = [result[@"no_check_num"] doubleValue];
                checked = [result[@"checked_num"] doubleValue];
                end = [result[@"done_num"] doubleValue];
                checkingArr = result[@"task_list"];
                data = checkingArr;
                [_tableView reloadData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    CSExampleView *view = [[CSExampleView alloc] initWithFrame:CGRectMake(bgView.width/2-70, 10, self.view.width/2+70, bgView.height-45)];
                    
                    _csExampleView = view;
                    [bgView addSubview:view];
                    CGFloat checkingF = checking/(checking+checked+end);
                    CGFloat checkedF = checked/(checking+checked+end);
                    CGFloat endF = end/(checking+checked+end);
                    [_csExampleView.csView setPercentageColorArray:@[[[CSPercentageColor alloc] initWithTitle:@"审核中" color:[UIColor yellowColor] percentage:checkingF],
                                                                     [[CSPercentageColor alloc] initWithTitle:@"已审核" color:[UIColor whiteColor] percentage:checkedF],
                                                                     [[CSPercentageColor alloc] initWithTitle:@"已完成" color:[UIColor greenColor] percentage:endF]]];
                    
                    //    [_csExampleView.csView.textLabel setText:@"啊啊啊"];
                    
                    [_csExampleView.csView setFillColor:[UIColor clearColor]];
                    
                    [_csExampleView.csView setStartAngle:15];
                    [_csExampleView.csView setLineWidth:20];
                    [_csExampleView.csView setRadius:50.f];
                    //    [_csExampleView.csView.legendView setLegendPosition:CSLegendPositionRight];
                    [self.view setNeedsLayout];
                    
                });
                
                
                    
//                    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2-50, self.view.width/4+self.navigationController.navigationBar.bottom, 100, 30)];
//                    lable1.backgroundColor = [UIColor redColor];
//                    [self.view addSubview:lable1];

            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
    }];
    [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"status":@"1"} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                checking = [result[@"no_check_num"] doubleValue];
                checked = [result[@"checked_num"] doubleValue];
                end = [result[@"done_num"] doubleValue];
                checkedArr = result[@"task_list"];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
    }];
    [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"status":@"2"} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                checking = [result[@"no_check_num"] doubleValue];
                checked = [result[@"checked_num"] doubleValue];
                end = [result[@"done_num"] doubleValue];
                endArr = result[@"task_list"];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
    }];
}

- (void)inspectClick:(NSNotification *)aNotification {
    NSDictionary *dicttt = aNotification.userInfo;
    NSString *task_id = dicttt[@"tag"];
    if (sgC.selectedSegmentIndex == 0) {
        [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTaskInfo",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"task_id":task_id} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    NSDictionary *infoDIC = result[@"task_info"];
                    CheckingController *checkingVC = [[CheckingController alloc]init];
                    checkingVC.taskMsg = infoDIC;
                    [self.navigationController pushViewController:checkingVC animated:YES];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络出错"];
            }
        }];
    }
    else if (sgC.selectedSegmentIndex == 1) {
        
        [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTaskInfo",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"task_id":task_id} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    NSDictionary *infoDIC = result[@"task_info"];
                    CheckedController *checkedVC = [[CheckedController alloc]init];
                    checkedVC.taskMsg = infoDIC;
                    [self.navigationController pushViewController:checkedVC animated:YES];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络出错"];
            }
        }];
    }
    else {
        
        [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTaskInfo",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"task_id":task_id} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    NSDictionary *infoDIC = result[@"task_info"];
                    FinishController *FVC = [[FinishController alloc]init];
                    FVC.taskMsg = infoDIC;
                    [self.navigationController pushViewController:FVC animated:YES];

                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络出错"];
            }
        }];
        }
}

- (void)_createView {
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width/2)];
    bgView.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    [self.view addSubview:bgView];

    
    NSArray *itmes = @[@"审核中",@"已审核",@"已完成"];
    sgC = [[HMSegmentedControl alloc] initWithSectionTitles:itmes];
    sgC.frame = CGRectMake(0, bgView.bottom, self.view.width, 30);
    sgC.backgroundColor = [UIColor whiteColor];
    [sgC setSelectionIndicatorColor:[UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f]];
    [sgC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [sgC setSelectedTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f]}];
    //设置选中的索引
    sgC.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    sgC.selectedSegmentIndex = 0;
    
    [sgC addTarget:self action:@selector(sgcAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:sgC];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(bgView.height+30, 0, 94, 0);
    identy = @"myIssus_cell";
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = foot;
    [_tableView registerNib:[UINib nibWithNibName:@"MyIssusCell" bundle:nil] forCellReuseIdentifier:identy];
    [self.view addSubview:_tableView];
    
//    _view = [[UIView alloc]init];
//    _view.frame = CGRectMake(_csExampleView.width/2-35, _csExampleView.height/2-35+self.navigationController.navigationBar.height, 70, 70);
//    _view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_view];
}

- (void)sgcAction:(UISegmentedControl *)sgc {
    if ((long)sgc.selectedSegmentIndex == 0) {
        [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"status":@"0"} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    checkingArr = result[@"task_list"];
                    data = checkingArr;
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
    else if ((long)sgc.selectedSegmentIndex == 1) {
        [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"status":@"1"} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    checking = [result[@"no_check_num"] doubleValue];
                    checked = [result[@"checked_num"] doubleValue];
                    end = [result[@"done_num"] doubleValue];
                    checkedArr = result[@"task_list"];
                    data = checkedArr;
                    [_tableView reloadData];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }
        }];

    }
    else {
        [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"status":@"2"} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    checking = [result[@"no_check_num"] doubleValue];
                    checked = [result[@"checked_num"] doubleValue];
                    end = [result[@"done_num"] doubleValue];
                    endArr = result[@"task_list"];
                    data = endArr;
                    [_tableView reloadData];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyIssusCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.msgDic = data[indexPath.row];
    cell.lookButton.tag = [[data[indexPath.row] objectForKey:@"id"] integerValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentsetY = scrollView.contentOffset.y;
    if (contentsetY > 0) {
        bgView.frame = CGRectMake(0, -bgView.height, bgView.width, bgView.height);
        sgC.frame = CGRectMake(0, 0, sgC.width, sgC.height);
        return;
    }
    bgView.frame = CGRectMake(0, -contentsetY-bgView.height, bgView.width, bgView.height);
    sgC.frame = CGRectMake(0, -contentsetY, sgC.width, sgC.height);
}

@end
