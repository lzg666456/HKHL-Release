//
//  HomeController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "HomeController.h"
#import "LoginController.h"
#import "IssusMessageController.h"
#import "NotcificationController.h"
#import "NurseMessageController.h"
#import "OneselfCenterController.h"
#import "SDCycleScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "ADDetailViewController.h"
@interface HomeController ()<SDCycleScrollViewDelegate>{
    
    NSMutableArray *adimgs;
    SDCycleScrollView *scrollPhoto;
}

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.leftButton.hidden = YES;
    
    contentLabel.backgroundColor = [UIColor lightGrayColor];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.alpha = 0.9;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentLabelClick)];
    contentTap.numberOfTapsRequired = 1;
    [contentLabel addGestureRecognizer:contentTap];
    
    
    [self _createView];
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
    if (infoDic != nil) {
        [DataService requestURL:[NSString stringWithFormat:@"%@getMassage",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"role_id":@"1",@"user_id":infoDic[@"promulgator_id"]} responseSerializer:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                
                if ([result[@"message_list"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *messageARR = result[@"message_list"];
                    contentLabel.text = [NSString stringWithFormat:@"  动态: %@",[[messageARR firstObject] objectForKey:@"content"]];
                }
            }
        }];
    }
    // 获取广告
    [DataService requestURL:[NSString stringWithFormat:@"%@getAdvertisement",BaseUrl] httpMethod:@"post" timeout:10 params:nil responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                _ADList = result[@"list"];
                adimgs = [NSMutableArray array];
                for (NSDictionary *dic in _ADList) {
                    
                    [adimgs addObject:dic[@"picture"]];
                }
                scrollPhoto = [[SDCycleScrollView alloc]initWithFrame:_mainPic.frame];
                scrollPhoto.delegate = self;
                scrollPhoto.placeholderImage = [UIImage imageNamed:@"主图_xxhdpi"];
                scrollPhoto.imageURLStringsGroup = adimgs;
                [self.view insertSubview:scrollPhoto belowSubview:contentLabel];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];

    
    //发布任务
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    tap1.numberOfTapsRequired = 1;
    [_issueMessage addGestureRecognizer:tap1];
    
    //通知中心
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
    tap1.numberOfTapsRequired = 1;
    [_noticification addGestureRecognizer:tap2];
    
    //护士信息
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3)];
    tap1.numberOfTapsRequired = 1;
    [_nurseMessage addGestureRecognizer:tap3];
    
    //个人中心
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap4)];
    tap1.numberOfTapsRequired = 1;
    [_oneselfCenter addGestureRecognizer:tap4];
    
}

