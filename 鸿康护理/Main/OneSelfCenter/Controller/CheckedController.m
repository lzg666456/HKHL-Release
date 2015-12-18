//
//  CheckedController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/9.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "CheckedController.h"
#import "UILabel+StringFrame.h"
#import "ShowAddressController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "UIImageView+WebCache.h"
#import "MyCollectController.h"

@interface CheckedController () {
    UIPageControl *pageControl;
    UIScrollView *imgScrollView;
    NSInteger scrollPointX;
    NSArray *picARR;
    NSDictionary *infoDic;
}

@end

@implementation CheckedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布详情";
    self.view.backgroundColor = [UIColor whiteColor];
    infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
}

- (void)setTaskMsg:(NSDictionary *)taskMsg {
    _taskMsg = taskMsg;
    [self _createView];
}

- (void)_createView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-50)];
    [self.view addSubview:scrollView];
    
    //时间标签
    UILabel *dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, self.view.width/4, 30)];
    dateLable.text = [Utility timeintervalToDate:[_taskMsg[@"createtime"] integerValue] Formatter:@"MM月dd日"];
    [scrollView addSubview:dateLable];
    
    UILabel *checkTime = [[UILabel alloc]initWithFrame:CGRectMake(dateLable.right*2, dateLable.top, dateLable.width, 30)];
    checkTime.textAlignment = NSTextAlignmentRight;
    checkTime.text = [Utility timeintervalToDate:[_taskMsg[@"checktime"] doubleValue] Formatter:@"MM月dd日"];
    [scrollView addSubview:checkTime];
    
    
    
    UIImageView *progressView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8+dateLable.bottom, self.view.width, 20)];
    progressView.image = [UIImage imageNamed:@"状态3_xxhdpi"];
    [scrollView addSubview:progressView];
    
    //状态标签1
    UILabel *stateLable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 8+progressView.bottom, self.view.width/4, 30)];
    stateLable1.text = @"提交";
    [scrollView addSubview:stateLable1];
    
    UILabel *stateLable2 = [[UILabel alloc]initWithFrame:CGRectMake(stateLable1.right, stateLable1.origin.y, self.view.width/4, 30)];
    stateLable2.text = @"审核中";
    [scrollView addSubview:stateLable2];
    
    UILabel *stateLable3 = [[UILabel alloc]initWithFrame:CGRectMake(stateLable2.right, stateLable1.origin.y, self.view.width/4, 30)];
    stateLable3.textAlignment = NSTextAlignmentRight;
    if ([_taskMsg[@"status"] integerValue] == 1) {
        stateLable3.text = @"未通过";
    }
    else {
        stateLable3.text = @"已通过";
    }
    [scrollView addSubview:stateLable3];
    
    NSString *picString = _taskMsg[@"sub_pic"];
    NSData *data = [picString dataUsingEncoding:NSUTF8StringEncoding];
    picARR = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //显示图片
    imgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 16+stateLable1.bottom, self.view.width, self.view.width*3/5)];
    for (int i = 0; i<picARR.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width*i, 0, self.view.width,self.view.width*3/5)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,picARR[i]]]];
        [imgScrollView addSubview:imgView];
    }
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,picARR[0]]]];
    imgView.frame = CGRectMake(imgScrollView.width*picARR.count, 0, imgScrollView.width, imgScrollView.height);
    [imgScrollView addSubview:imgView];
    scrollView.contentSize = CGSizeMake(self.view.width*picARR.count, self.view.width*3/5);
    if (picARR.count != 1) {
          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
    }
    [scrollView addSubview:imgScrollView];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, imgScrollView.bottom-10, imgScrollView.width, 10)];
    pageControl.numberOfPages = picARR.count;
    [scrollView addSubview:pageControl];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, imgScrollView.bottom+16, 10, 30);
    label.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:label];
    //显示主题
    UILabel *subjectLable = [[UILabel alloc]init];
    subjectLable.font = [UIFont systemFontOfSize:21];
    subjectLable.numberOfLines = 0;
    subjectLable.text = _taskMsg[@"subject"];
    CGSize size = [subjectLable boundingRectWithSize:CGSizeMake(self.view.width, 0)];
    subjectLable.frame = CGRectMake(20, imgScrollView.bottom+16, size.width,size.height );
    [scrollView addSubview:subjectLable];
    
    //显示时间
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, subjectLable.bottom+8, self.view.width-20, 30)];
    if ([_taskMsg[@"endtime"] integerValue] == 0) {
        timeLable.text = [Utility timeintervalToDate:[_taskMsg[@"begintime"] doubleValue] Formatter:@"MM月dd日hh时"];
    }
    else {
        NSString *beginTime = [Utility timeintervalToDate:[_taskMsg[@"begintime"] doubleValue] Formatter:@"MM月dd日hh时"];
        NSString *endTime = [Utility timeintervalToDate:[_taskMsg[@"endtime"] doubleValue] Formatter:@"MM月dd日hh时"];
        timeLable.text = [NSString stringWithFormat:@"%@-%@",beginTime,endTime];
    }
    timeLable.adjustsFontSizeToFitWidth = YES;
    [scrollView addSubview:timeLable];
    
    //显示地点
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(20, timeLable.bottom+8,self.view.width-20, 30)];
    addressLable.text = _taskMsg[@"address"];
    [scrollView addSubview:addressLable];
    
    //地图图标
    UIImageView *mapView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30, addressLable.origin.y, 30, 30)];
    mapView.userInteractionEnabled = YES;
    mapView.image = [UIImage imageNamed:@"地图定位_xhdpi"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapViewClick)];
    tap.numberOfTapsRequired = 1;
    [mapView addGestureRecognizer:tap];
    [scrollView addSubview:mapView];
    
    //任务类型
    UILabel *taskTypeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, addressLable.bottom+8, self.view.width-20, 30)];
    if ([_taskMsg[@"tasktype"] integerValue] == 0) {
        taskTypeLable.text = @"类型:普通任务";
    }
    else {
        taskTypeLable.text = @"类型:时限任务";
    }
    [scrollView addSubview:taskTypeLable];
    
    //参与人员
    if ([_taskMsg[@"is_closed"] integerValue] == 0) {
        UILabel *addPersonLable = [[UILabel alloc]initWithFrame:CGRectMake(0, taskTypeLable.bottom+16, self.view.width/3-20, 30)];
        addPersonLable.text = @"参与人员:";
        [scrollView addSubview:addPersonLable];
        
        UIButton *addPersonNumber = [UIButton buttonWithType:UIButtonTypeCustom];
        [addPersonNumber setTitle:[NSString stringWithFormat:@"已有%ld人报名",(long)[_taskMsg[@"apply_num"] integerValue]] forState:UIControlStateNormal];
        [addPersonNumber setTitleColor:[UIColor colorWithRed:0.384f green:0.408f blue:0.898f alpha:1.00f] forState:UIControlStateNormal];
        [addPersonNumber setBackgroundImage:[UIImage imageNamed:@"已有报名_xhdpi"] forState:UIControlStateNormal];
        addPersonNumber.frame = CGRectMake(addPersonLable.right,addPersonLable.origin.y, self.view.width/3+20, 30);
        [scrollView addSubview:addPersonNumber];
        
        UIButton *iWant = [UIButton buttonWithType:UIButtonTypeCustom];
        [iWant setTitle:@"我要指派" forState:UIControlStateNormal];
        [iWant setBackgroundImage:[UIImage imageNamed:@"我要指派_xhdpi"] forState:UIControlStateNormal];
        iWant.frame = CGRectMake(addPersonNumber.right, addPersonLable.origin.y, self.view.width/3, 30);
        [iWant addTarget:self action:@selector(iWantClick) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:iWant];
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-50, self.view.width, 50)];
        buttonView.backgroundColor = [UIColor colorWithRed:0.388f green:0.431f blue:0.953f alpha:1.00f];
        [self.view addSubview:buttonView];
        
        UIButton *closeTask = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeTask setTitle:@"关闭任务" forState:UIControlStateNormal];
        [closeTask setBackgroundColor:[UIColor colorWithRed:0.388f green:0.431f blue:0.953f alpha:1.00f]];
        closeTask.frame = CGRectMake(10, 5, (buttonView.width-40)/2, 40);
        [closeTask addTarget:self action:@selector(closeTask) forControlEvents:UIControlEventTouchUpInside];
        closeTask.layer.borderWidth = 1;
        closeTask.layer.borderColor = ([UIColor whiteColor].CGColor);
        [buttonView addSubview:closeTask];
        
        NSDate *nowDate = [NSDate date];
        NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
        
        if (nowTime > [_taskMsg[@"begintime"] doubleValue]) {
            UIButton *endTask = [UIButton buttonWithType:UIButtonTypeCustom];
            [endTask setTitle:@"任务完成" forState:UIControlStateNormal];
            [endTask setBackgroundColor:[UIColor colorWithRed:0.388f green:0.431f blue:0.953f alpha:1.00f]];
            endTask.frame = CGRectMake(closeTask.right+20, 5, (buttonView.width-40)/2, 40);
            [endTask addTarget:self action:@selector(endTask) forControlEvents:UIControlEventTouchUpInside];
            endTask.layer.borderWidth = 1;
            endTask.layer.borderColor = ([UIColor whiteColor].CGColor);
            [buttonView addSubview:endTask];
        }

        
        scrollView.contentSize = CGSizeMake(self.view.width,dateLable.height+8+progressView.height+8+stateLable1.height+16+imgScrollView.height+16+subjectLable.height+8+timeLable.height+8+addressLable.height+8+taskTypeLable.height+16+addPersonLable.height+8+16);
    }
    else {
        
        UILabel *closeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, taskTypeLable.bottom+8, scrollView.width-60, 40)];
        closeLabel.text = @"任务已关闭";
        closeLabel.textAlignment = NSTextAlignmentCenter;
        closeLabel.font = [UIFont systemFontOfSize:18];
        [scrollView addSubview:closeLabel];
        
        scrollView.contentSize = CGSizeMake(scrollView.width, dateLable.height+8+progressView.height+8+stateLable1.height+16+imgScrollView.height+16+subjectLable.height+8+timeLable.height+8+addressLable.height+8+closeLabel.height);
    }
    
    
}

