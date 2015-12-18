//
//  IssusMessageController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "IssusMessageController.h"
#import "PreviewController.h"
#import "SelectedCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapController.h"
#import "ShowAddressController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MyIssusController.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"
#import "XSDatePicker.h"

@interface IssusMessageController ()<UIActionSheetDelegate> {
    UIView *timeView1;//用于任务选择
    NSDictionary *dic;
    UIImagePickerController *pckerController2;
    UIImagePickerController *pckerController1;
    UIImagePickerController *pckerController3;
    UIImagePickerController *pckerController4;
    UITableView *taskSelectTableView;
    NSArray *taskArr;
    NSString *identy;

    PreviewController *preVC;
    MapController *mapVC;
    ShowAddressController *SAVC;
    
    UIImage *subjectIMG;
    UIImage *subjectIMG2;
    UIImage *subjectIMG3;
    UIImage *subjectIMG4;
    
    UITextField *moneyText;
    UIScrollView *scroll;
    
    UIView *bgView;
    UIView *endView;
    
    NSString *typeStr;
    
    NSDictionary *msgDic;
    
    AMapGeoPoint *point;
    
    NSMutableArray *sub_picArr;
    UIView *garyView;
    
    NSDate *beginDate;
    NSDate *endDate;
    
    UILabel *beginLabel;
    UILabel *endLabel;
}


@end

@implementation IssusMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布任务";
    dic = @{}.copy;
    
    sub_picArr = @[].mutableCopy;
    
    msgDic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addressIsTure:) name:addressIsTrue object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addressIsNotrue) name:addressIsNotTrue object:nil];
    taskArr = @[@"普通任务",@"时限任务"];
    identy = @"task_cell";
    preVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewController"];
    mapVC = [[MapController alloc]init];
    
    [self _createView];
    
    [self _createTap];
    
    [self _createTextView];
    
    [self _addDataDic];
//    [self _hiddenView];
    
    
}

- (void)_createView {
    scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroll.backgroundColor = [UIColor colorWithRed:0.933f green:0.933f blue:0.933f alpha:1.00f];
    [self.view addSubview:scroll];
    
    garyView = [[UIView alloc]initWithFrame:self.view.bounds];
    garyView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.7];
    garyView.hidden = YES;
    [self.view addSubview:garyView];
    
    
    subjectText = [[UITextField alloc]initWithFrame:CGRectMake(8, 8, scroll.width-16, 50)];
    subjectText.font = [UIFont systemFontOfSize:20];
    subjectText.placeholder = @"输入主题";
    subjectText.backgroundColor = [UIColor whiteColor];
    subjectText.textAlignment = NSTextAlignmentCenter;
    [scroll addSubview:subjectText];
    
    taskLable = [[UILabel alloc]initWithFrame:CGRectMake(38, subjectText.bottom+8, (scroll.width-24)/2-40, 40)];
    taskLable.backgroundColor = [UIColor whiteColor];
    taskLable.text = @"普通任务";
    taskLable.textAlignment = NSTextAlignmentCenter;
    [scroll addSubview:taskLable];
    typeStr = @"0";
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(taskLable.right-20, taskLable.top+10, 20, 20)];
    imgView.image = [UIImage imageNamed:@"下拉箭头_xhdpi"];
    [scroll addSubview:imgView];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, taskLable.top, 40, 40)];
    typeLabel.backgroundColor = [UIColor whiteColor];
    typeLabel.text = @"类型";
    typeLabel.textAlignment = NSTextAlignmentCenter;

    [scroll addSubview:typeLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right, taskLable.top+10, 1, 20)];
    lineLabel.backgroundColor = [UIColor grayColor];
    [scroll addSubview:lineLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(taskLable.right+18, taskLable.top, typeLabel.width, 40)];
    moneyLabel.text = @"佣金";
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:moneyLabel];
    
    moneyText = [[UITextField alloc]initWithFrame:CGRectMake(moneyLabel.right, taskLable.top, taskLable.width, 40)];
    moneyText.keyboardType = UIKeyboardTypeNumberPad;
    moneyText.backgroundColor = [UIColor whiteColor];
    moneyText.textAlignment = NSTextAlignmentCenter;
    [scroll addSubview:moneyText];
    
    UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right, lineLabel.top, 1, 20)];
    lineLabel1.backgroundColor = [UIColor grayColor];
    [scroll addSubview:lineLabel1];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, taskLable.bottom+8, 40, 40)];
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.text = @"时间";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [scroll addSubview:timeLabel];
    
    
    beginLabel = [[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right, taskLable.bottom+8, scroll.width-timeLabel.width-8, 40)];
    beginLabel.text = @"    点击选择开始时间";
    beginLabel.backgroundColor = [UIColor whiteColor];
    beginLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *beginTimeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBeginTime)];
    [beginLabel addGestureRecognizer:beginTimeTap];
    [scroll addSubview:beginLabel];
    
