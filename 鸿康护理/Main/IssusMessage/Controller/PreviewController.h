//
//  PreviewController.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/27.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface PreviewController : BaseController{
    
    __weak IBOutlet UILabel *subjectLable;//显示主题
    __weak IBOutlet UILabel *timeLable;//显示时间
    __weak IBOutlet UILabel *placeLable;//显示地点
    __weak IBOutlet UILabel *typeLable;//显示类型
    __weak IBOutlet UIButton *sureButton;
    __weak IBOutlet UILabel *detailsLable;
    __weak IBOutlet UIView *detailView;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *subjectIMG; //显示主题图片
    
    
}

@property (nonatomic,strong)NSDictionary *data;

@end
