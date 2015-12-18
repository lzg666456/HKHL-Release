//
//  IssusMessageController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface IssusMessageController : BaseController<UITextViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>{
    
    UILabel *numberLable;//输入字数显示标签
    UITextField *subjectText;//主题输入框
    UITextView *contentText;//内容输入框
    UIImageView *selectTask;//任务类型选择按钮
    UILabel *timeLabel;//时间输入面板
    UILabel *taskLable;//任务显示标签
    UIView *taskView;//任务类型面板
    UIView *backView;//承载所有面板的View
    UILabel *beginTimeLable;//开始时间标签
    UILabel *endTimeLable;//结束时间标签
    UITextField *monthText;//结束时间月份输入框
    UILabel *monthLabke;//“月”标签
    UITextField *dayText;//结束时间日输入框
    UILabel *dayLable;//“日”标签
    UITextField *hourText;//结束时间时输入框
    UILabel *hourLable;//时标签
    UIImageView *addPic1;//第一张图片
    UIImageView *addPic2;//第二张图片
    UIImageView *addPic3;//第三张图片
    UIImageView *addPic4;//第四张图片
    UITextField *placeText;//地址输入框
    UITextField *beginMonthText;//开始时间月份输入框
    UITextField *beginDayText;//开始时间日输入框
    UITextField *beginHourText;//开始时间时输入框
    UIImageView *placeImg;
//    UIButton *reviewButton;
//    UIButton *commitButton;
    UIButton *reviewButton;
    UIButton *commitButton;

}

@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,assign)NSInteger contentLenth;


@end