- (void)contentLabelClick {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey]) {
        [self pushToLoginController];
    }
    else {
        NotcificationController *notcification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotcificationController"];
        [self.navigationController pushViewController:notcification animated:YES];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                                                                                          NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    lable.backgroundColor = [UIColor colorWithRed:0.847f green:0.847f blue:0.847f alpha:1.00f] ;
    [self.view addSubview:lable];
    
}
#pragma mark 创建视图
- (void)_createView {
    
    CGFloat kWidth = self.view.bounds.size.width;
    CGFloat kHeight = self.view.bounds.size.height;
    CGFloat mpHeight = self.view.bounds.size.width*4/5;
    CGFloat nHeight = self.navigationController.navigationBar.bounds.size.height;
    
//    NSLog(@"kHight = %f",kHeight);
//    NSLog(@"%f",self.view.frame.size.height);
//    NSLog(@"mpHeight =%f",mpHeight);
//    NSLog(@"_myViewHeight = %f",_myView.bounds.size.height);
    
//    _myView.backgroundColor = [UIColor redColor];

    
    _issueMessage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth/2-3-16, (self.view.height-nHeight-mpHeight-10)*5/9)];
    _issueMessage.backgroundColor = [UIColor colorWithRed:0.235f green:0.604f blue:0.851 alpha:1.0f];
    [self.myView addSubview:_issueMessage];
    UIImageView *_issueMessageImage = [[UIImageView alloc]initWithFrame:CGRectMake(_issueMessage.width/3+5,_issueMessage.height/3 , _issueMessage.width/3-10, _issueMessage.height/3)];
    _issueMessageImage.image = [UIImage imageNamed:@"任务发布_xxhdpi"];
    [_issueMessage addSubview:_issueMessageImage];
    UILabel *issusLable = [[UILabel alloc]initWithFrame:CGRectMake(0, _issueMessage.height*2/3, _issueMessage.width, 30)];
    issusLable.textAlignment = NSTextAlignmentCenter;
    issusLable.text = @"发布任务";
    issusLable.textColor = [UIColor whiteColor];
    _issueMessage.layer.masksToBounds = YES;
    _issueMessage.layer.cornerRadius = 6;
    _issueMessage.layer.borderWidth = 1;
    _issueMessage.layer.borderColor = [[UIColor whiteColor]CGColor];
    [_issueMessage addSubview:issusLable];
    
    
    
    _nurseMessage = [[UIView alloc]initWithFrame:CGRectMake(_issueMessage.bounds.size.width+6,0,_issueMessage.bounds.size.width,(kHeight-mpHeight-nHeight-10)*5/11+5)];
    _nurseMessage.backgroundColor = [UIColor colorWithRed:0.965f green:0.706f blue:0.000f alpha:1.00f];
    [self.myView addSubview:_nurseMessage];
    UIImageView *_nurseMessageImage = [[UIImageView alloc]initWithFrame:CGRectMake(_nurseMessage.bounds.origin.x+_nurseMessage.bounds.size.width/3,_nurseMessage.bounds.origin.y+_nurseMessage.bounds.size.height/3 , _nurseMessage.bounds.size.width/3-10, _nurseMessage.bounds.size.height/3)];
    _nurseMessageImage.image = [UIImage imageNamed:@"护士信息_xxhdpi"];
    [_nurseMessage addSubview:_nurseMessageImage];
    UILabel *nurseMessageLable = [[UILabel alloc]initWithFrame:CGRectMake(0, _nurseMessage.height*2/3, _nurseMessage.width, 30)];
    nurseMessageLable.text = @"护士信息";
    nurseMessageLable.textAlignment = NSTextAlignmentCenter;
    nurseMessageLable.textColor = [UIColor whiteColor];
    _nurseMessage.layer.masksToBounds = YES;
    _nurseMessage.layer.cornerRadius = 6;
    _nurseMessage.layer.borderWidth = 1;
    _nurseMessage.layer.borderColor = [[UIColor whiteColor]CGColor];
    [_nurseMessage addSubview:nurseMessageLable];
    
    
    
    _noticification = [[UIView alloc]initWithFrame:CGRectMake(0,_issueMessage.bottom+5,_issueMessage.bounds.size.width,(kHeight-nHeight-mpHeight-10)*4/9)];
    _noticification.backgroundColor = [UIColor colorWithRed:0.184f green:0.831f blue:0.698f alpha:1.00f] ;
    [self.myView insertSubview:_noticification aboveSubview:_mainPic];
    UIImageView *_noticificationImage = [[UIImageView alloc]initWithFrame:CGRectMake(_noticification.bounds.origin.x+_noticification.bounds.size.width/3+5,_noticification.bounds.origin.y+_noticification.bounds.size.height/3 , _noticification.bounds.size.width/3-10, _noticification.bounds.size.height/3)];
    _noticificationImage.image = [UIImage imageNamed:@"消息中心_xhdpi"];
    [_noticification addSubview:_noticificationImage];
    UILabel *noticifitionLable = [[UILabel alloc]initWithFrame:CGRectMake(_noticification.bounds.origin.x+_noticification.bounds.size.width/3-10, _noticification.bounds.origin.y+_noticification.bounds.size.height*2/3, _noticification.width, 30)];
    noticifitionLable.text = @"通知中心";
    noticifitionLable.textColor = [UIColor whiteColor];
    _noticification.layer.masksToBounds = YES;
    _noticification.layer.cornerRadius = 6;
    _noticification.layer.borderWidth = 1;
    _noticification.layer.borderColor = [[UIColor whiteColor]CGColor];
    [_noticification addSubview:noticifitionLable];

    

    
    _oneselfCenter = [[UIView alloc]initWithFrame:CGRectMake(_issueMessage.bounds.size.width+6,_nurseMessage.bounds.size.height+5,_issueMessage.bounds.size.width,(kHeight-mpHeight-nHeight-10)*6/11-5)];
    _oneselfCenter.backgroundColor = [UIColor colorWithRed:0.675f green:0.514f blue:0.765f alpha:1.00f];
    [self.myView addSubview:_oneselfCenter];
    UIImageView *_oneselfCenterImage = [[UIImageView alloc]initWithFrame:CGRectMake(_oneselfCenter.bounds.origin.x+_oneselfCenter.bounds.size.width/3+5,_oneselfCenter.bounds.origin.y+_oneselfCenter.bounds.size.height/3 , _oneselfCenter.bounds.size.width/3-10, _oneselfCenter.bounds.size.height/3)];
    _oneselfCenterImage.image = [UIImage imageNamed:@"个人中心_xxhdpi"];
    [_oneselfCenter addSubview:_oneselfCenterImage];
    UILabel *oneselfCenterLable = [[UILabel alloc]initWithFrame:CGRectMake(_oneselfCenter.bounds.origin.x+_oneselfCenter.bounds.size.width/3-10, _oneselfCenter.bounds.origin.y+_oneselfCenter.bounds.size.height*2/3, _oneselfCenter.bounds.size.width+30, 30)];
    oneselfCenterLable.text = @"个人中心";
    oneselfCenterLable.textColor = [UIColor whiteColor];
    _oneselfCenter.layer.masksToBounds = YES;
    _oneselfCenter.layer.cornerRadius = 6;
    _oneselfCenter.layer.borderWidth = 1;
    _oneselfCenter.layer.borderColor = [[UIColor whiteColor]CGColor];
    [_oneselfCenter addSubview:oneselfCenterLable];
}