//关闭任务
- (void)closeTask {
    [DataService requestURL:[NSString stringWithFormat:@"%@setTaskStatus",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":infoDic[@"promulgator_id"],@"type":@"1",@"task_id":_taskMsg[@"id"]} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"关闭成功"];
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

//完成任务
- (void)endTask {
    [DataService requestURL:[NSString stringWithFormat:@"%@setTaskStatus",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":infoDic[@"promulgator_id"],@"type":@"2",@"task_id":_taskMsg[@"id"]} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"关闭成功"];
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

//我要指派
- (void)iWantClick {
    MyCollectController *mycollectVC = [[MyCollectController alloc]init];
    mycollectVC.taskID = _taskMsg[@"id"];
    [self.navigationController pushViewController:mycollectVC animated:YES];
}

- (void)mapViewClick {
    ShowAddressController *SAVC = [[ShowAddressController alloc]init];
    SAVC.latitude = [self.taskMsg[@"address_lat"] doubleValue];
    SAVC.longitude = [self.taskMsg[@"address_lng"] doubleValue];
    [self.navigationController pushViewController:SAVC animated:YES];
}


- (void)scrollImgScrillView:(NSTimer *)timer {
    scrollPointX = scrollPointX + 1;
    pageControl.currentPage = scrollPointX/imgScrollView.width;
    imgScrollView.contentOffset = CGPointMake(scrollPointX,0);
    if (scrollPointX == imgScrollView.width*picARR.count) {
        scrollPointX = 0;
        pageControl.currentPage = 0;
    }
    if (scrollPointX%(NSInteger)imgScrollView.width == 0 || scrollPointX == 0) {
        [timer invalidate];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.5f];
    }
    
}
- (void)delayMethod {
    [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(scrollImgScrillView:) userInfo:nil repeats:YES];
}


@end