//    beginMonthText = [[UITextField alloc]initWithFrame:CGRectMake(timeLabel.right, taskLable.bottom+8, (scroll.width-156)/3, 40)];
//    beginMonthText.backgroundColor = [UIColor whiteColor];
//    beginMonthText.textAlignment = NSTextAlignmentCenter;
//    beginMonthText.delegate = self;
//    beginMonthText.keyboardType = UIKeyboardTypeNumberPad;
//    [scroll addSubview:beginMonthText];
//    
//    UILabel *beginMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(beginMonthText.right, beginMonthText.top, 20, 40)];
//    beginMonthLabel.text = @"月";
//    beginMonthLabel.backgroundColor = [UIColor whiteColor];
//    [scroll addSubview:beginMonthLabel];
//    
//    beginDayText = [[UITextField alloc]initWithFrame:CGRectMake(beginMonthLabel.right, beginMonthLabel.top, beginMonthText.width, 40)];
//    beginDayText.backgroundColor = [UIColor whiteColor];
//    beginDayText.textAlignment = NSTextAlignmentCenter;
//    beginDayText.keyboardType = UIKeyboardTypeNumberPad;
//    beginDayText.delegate = self;
//    [scroll addSubview:beginDayText];
//    
//    UILabel *beginDayLable = [[UILabel alloc]initWithFrame:CGRectMake(beginDayText.right, beginDayText.top, 20, 40)];
//    beginDayLable.text = @"日";
//    beginDayLable.backgroundColor = [UIColor whiteColor];
//    [scroll addSubview:beginDayLable];
//    
//    beginHourText = [[UITextField alloc]initWithFrame:CGRectMake(beginDayLable.right, beginDayLable.top, beginMonthText.width, 40)];
//    beginHourText.backgroundColor = [UIColor whiteColor];
//    beginHourText.textAlignment = NSTextAlignmentCenter;
//    beginHourText.keyboardType = UIKeyboardTypeNumberPad;
//    beginHourText.delegate = self;
//    [scroll addSubview:beginHourText];
//    
//    UILabel *beginHourLable = [[UILabel alloc]initWithFrame:CGRectMake(beginHourText.right, beginHourText.top, 20, 40)];
//    beginHourLable.backgroundColor = [UIColor whiteColor];
//    beginHourLable.text = @"时";
//    [scroll addSubview:beginHourLable];
//    
    beginTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(scroll.right-48, beginLabel.top, 40, 40)];
    beginTimeLable.textColor = [UIColor grayColor];
    beginTimeLable.text = @"开始";
    beginTimeLable.textAlignment = NSTextAlignmentRight;
    beginTimeLable.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:beginTimeLable];
//
    endView = [[UIView alloc]initWithFrame:CGRectMake(48, beginLabel.bottom, scroll.width-16-40, 40)];
    endView.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:endView];