#pragma mark 手势方法
- (void)tap1 {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey]) {
        [self pushToLoginController];
    }
    else {
        IssusMessageController *issusMsg = [self.storyboard instantiateViewControllerWithIdentifier:@"IssusMessageController"];
        [self.navigationController pushViewController:issusMsg animated:YES];
    }
}

- (void)tap2 {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey]) {
        [self pushToLoginController];
    }
    else {
        NotcificationController *notcification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotcificationController"];
        [self.navigationController pushViewController:notcification animated:YES];
    }

}

- (void)tap3 {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey]) {
        [self pushToLoginController];
    }
    else {
        NurseMessageController *nurseMessage = [self.storyboard instantiateViewControllerWithIdentifier:@"NurseMessageController"];
        [self.navigationController pushViewController:nurseMessage animated:YES];       
    }
    

}

- (void)tap4 {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey]) {
        [self pushToLoginController];
    }
    else {
        OneselfCenterController *oneselfC = [self.storyboard instantiateViewControllerWithIdentifier:@"OneselfCenterController"];
        [self.navigationController pushViewController:oneselfC animated:YES];
    }
 
}

//跳转到登录界面
- (void)pushToLoginController {
    LoginController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    [self.navigationController pushViewController:loginController animated:YES];
    

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    self.hidesBottomBarWhenPushed = YES;
    ADDetailViewController *detailVC = [[ADDetailViewController alloc]init];
    detailVC.ID = self.ADList[index][@"id"];
    detailVC.title = self.ADList[index][@"subject"];

    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
