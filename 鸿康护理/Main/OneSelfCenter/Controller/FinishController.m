//
//  FinishController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/9.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "FinishController.h"
#import "UILabel+StringFrame.h"
#import "CollectionCell.h"
#import "ShowAddressController.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"

@interface FinishController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    UIScrollView *scrollView;
    UILabel *detailsLable;
    UICollectionView *personView;
    NSArray *addNurseArr;
}

@end

@implementation FinishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布详情";
    self.view.backgroundColor = [UIColor whiteColor];
    addNurseArr = _taskMsg[@"join_nurse_list"];
    [self _createView];
    

}

- (void)_createView {
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    scrollView.backgroundColor = [UIColor greenColor];
//    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    //时间标签
    UILabel *dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, self.view.width/4, 30)];
    dateLable.text = [Utility timeintervalToDate:[_taskMsg[@"createtime"] doubleValue] Formatter:@"MM月dd日"];
    [scrollView addSubview:dateLable];
    
    UILabel *checkTime = [[UILabel alloc]initWithFrame:CGRectMake(dateLable.right*2, dateLable.top, dateLable.width, 30)];
    checkTime.textAlignment = NSTextAlignmentRight;
    checkTime.text = [Utility timeintervalToDate:[_taskMsg[@"checktime"] doubleValue] Formatter:@"MM月dd日"];
    [scrollView addSubview:checkTime];
    
    UILabel *endTime = [[UILabel alloc]initWithFrame:CGRectMake(checkTime.right, dateLable.top, dateLable.width, 30)];
    endTime.textAlignment = NSTextAlignmentRight;
    if ([_taskMsg[@"endtime"] integerValue] != 0) {
        if ([_taskMsg[@"updatetime"] doubleValue] < [_taskMsg[@"endtime"] doubleValue]) {
            endTime.text = [Utility timeintervalToDate:[_taskMsg[@"updatetime"] doubleValue] Formatter:@"MM月dd日"];
        }
        else {
            endTime.text = [Utility timeintervalToDate:[_taskMsg[@"endtime"] doubleValue] Formatter:@"MM月dd日"];
        }
    }
    else {
        endTime.text = [Utility timeintervalToDate:[_taskMsg[@"updatetime"] doubleValue] Formatter:@"MM月dd日"];
    }
    
    UIImageView *progressView = [[UIImageView alloc]initWithFrame:CGRectMake(0, dateLable.bottom+8, self.view.width, 20)];
    progressView.image = [UIImage imageNamed:@"状态4_xxhdpi"];
    [scrollView addSubview:progressView];
    
    //状态标签1
    UILabel *stateLable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 8+progressView.bottom, self.view.width/4, 30)];
    stateLable1.text = @"提交";
    [scrollView addSubview:stateLable1];
    
    UILabel *stateLable2 = [[UILabel alloc]initWithFrame:CGRectMake(stateLable1.right, stateLable1.origin.y, self.view.width/4, 30)];
    stateLable2.text = @"审核中";
    [scrollView addSubview:stateLable2];
    
    UILabel *stateLable3 = [[UILabel alloc]initWithFrame:CGRectMake(stateLable2.right, stateLable2.origin.y, self.view.width/4, 30)];
    stateLable3.text = @"进行中";
    stateLable3.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:stateLable3];
    
    UILabel *stateLable4 = [[UILabel alloc]initWithFrame:CGRectMake(stateLable3.right, stateLable2.origin.y, self.view.width/4, 30)];
    stateLable4.text = @"任务结束";
    stateLable4.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:stateLable4];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, stateLable1.bottom+16, 10, 30)];
    label.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:label];
    
    //显示主题
    UILabel *subjectLable = [[UILabel alloc]init];
    subjectLable.font = [UIFont systemFontOfSize:21];
    subjectLable.numberOfLines = 0;
    subjectLable.text = _taskMsg[@"subject"];
    CGSize size = [subjectLable boundingRectWithSize:CGSizeMake(self.view.width-20, 0)];
    subjectLable.frame = CGRectMake(20, stateLable1.bottom+16, size.width,size.height );
    [scrollView addSubview:subjectLable];
    
    //显示时间
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, subjectLable.bottom+8, self.view.width, 30)];
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
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(20, timeLable.bottom+8,self.view.width, 30)];
    addressLable.text = [NSString stringWithFormat:@"地点:%@",_taskMsg[@"address"]];
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
    UILabel *taskTypeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, addressLable.bottom+8, self.view.width, 30)];
    if ([_taskMsg[@"tasktype"] integerValue] == 0) {
        taskTypeLable.text = @"类型:普通任务";
    }
    else {
        taskTypeLable.text = @"类型:时限任务";
    }
    [scrollView addSubview:taskTypeLable];
    
    UILabel *detailIntroduceLable = [[UILabel alloc]initWithFrame:CGRectMake(20, taskTypeLable.bottom+16, self.view.width, 30)];
    detailIntroduceLable.text = @"详情介绍:";
    [scrollView addSubview:detailIntroduceLable];
    
    detailsLable = [[UILabel alloc]init];
    detailsLable.font = [UIFont systemFontOfSize:16];
    detailsLable.text = _taskMsg[@"content"];
    detailsLable.numberOfLines = 0;
    CGSize size3 = [detailsLable boundingRectWithSize:CGSizeMake(self.view.width-16-20,0)];
    detailsLable.frame = CGRectMake(28, detailIntroduceLable.bottom, size3.width, size3.height);
    [scrollView addSubview:detailsLable];
    
    //参与人员
    UILabel *addPerson = [[UILabel alloc]initWithFrame:CGRectMake(0, detailsLable.bottom+8, self.view.width, 30)];
    addPerson.text = @"参与人员列表：";
    addPerson.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:addPerson];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((self.view.width-40)/5, (self.view.width-40)/5+30);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 3;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    personView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    personView.backgroundColor = [UIColor whiteColor];
    
    if (addNurseArr.count%5 == 0) {
        personView.frame = CGRectMake(0, addPerson.bottom+10, self.view.width, self.view.width/5*(addNurseArr.count/5)+(30*addNurseArr.count/5));
    }
    else {
        personView.frame = CGRectMake(0, addPerson.bottom+10, self.view.width, self.view.width/5*(addNurseArr.count/5+1)+30*(addNurseArr.count/5+1));
    }
    personView.delegate = self;
    personView.dataSource = self;
    [personView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"Collection_Cell"];
    [scrollView addSubview:personView];
    
    
    scrollView.contentSize = CGSizeMake(self.view.width, dateLable.height+8+progressView.height+8+stateLable1.height+16+subjectLable.height+16+timeLable.height+8+addressLable.height+8+taskTypeLable.height+16+detailIntroduceLable.height+detailsLable.height+16+personView.height+10+100);
}


- (void)mapViewClick {
    ShowAddressController *SAVC = [[ShowAddressController alloc]init];
    SAVC.latitude = [self.taskMsg[@"address_lat"] doubleValue];
    SAVC.longitude = [self.taskMsg[@"address_lng"] doubleValue];
    [self.navigationController pushViewController:SAVC animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return addNurseArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection_Cell" forIndexPath:indexPath];
    cell.infoDic = addNurseArr[indexPath.row];
    return cell;
}
@end