//
//    
//    monthText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, (endView.width-100)/3, 40)];
//    monthText.backgroundColor = [UIColor whiteColor];
//    monthText.delegate = self;
//    monthText.keyboardType = UIKeyboardTypeNumberPad;
//    monthText.textAlignment = NSTextAlignmentCenter;
//    [endView addSubview:monthText];
//    
//    monthLabke = [[UILabel alloc]initWithFrame:CGRectMake(monthText.right, 0, 20, 40)];
//    monthLabke.text = @"月";
//    monthLabke.backgroundColor = [UIColor whiteColor];
//    [endView addSubview:monthLabke];
//    
//    dayText = [[UITextField alloc]initWithFrame:CGRectMake(monthLabke.right, 0, monthText.width, 40)];
//    dayText.backgroundColor = [UIColor whiteColor];
//    dayText.textAlignment = NSTextAlignmentCenter;
//    dayText.delegate = self;
//    dayText.keyboardType = UIKeyboardTypeNumberPad;
//    [endView addSubview:dayText];
//    
//    dayLable = [[UILabel alloc]initWithFrame:CGRectMake(dayText.right, 0, beginDayLable.width, 40)];
//    dayLable.backgroundColor = [UIColor whiteColor];
//    dayLable.text = @"日";
//    [endView addSubview:dayLable];
//    
//    hourText = [[UITextField alloc]initWithFrame:CGRectMake(dayLable.right, 0, beginHourText.width, 40)];
//    hourText.backgroundColor = [UIColor whiteColor];
//    hourText.delegate = self;
//    hourText.keyboardType = UIKeyboardTypeNumberPad;
//    hourText.textAlignment = NSTextAlignmentCenter;
//    [endView addSubview:hourText];
//    
//    hourLable = [[UILabel alloc]initWithFrame:CGRectMake(hourText.right, 0, 20, 40)];
//    hourLable.backgroundColor = [UIColor whiteColor];
//    hourLable.text = @"时";
//    [endView addSubview:hourLable];
//
    
    endLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , beginLabel.width, 40)];
    endLabel.text = @"    点击选择结束时间";
    endLabel.backgroundColor = [UIColor whiteColor];
    endLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *endtimeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeSelect)];
    [endLabel addGestureRecognizer:endtimeTap];
    [endView addSubview:endLabel];
    
    endTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(endLabel.right-48, 0, beginTimeLable.width, 40)];
    endTimeLable.textColor = [UIColor grayColor];
    endTimeLable.backgroundColor = [UIColor whiteColor];
    endTimeLable.text = @"结束";
    endTimeLable.textAlignment = NSTextAlignmentCenter;
    [endView addSubview:endTimeLable];
    
    UILabel *lineLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(monthText.left, monthText.top+10, 1, 20)];
    lineLabel3.backgroundColor = [UIColor grayColor];
    [endView addSubview:lineLabel3];
    
    endView.hidden = YES;
    
    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right, timeLabel.top+10, 1, 20)];
    lineLabel2.backgroundColor = [UIColor grayColor];
    [scroll addSubview:lineLabel2];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(8,beginLabel.bottom+8 , scroll.width-16, 370)];
    bgView.backgroundColor = [UIColor colorWithRed:0.933f green:0.933f blue:0.933f alpha:1.00f];
    [scroll addSubview:bgView];
    
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    placeLabel.backgroundColor = [UIColor whiteColor];
    placeLabel.text = @"地点";
    [bgView addSubview:placeLabel];
    
    placeText = [[UITextField alloc]initWithFrame:CGRectMake(placeLabel.right, 0, bgView.width-60, 40)];
    placeText.backgroundColor = [UIColor whiteColor];
    placeText.delegate = self;
    placeText.placeholder = @"        请具体到门牌号";
    [bgView addSubview:placeText];
    
    UILabel *lineLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(placeLabel.right, placeLabel.top+10, 1, 20)];
    lineLabel5.backgroundColor = [UIColor grayColor];
    [bgView addSubview:lineLabel5];
    
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(placeText.right, placeText.top, 20, 40)];
    placeView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:placeView];
    
    placeImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    placeImg.backgroundColor = [UIColor whiteColor];
    placeImg.image = [UIImage imageNamed:@"地图定位_xhdpi"];
    placeImg.hidden = YES;
    [placeView addSubview:placeImg];
    
    contentText = [[UITextView alloc]initWithFrame:CGRectMake(0, placeText.bottom+8, bgView.width, 200)];
    contentText.backgroundColor = [UIColor whiteColor];
    contentText.delegate = self;
    contentText.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:contentText];
    
    UILabel *lineLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(10, contentText.bottom, bgView.width-20, 1)];
    lineLabel4.backgroundColor = [UIColor grayColor];
    [bgView addSubview:lineLabel4];
    
    numberLable = [[UILabel alloc]initWithFrame:CGRectMake(0, contentText.bottom-30, bgView.width, 20)];
    numberLable.text = @"0/1000";
    numberLable.font = [UIFont systemFontOfSize:14];
    numberLable.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:numberLable];
    
    UIView *picView = [[UIView alloc]initWithFrame:CGRectMake(0, contentText.bottom+10, bgView.width, 60)];
    picView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:picView];
    
    UILabel *insertPicLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, bgView.width-240, 25)];
    insertPicLabel.backgroundColor = [UIColor whiteColor];
    insertPicLabel.text = @"插入图片";
    insertPicLabel.textAlignment = NSTextAlignmentCenter;
    insertPicLabel.font = [UIFont systemFontOfSize:14];
    [picView addSubview:insertPicLabel];
    
    UILabel *picNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, insertPicLabel.bottom, insertPicLabel.width, 25)];
    picNumber.backgroundColor = [UIColor whiteColor];
    picNumber.textAlignment = NSTextAlignmentCenter;
    picNumber.text = @"(最多4张)";
    picNumber.textColor = [UIColor grayColor];
    picNumber.font = [UIFont systemFontOfSize:14];
    [picView addSubview:picNumber];
    
    addPic1 = [[UIImageView alloc]initWithFrame:CGRectMake(insertPicLabel.right, 5, 50, 50)];
    addPic1.image = [UIImage imageNamed:@"插入图片_xhdpi"];
    [picView addSubview:addPic1];
    
    addPic2 = [[UIImageView alloc]initWithFrame:CGRectMake(addPic1.right+10, 5, 50, 50)];
    addPic2.image = [UIImage imageNamed:@"插入图片_xhdpi"];
    [picView addSubview:addPic2];
    
    addPic3 = [[UIImageView alloc]initWithFrame:CGRectMake(addPic2.right+10, 5, 50, 50)];
    addPic3.image = [UIImage imageNamed:@"插入图片_xhdpi"];
    [picView addSubview:addPic3];
    
    addPic4 = [[UIImageView alloc]initWithFrame:CGRectMake(addPic3.right+10, 5, 50, 50)];
    addPic4.image = [UIImage imageNamed:@"插入图片_xhdpi"];
    [picView addSubview:addPic4];
    
    reviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reviewButton.frame = CGRectMake(5, picView.bottom+15, bgView.width/2-20, 40);
    reviewButton.layer.masksToBounds = YES;
    reviewButton.layer.cornerRadius = 4;
    reviewButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    [reviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reviewButton setTitle:@"预览" forState:UIControlStateNormal];
    [reviewButton addTarget:self action:@selector(reviewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:reviewButton];
    
    commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(reviewButton.right+30, reviewButton.top, reviewButton.width, 40);
    commitButton.layer.masksToBounds = YES;
    commitButton.layer.cornerRadius = 4;
    commitButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [bgView addSubview:commitButton];
    
    scroll.contentSize = CGSizeMake(scroll.width, 10+subjectText.height+8+taskLable.height+8+beginLabel.height+8+bgView.height+10+69+40);
    
}

