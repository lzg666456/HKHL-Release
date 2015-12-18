//
//  NurseDetialController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/6.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "NurseDetialController.h"
#import "UIImageView+WebCache.h"
#import "SelectedCell.h"
@interface NurseDetialController ()<UITableViewDataSource,UITableViewDelegate> {
    UIButton *rightButton;
    __weak IBOutlet UIButton *letToButton;
    
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UILabel *username;
    __weak IBOutlet UILabel *expe;
    __weak IBOutlet UILabel *protitle;
    __weak IBOutlet UILabel *age;
    __weak IBOutlet UILabel *sex;
    __weak IBOutlet UILabel *nation;
    __weak IBOutlet UILabel *address;
    __weak IBOutlet UILabel *acad;
    __weak IBOutlet UILabel *hospital;
    __weak IBOutlet UILabel *certificate;
    __weak IBOutlet UILabel *phone;
    
    NSArray *taskArr;
    
    UITableView *taskTableView;
    
    NSDictionary *dic;
    
    NSString *collect_id;
}

@end

@implementation NurseDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"护士信息详情";
    letToButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
    
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 45;
    
    rightButton = [[UIButton alloc]init];
    [rightButton setImage:[UIImage imageNamed:@"未收藏_xxhdpi"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"已收藏_xhdpi"] forState:UIControlStateSelected];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    //    rightButton.backgroundColor = [UIColor redColor];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    colorView.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    
    scrollView.contentSize = CGSizeMake(self.view.width, 200);
    [DataService requestURL:[NSString stringWithFormat:@"%@getProNurseInfo",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"nurse_id":_nurseID} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                NSDictionary *infoDic = result[@"info"];
                collect_id = infoDic[@"collect_id"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,infoDic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"参与人员_xxhdpi"]];
                    username.text = infoDic[@"username"];
                    expe.text = [NSString stringWithFormat:@"%@年护理经验",infoDic[@"experience"]];
                    if (![infoDic[@"jobtitle_name"] isKindOfClass:[NSNull class]]) {
                        
                        protitle.text = infoDic[@"jobtitle_name"];
                    }
                    age.text = infoDic[@"age"];
                    if ([infoDic[@"gender"] integerValue] == 0) {
                        sex.text = @"男";
                    }else {
                        sex.text = @"女";
                    }
                    if ([infoDic[@"nation"] isEqualToString:@""]) {
                        nation.text = @"汉族";
                    }
                    else {
                        nation.text = infoDic[@"nation"];
                    }
                    if (![infoDic[@"city_name"] isKindOfClass:[NSNull class]]) {
                        
                        address.text = infoDic[@"city_name"];
                    }
//                    acad.text = infoDic[@"education"];
                    if (![infoDic[@"hospital_name"] isKindOfClass:[NSNull class]]) {
                        
                        hospital.text = infoDic[@"hospital_name"];
                    }
                    certificate.text = infoDic[@"credentials_name"];
                    phone.text = infoDic[@"phone"];
                    
                    if ([infoDic[@"collect_id"] integerValue] == 0 ) {
                        rightButton.selected = NO;
                    }
                    else {
                        rightButton.selected = YES;
                    }
                });
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
    }];
    
    [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorAssignTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"]} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                taskArr = result[@"list"];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)rightButtonClick {
    if (rightButton.selected == YES) {
        
        NSArray *arr = @[collect_id];
        
        [DataService requestURL:[NSString stringWithFormat:@"%@delPromulgatorCollect",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"collect_id":arr} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络超时"];
            }
        }];
    }
    else if (rightButton.selected == NO) {
        [DataService requestURL:[NSString stringWithFormat:@"%@addPromulgatorCollect",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"nurse_id":_nurseID} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                if ([result[@"err"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    collect_id = result[@"collect_id"];
                    [taskTableView reloadData];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络超时"];
            }
        }];
    }
    rightButton.selected = !rightButton.selected;
}


- (IBAction)zhipaiButtonClick:(id)sender {
    taskTableView.hidden = !taskTableView.hidden;
    if (taskTableView == nil) {
        taskTableView = [[UITableView alloc]initWithFrame:CGRectMake(letToButton.left, letToButton.top - 150, letToButton.width, 150) style:UITableViewStylePlain];
        taskTableView.delegate = self;
        taskTableView.dataSource = self;
        taskTableView.backgroundColor = [UIColor grayColor];
        [taskTableView registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellReuseIdentifier:@"taskSelect"];
        [self.view addSubview:taskTableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskSelect"];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.lableText = [taskArr[indexPath.row] objectForKey:@"subject"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DataService requestURL:[NSString stringWithFormat:@"%@taskAssign",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"task_id":[taskArr[indexPath.row] objectForKey:@"id"],@"nurse_id":@[_nurseID]} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"指派成功"];
                taskTableView.hidden = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
}


@end
