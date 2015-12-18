//
//  CheckingController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/9.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "CheckingController.h"
#import "UILabel+StringFrame.h"
#import "ShowAddressController.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"
#import "IssusMessageController.h"

@interface CheckingController (){
    NSInteger scrollPointX;
    UIScrollView *imgScrollView;
    UIPageControl *pageControl;
    NSArray *picARR;
}

@end

@implementation CheckingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布详情";
    self.view.backgroundColor = [UIColor whiteColor];
    scrollPointX = 0;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 30);
    [rightButton setTitle:@"修改" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(changeTaskButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setTaskMsg:(NSDictionary *)taskMsg {
    _taskMsg = taskMsg;
    [self _createView];
}

- (void)_createView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    

    //时间标签
    UILabel *dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, self.view.width/4, 30)];
    dateLable.text = [Utility timeintervalToDate:[_taskMsg[@"createtime"] integerValue] Formatter:@"MM月dd日"];
    [scrollView addSubview:dateLable];
    
    UILabel *checkTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(dateLable.right, dateLable.top, dateLable.width, 30)];
    checkTimeLabel.text = [Utility timeintervalToDate:[_taskMsg[@"checktime"] integerValue] Formatter:@"MM月dd日"];
    
    UIImageView *progressView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8+dateLable.bottom, self.view.width, 20)];
    progressView.image = [UIImage imageNamed:@"状态2_xxhdpi"];
    [scrollView addSubview:progressView];
    
    //状态标签1
    UILabel *stateLable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 8+progressView.bottom, self.view.width/4, 30)];
    stateLable1.text = @"提交";
    [scrollView addSubview:stateLable1];
    
    UILabel *stateLable2 = [[UILabel alloc]initWithFrame:CGRectMake(stateLable1.right, stateLable1.origin.y, self.view.width/4, 30)];
    stateLable2.text = @"审核中";
    [scrollView addSubview:stateLable2];
    
    
    NSString *picArrStr = _taskMsg[@"sub_pic"];
    NSData *data = [picArrStr dataUsingEncoding:NSUTF8StringEncoding];
    picARR = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //显示图片
    imgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, stateLable1.bottom, self.view.width, self.view.width*3/5)];
    for (int i = 0; i<picARR.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width*i, 0, self.view.width,self.view.width*3/5)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,picARR[i]]] placeholderImage:[UIImage imageNamed:@"主图_xhdpi"]];
        [imgScrollView addSubview:imgView];
    }
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,picARR[0]]] placeholderImage:[UIImage imageNamed:@"主图_xhdpi"]];
    imgView.frame = CGRectMake(imgScrollView.width*picARR.count, 0, imgScrollView.width, imgScrollView.height);
    [imgScrollView addSubview:imgView];
    scrollView.contentSize = CGSizeMake(self.view.width*picARR.count, self.view.width*3/5);
    if (picARR.count != 1) {
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
        [scrollView addSubview:imgScrollView];
    }
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, imgScrollView.bottom-10, imgScrollView.width, 10)];
    pageControl.numberOfPages = picARR.count;
    [scrollView addSubview:imgScrollView];
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
    CGSize size = [subjectLable boundingRectWithSize:CGSizeMake(self.view.width-20, 0)];
    subjectLable.frame = CGRectMake(20, imgScrollView.bottom+16, size.width,size.height );
    [scrollView addSubview:subjectLable];
    
    //显示时间
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, subjectLable.bottom+8, self.view.width-20, 30)];
    NSString *beginTime = [Utility timeintervalToDate:[_taskMsg[@"begintime"] integerValue] Formatter:@"yyyy年MM月dd日hh时"];
    NSString *endTime;
    if ([_taskMsg[@"endtime"] integerValue] != 0) {
        endTime = [Utility timeintervalToDate:[_taskMsg[@"endtime"] integerValue] Formatter:@"yyyy年MM月dd日hh时"];
        timeLable.text = [NSString stringWithFormat:@"时间:%@-%@",beginTime,endTime];

    }
    else {
        timeLable.text = [NSString stringWithFormat:@"时间：%@",beginTime];
    }
    timeLable.adjustsFontSizeToFitWidth = YES;
    [scrollView addSubview:timeLable];
    
    //显示地点
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(20, timeLable.bottom,self.view.width-20, 30)];
    addressLable.text = [NSString stringWithFormat:@"任务地点：%@",_taskMsg[@"address"]];
    [scrollView addSubview:addressLable];
    
    //地图图标
    UIImageView *mapView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-60, addressLable.origin.y+5, 15, 20)];
    mapView.userInteractionEnabled = YES;
    mapView.image = [UIImage imageNamed:@"地图定位_xhdpi"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapViewClick)];
    tap.numberOfTapsRequired = 1;
    [mapView addGestureRecognizer:tap];
    [scrollView addSubview:mapView];
    
    //任务类型
    UILabel *taskTypeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, addressLable.bottom, self.view.width-20, 30)];
    if ([_taskMsg[@"tasktype"] integerValue] == 0) {
           taskTypeLable.text = @"类型:普通任务";
    }
    else {
        taskTypeLable.text = @"类型:时限任务";
    }
    [scrollView addSubview:taskTypeLable];
    
    //详情介绍
    UILabel *detailLable = [[UILabel alloc]initWithFrame:CGRectMake(20, taskTypeLable.bottom, self.view.width-20, 30)];
    detailLable.text = @"详情介绍:";
    [scrollView addSubview:detailLable];
    
    //详情内容
    UILabel *contentLable = [[UILabel alloc]init];
    contentLable.font = [UIFont systemFontOfSize:16];
    contentLable.numberOfLines = 0;
    contentLable.text = _taskMsg[@"content"];
    CGSize size1 = [contentLable boundingRectWithSize:CGSizeMake(self.view.width-20, 0)];
    contentLable.frame = CGRectMake(20, detailLable.bottom, size1.width, size1.height);
    [scrollView addSubview:contentLable];
    
    scrollView.contentSize = CGSizeMake(self.view.width, dateLable.height+8+progressView.height+8+stateLable1.height+16+imgScrollView.height+16+subjectLable.height+8+timeLable.height+8+addressLable.height+8+taskTypeLable.height+16+detailLable.height+8+contentLable.height+48);
}

//地图
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

- (void)changeTaskButtonClick {
    IssusMessageController *issusMSGVC = [[IssusMessageController alloc]init];
    issusMSGVC.dataDic = _taskMsg;
    [self.navigationController pushViewController:issusMSGVC animated:YES];
}
@end