- (void)endTimeSelect {
    garyView.hidden = NO;
    if (beginDate == nil) {
        beginDate = [NSDate date];
    }
    XSDatePicker *datePick = [[XSDatePicker alloc]initWithFrame:CGRectMake(0, 200, self.view.width, self.view.height-200) Mode:UIDatePickerModeDateAndTime CurrentDate:beginDate MaxDate:nil MinDate:[NSDate date] OKAction:^(NSDate *date) {
        garyView.hidden = YES;
        endDate = date;
        NSTimeInterval begintime1 = [date timeIntervalSince1970];
        endLabel.text = [Utility timeintervalToDate:begintime1 Formatter:@"    yyyy年MM月dd日HH时"];
    }];
    [garyView addSubview:datePick];
}

- (void)selectBeginTime {
    garyView.hidden = NO;
    XSDatePicker *datePick = [[XSDatePicker alloc]initWithFrame:CGRectMake(0, 200, self.view.width, self.view.height-200) Mode:UIDatePickerModeDateAndTime CurrentDate:[NSDate date] MaxDate:nil MinDate:[NSDate date] OKAction:^(NSDate *date) {
        garyView.hidden = YES;
        beginDate = date;
        NSTimeInterval begintime1 = [date timeIntervalSince1970];
        beginLabel.text = [Utility timeintervalToDate:begintime1 Formatter:@"    yyyy年MM月dd日HH时"];
        
    }];
    [garyView addSubview:datePick];
}

