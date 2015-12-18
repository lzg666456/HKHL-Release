//
//  OneselfCenterController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "OneselfCenterController.h"
#import "OnselfCenterCell.h"
#import "MyIssusController.h"
#import "NotcificationController.h"
#import "revisePassWordController.h"
#import "SelfCenterController.h"
#import "MyCollectController.h"
#import "UIImageView+WebCache.h"

@interface OneselfCenterController (){
    NSArray *data;
    NSDictionary *dic;
    UIImageView *_avatar;
}

@end

@implementation OneselfCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    headView.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    UIImageView *lightView = [[UIImageView alloc]initWithFrame:headView.bounds];
    lightView.image = [UIImage imageNamed:@"发光背景_1080"];
    [headView addSubview:lightView];
    
    _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-68, 0, 100, 100)];
    UILabel *_username = [[UILabel alloc]initWithFrame:CGRectMake(0, _avatar.bottom, headView.width-36, 30)];
    _username.backgroundColor = [UIColor clearColor];
    _username.textColor = [UIColor whiteColor];
    _username.textAlignment = NSTextAlignmentCenter;
    _username.font = [UIFont systemFontOfSize:22];
    [headView addSubview:_avatar];
    [headView addSubview:_username];
    
    UILabel *_num = [[UILabel alloc]initWithFrame:CGRectMake(0, _username.bottom, _username.width/2, 30)];
    _num.backgroundColor = [UIColor clearColor];
    _num.textColor = [UIColor whiteColor];
    _num.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_num];
    
    UILabel *_dynamic_num = [[UILabel alloc]initWithFrame:CGRectMake(_num.right, _username.bottom, _num.width, 30)];
    _dynamic_num.textColor = [UIColor whiteColor];
    _dynamic_num.backgroundColor = [UIColor clearColor];
    _dynamic_num.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_dynamic_num];
    
    UILabel *ingTask = [[UILabel alloc]initWithFrame:CGRectMake(0, _num.bottom, _num.width,30)];
    ingTask.text = @"进行中";
    ingTask.textAlignment = NSTextAlignmentCenter;
    ingTask.textColor = [UIColor whiteColor];
    ingTask.backgroundColor = [UIColor clearColor];
    [headView addSubview:ingTask];
    
    UILabel *endTask = [[UILabel alloc]initWithFrame:CGRectMake(ingTask.right, _num.bottom, _num.width, 30)];
    endTask.textColor = [UIColor whiteColor];
    endTask.textAlignment = NSTextAlignmentCenter;
    endTask.backgroundColor = [UIColor clearColor];
    endTask.text = @"已完成";
    [headView addSubview:endTask];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(ingTask.right, ingTask.top-15, 1, 30)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [headView addSubview:lineLabel];
    
    _oneselfCenterTableView.tableHeaderView = headView;
    
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.cornerRadius = 50;
    UINib *nib = [UINib nibWithNibName:@"OnselfCenterCell" bundle:nil];
    [_oneselfCenterTableView registerNib:nib
                  forCellReuseIdentifier:@"OnselfCenterCell"];
    NSArray *arr = @[@{@"picName":@"我的通知_xhdpi",@"lableName":@"我的通知"},@{@"picName":@"我的发布_xhdpi",@"lableName":@"我的发布"},@{@"picName":@"我的收藏_xhdpi",@"lableName":@"我的收藏"}];
    NSArray *arr1 = @[@{@"picName":@"个人资料_xhdpi",@"lableName":@"个人信息"},@{@"picName":@"密码_xhdpi",@"lableName":@"修改密码"}];
    data = [NSArray arrayWithObjects:arr,arr1,nil];
    
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
    
    _username.text = dic[@"username"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeIcon:) name:changeIconIMG object:nil];
    NSString *stringUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,stringUrl]]];
    if (_avatar.image == nil) {
        _avatar.image = [UIImage imageNamed:@"图像_xhdpi"];
    }
    
    _num.text = [NSString stringWithFormat:@"%@",[dic[@"task"] objectForKey:@"num"]];
    _dynamic_num.text = [NSString stringWithFormat:@"%@",[dic[@"task"] objectForKey:@"dynamic_num"]];
}

- (void)changeIcon:(NSNotification *)aNotification {
    NSDictionary *dict = aNotification.userInfo;
    _avatar.image = dict[@"icon"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
        return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OnselfCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnselfCenterCell"];
    cell.data = data[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        MyIssusController *mIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyIssusController"];
        [self.navigationController pushViewController:mIVC animated:YES];
    }
    else if (indexPath.section ==0 && indexPath.row == 0) {
        NotcificationController *ncVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotcificationController"];
        [self.navigationController pushViewController:ncVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        MyCollectController *collectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCollectController"];
        collectVC.automaticallyAdjustsScrollViewInsets = NO; 
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    else if (indexPath.section ==1 && indexPath.row == 1) {
        NSString *promulgator_id = dic[@"promulgator_id"];
        revisePassWordController *rpwVC = [self.storyboard instantiateViewControllerWithIdentifier:@"revisePassWordController"];
        rpwVC.promulgator_id = promulgator_id;
        [self.navigationController pushViewController:rpwVC animated:YES];
    }
    else if (indexPath.section == 1 &&indexPath.row == 0) {
        SelfCenterController *scVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelfCenterController"];
        [self.navigationController pushViewController:scVC animated:YES];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint contentp = scrollView.contentOffset;
//    _bgView.frame = CGRectMake(16, -contentp.y, _bgView.width, _bgView.height);
//    _oneselfCenterTableView.frame = CGRectMake(16, _bgView.height-contentp.y, _oneselfCenterTableView.width, _oneselfCenterTableView.height);
//    NSLog(@"%f",_oneselfCenterTableView.height);
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]lastObject];
//        return view;
//    }
//    return nil;
//}

@end