- (void)addressIsNotrue {
    [SVProgressHUD showErrorWithStatus:@"地址输入错误"];
}

- (void)addressIsTure:(NSNotification *)aNotification {
    NSDictionary *pointDic = aNotification.userInfo;
    point = pointDic[@"point"];
    placeImg.hidden = NO;
    SAVC = [[ShowAddressController alloc]init];
    SAVC.longitude = point.longitude;
    SAVC.latitude = point.latitude;

}
//填充数据
- (void)_addDataDic {
    if (self.dataDic != nil) {
        self.title = @"修改发布";
        subjectText.text = _dataDic[@"subject"];
        moneyText.text = _dataDic[@"commission"];
        if ([_dataDic[@"tasktype"] integerValue] == 0) {
            taskLable.text = @"普通任务";
            typeStr = @"0";
        }else {
            endView.hidden = NO;
            taskSelectTableView.hidden = YES;
            timeLabel.height = 80;
            
            bgView.transform = CGAffineTransformMakeTranslation(0, 40);
            taskLable.text = @"时限任务";
            typeStr = @"1";
            endLabel.text = [Utility timeintervalToDate:[_dataDic[@"endtime"] doubleValue] Formatter:@"MM月dd日HH时"];
            endDate = [Utility stringToDate:endLabel.text Formatter:@"MM月dd日HH时"];

            
        }
        beginLabel.text = [Utility timeintervalToDate:[_dataDic[@"begintime"] doubleValue] Formatter:@"MM月dd日HH时"];
        beginDate = [Utility stringToDate:beginLabel.text Formatter:@"MM月dd日HH时"];
        placeText.text = _dataDic[@"address"];
        point = [[AMapGeoPoint alloc]init];
        point.latitude = [_dataDic[@"address_lat"] doubleValue];
        point.longitude = [_dataDic[@"address_lng"] doubleValue];
        placeImg.hidden = NO;
        contentText.text = _dataDic[@"content"];
        NSArray *imgViews = @[addPic1,addPic2,addPic3,addPic4];
        NSData *data = [_dataDic[@"sub_pic"] dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *imgArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i < imgArr.count; i++) {
            
            UIImageView *imgView = imgViews[i];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,imgArr[i]]]];
            switch (i) {
                case 0:
                    subjectIMG = imgView.image;
                    break;
                case 1:
                    subjectIMG2 = imgView.image;
                    break;
                    case 2:
                    subjectIMG3 = imgView.image;
                    break;
                default:
                    subjectIMG4 = imgView.image;
                    break;
            }
        }
        
        
    }
}

- (void)_createTap {
    UITapGestureRecognizer *addPic1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic1Click)];
    addPic1Tap.numberOfTapsRequired = 1;
    [addPic1 addGestureRecognizer:addPic1Tap];
    addPic1.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *addPic2Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic2Click)];
    addPic2Tap.numberOfTapsRequired = 1;
    [addPic2 addGestureRecognizer:addPic2Tap];
    addPic2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *addPic3Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic3Click)];
    addPic3Tap.numberOfTapsRequired = 1;
    [addPic3 addGestureRecognizer:addPic3Tap];
    addPic3.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *addPic4Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic4Click)];
    addPic4Tap.numberOfTapsRequired = 1;
    [addPic4 addGestureRecognizer:addPic4Tap];
    addPic4.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tap.numberOfTapsRequired = 1;
    selectTask.userInteractionEnabled = YES;
    [selectTask addGestureRecognizer:tap];
    taskLable.userInteractionEnabled = YES;
    [taskLable addGestureRecognizer:tap];

    
    
    UITapGestureRecognizer *placeSeleted = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(placeSelected)];
    placeSeleted.numberOfTapsRequired = 1;
    placeImg.userInteractionEnabled = YES;
    [placeImg addGestureRecognizer:placeSeleted];
}

#pragma mark 手势方法

- (void)placeSelected {
    if (SAVC == nil) {
        return;
    }
    [self.navigationController pushViewController:SAVC animated:YES];
}

- (void)addPic1Click {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    sheet.tag = 1;
    [sheet showInView:self.view];
   
}
- (void)addPic2Click {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    sheet.tag = 2;
    [sheet showInView:self.view];
    
}

- (void)addPic3Click {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    sheet.tag = 3;
    [sheet showInView:self.view];
    
   }

- (void)addPic4Click {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    sheet.tag = 4;
    [sheet showInView:self.view];
    
}
#pragma mark 单击事件
- (void)tap {
    taskSelectTableView.hidden = !taskSelectTableView.hidden;
    if (taskSelectTableView == nil) {
        taskSelectTableView = [[UITableView alloc]initWithFrame:CGRectMake(taskLable.left, taskLable.bottom, taskLable.width, 60) style:UITableViewStylePlain];
        taskSelectTableView.dataSource = self;
        taskSelectTableView.delegate = self;
        [taskSelectTableView registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellReuseIdentifier:identy];
        [scroll addSubview:taskSelectTableView];
    }
}

//预览按钮单击事件
- (void)reviewButtonClick {
    if ([subjectText.text isEqualToString:@""] || [beginMonthText.text isEqualToString:@""] || [placeText.text isEqualToString:@""] || [contentText.text isEqualToString:@""] || [beginDayText.text isEqualToString:@""] || [beginHourText.text isEqualToString:@""] ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填充完整内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if (subjectIMG == nil) {
        [SVProgressHUD showErrorWithStatus:@"未输入主题图片"];
        return;
    }
    else{
        if (subjectIMG != nil) {
            NSData *imgData = UIImageJPEGRepresentation(addPic1.image, 1);
            NSString *imgSring1 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [sub_picArr addObject:imgSring1];
        }
        
        if (subjectIMG2 != nil) {
            NSData *imgData = UIImageJPEGRepresentation(addPic2.image, 1);
            NSString *imgSring1 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [sub_picArr addObject:imgSring1];
        }
        
        if (subjectIMG3 != nil) {
            NSData *imgData = UIImageJPEGRepresentation(addPic3.image, 1);
            NSString *imgSring1 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [sub_picArr addObject:imgSring1];
        }
        
        if (subjectIMG4 != nil) {
            NSData *imgData = UIImageJPEGRepresentation(addPic4.image, 1);
            NSString *imgSring1 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [sub_picArr addObject:imgSring1];
        }
        
        NSString *moneyStr;
        if (moneyText.text == nil) {
            moneyStr = @"";
        }else {
            moneyStr = moneyText.text;
        }
        
        NSTimeInterval endTime = 0.0;
        if (endDate != nil) {
            endTime = [endDate timeIntervalSince1970];
        }
        NSTimeInterval beginTime = [beginDate timeIntervalSince1970];
        
  
        dic = @{@"promulgator_id":msgDic[@"promulgator_id"],@"subject":subjectText.text,@"tasktype":typeStr,@"begintime":@(beginTime),@"endtime":@(endTime),@"address":placeText.text,@"address_lng":@(point.longitude),@"address_lat":@(point.latitude),@"commission":moneyStr,@"content":contentText.text,@"sub_pic":sub_picArr};
    
        preVC = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"PreviewController"];
        preVC.data = dic;
        [self.navigationController pushViewController:preVC animated:YES];
    }
}


// 提交
- (void)commitButtonClick {
    NSString *lat;
    NSString *lon;
    NSTimeInterval endTime = 0.0;
    sub_picArr = [NSMutableArray array];
    if ([subjectText.text isEqualToString:@""] || [placeText.text isEqualToString:@""] || [contentText.text isEqualToString:@""] || [beginLabel.text isEqualToString:@""] ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填充完整内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else if (subjectIMG == nil && subjectIMG2 == nil && subjectIMG3 == nil &&subjectIMG4 == nil) {
        [SVProgressHUD showErrorWithStatus:@"未输入主题图片"];
        return;
    }
    else{
        lat = [NSString stringWithFormat:@"%f",point.latitude];
        lon = [NSString stringWithFormat:@"%f",point.longitude];
        }
    if (endDate != nil) {
        endTime = [endDate timeIntervalSince1970];
    }
        NSTimeInterval beginTime = [beginDate timeIntervalSince1970];
        
        if (subjectIMG != nil) {
            NSData *imgData = UIImageJPEGRepresentation(addPic1.image, 1);
            NSString *imgSring1 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [sub_picArr addObject:imgSring1];
        }
        
        if (subjectIMG2 != nil) {
            NSData *imgData = UIImageJPEGRepresentation(addPic2.image, 1);
            NSString *imgSring1 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [sub_picArr addObject:imgSring1];
        }
        
        if (subjectIMG3 != nil) {
            NSData *imgData = UIImageJPEGRepresentation(addPic3.image, 1);
            NSString *imgSring1 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [sub_picArr addObject:imgSring1];
        }
        
        if (subjectIMG4 != nil) {
            NSData *imgData = UIImageJPEGRepresentation(addPic4.image, 1);
            NSString *imgSring1 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [sub_picArr addObject:imgSring1];
        }
        
        
        commitButton.userInteractionEnabled = NO;
        
//        5.12发布者修改任务
//        Function：modTask
//        输入：{“promulgator_id”：“发布者ID”, “task_id”：“任务ID”, "subject":"任务主题","tasktype":"任务类型 0:普通任务 1:时效任务", “commission”:”任务佣金 如：200元/天”, "begintime":"任务开始时间","endtime":"任务结束时间","address":"任务地址","address_lng":"任务地址经度","address_lat":"任务地址纬度","content":"任务内容","sub_pic":"任务图片 base64数组"}
//        说明：发布者ID，任务ID必传，其它输入参数为可选参数
//        输出：{”err“：”0/1“, ”msg“：”修改成功/失败原因“}
        if (_dataDic != nil) {
            [SVProgressHUD showWithStatus:@"正在修改，请稍后"];
            NSDictionary *params = @{@"promulgator_id":msgDic[@"promulgator_id"],@"task_id":_dataDic[@"id"],@"subject":subjectText.text,@"tasktype":typeStr,@"commission":moneyText.text,@"begintime":@(beginTime),@"endtime":@(endTime),@"address":placeText.text,@"address_lng":lon,@"address_lat":lat,@"content":contentText.text,@"sub_pic":sub_picArr};
            [DataService requestURL:[NSString stringWithFormat:@"%@modTask",BaseUrl] httpMethod:@"post" timeout:10 params:params responseSerializer:nil completion:^(id result, NSError *error) {
                
                if (error == nil) {
                    if ([result[@"err"] integerValue] == 0) {
                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                        commitButton.userInteractionEnabled = YES;
                        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                        commitButton.userInteractionEnabled = YES;
                    }
                }
                else {
                    
                    [SVProgressHUD showErrorWithStatus:@"网络出错"];
                    commitButton.userInteractionEnabled = YES;
                }

            }];
        }
        
        else {
            
            [SVProgressHUD showWithStatus:@"正在发布，请稍后"];
            [DataService requestURL:[NSString stringWithFormat:@"%@addTask",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":msgDic[@"promulgator_id"],@"subject":subjectText.text,@"tasktype":typeStr,@"begintime":@(beginTime),@"endtime":@(endTime),@"address":placeText.text,@"address_lng":lon,@"address_lat":lat,@"commission":moneyText.text,@"content":contentText.text,@"sub_pic":sub_picArr} responseSerializer:nil completion:^(id result, NSError *error) {
                if (error == nil) {
                    if ([result[@"err"] integerValue] == 0) {
                        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
//                        MyIssusController *mcVC = [[MyIssusController alloc]init];
                        commitButton.userInteractionEnabled = YES;
                        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                        
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                        commitButton.userInteractionEnabled = YES;
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"网络出错"];
                    commitButton.userInteractionEnabled = YES;
                }
            }];
        }
}


#pragma mark createTextView
- (void)_createTextView {
    contentText.delegate = self;
    contentText.textAlignment = NSTextAlignmentCenter;
    contentText.text = @"添加内容要求";
    contentText.textColor = [UIColor grayColor];
    contentText.tag = 0;
//
//    subjectText.delegate = self;
//    subjectText.text = @"添加标题";
//    subjectText.textColor = [UIColor grayColor];
//    contentText.tag = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark textView delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == contentText) {
        NSString *content = contentText.text;
        numberLable.text = [NSString stringWithFormat:@"%ld/1000",(unsigned long)content.length];
    }
   
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.tag ==0) {
        if ([textView.text isEqualToString:@"添加内容要求"]) {
            textView.text = @"";
        }
        textView.tag = 1;
        textView.textColor = [UIColor blackColor];
        if (textView == contentText) {
            textView.textAlignment = NSTextAlignmentLeft;
        }
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@""] && range.length > 0) {
        
        //删除字符肯定是安全的
        
        return YES;
    }
    else {
        
        if (textView.text.length - range.length + text.length > 1000) {
            
            [SVProgressHUD showErrorWithStatus:@"输入长度超过1000"];
            return NO;
            
        }
        
        else {
            
            return YES;
            
        }
        
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"添加内容要求";
        textView.textAlignment = NSTextAlignmentCenter;
        textView.textColor = [UIColor grayColor];
        textView.tag = 0;
    }
}

#pragma mark 照片选择器协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //    NSLog(@"%@",info);
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if (img == nil) {
        
        img = info[@"UIImagePickerControllerOriginalImage"];
    }
    //判断照片是否来自摄像头
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        //保存到相册，@selector(image:didFinishSavingWithError:contextInfo:)  保存成功之后调用的方法
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }

    if (picker == pckerController1) {
        
        addPic1.image = img;
        subjectIMG = img;

    }
    else if (picker == pckerController2) {
        
        addPic2.image = img;
        subjectIMG2 = img;

    }
    else if (picker == pckerController3) {
        
        addPic3.image = img;
        subjectIMG3 = img;
        
    }
    else if (picker == pckerController4) {

        addPic4.image = img;
        subjectIMG4 = img;
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

#pragma mark textField Delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == dayText ||textField == beginDayText) {
        if ([textField.text integerValue]<0||[textField.text integerValue]>31) {
            [SVProgressHUD showErrorWithStatus:@"输入正确地日期"];
            textField.text = @"";
        }
    }
    else if (textField == monthText || textField == beginMonthText) {
        if ([textField.text integerValue]<0||[textField.text integerValue]>12) {
            [SVProgressHUD showErrorWithStatus:@"输入正确地月份"];
            textField.text = @"";
        }
    }
    else if (textField == hourText || textField == beginHourText){
        if ([textField.text integerValue]<0||[textField.text integerValue]>24) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确地时间"];
            textField.text = @"";
        }
    }
    else if (textField == placeText) {
        [mapVC isTrueAddress:textField.text];
    }
        
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == placeText) {
        placeImg.hidden = YES;
        if (textField.textColor == [UIColor grayColor]) {
            placeText.text = @"";
            placeText.textColor = [UIColor blackColor];
        }
    }
    
    return YES;
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    cell.lableText = taskArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        taskLable.text = @"普通任务";
        endView.hidden = YES;
        taskSelectTableView.hidden = YES;
        bgView.transform = CGAffineTransformIdentity;
        timeLabel.height = 40;
        typeStr = @"0";

    }
    else if (indexPath.row == 1) {
        endView.hidden = NO;
        taskLable.text = @"时限任务";
        taskSelectTableView.hidden = YES;
        timeLabel.height = 80;

        bgView.transform = CGAffineTransformMakeTranslation(0, 40);
        typeStr = @"1";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    

    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
        
        type = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1) {
        
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else {
        return;
    }
    switch (actionSheet.tag) {
        case 1:
        {
            pckerController1 = [[UIImagePickerController alloc] init];
            pckerController1.sourceType =  type;
            pckerController1.allowsEditing = YES;
            pckerController1.delegate = self;
            [self presentViewController:pckerController1 animated:YES completion:nil];

        }
            break;
            
        case 2:
        {
            pckerController2 = [[UIImagePickerController alloc] init];
            pckerController2.sourceType =  type;
            pckerController2.allowsEditing = YES;
            pckerController2.delegate = self;
            [self presentViewController:pckerController2 animated:YES completion:nil];
        }
            break;
            
        case 3:
        {
            pckerController3 = [[UIImagePickerController alloc] init];
            pckerController3.sourceType =  type;
            pckerController3.allowsEditing = YES;
            pckerController3.delegate = self;
            [self presentViewController:pckerController3 animated:YES completion:nil];
        }
            break;
            
        default:
        {
            pckerController4 = [[UIImagePickerController alloc] init];
            pckerController4.sourceType =  type;
            pckerController4.allowsEditing = YES;
            pckerController4.delegate = self;
            [self presentViewController:pckerController4 animated:YES completion:nil];
        }
            break;
    }
}
@end
