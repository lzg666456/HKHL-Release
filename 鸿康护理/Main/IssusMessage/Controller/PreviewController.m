//
//  PreviewController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/27.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "PreviewController.h"
#import "UILabel+StringFrame.h"
#import "MyIssusController.h"
#import "Utility.h"

@interface PreviewController () {
    UILabel *contentLable;
    NSString *endStr;
}

@end

@implementation PreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交预览";
   
    sureButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    
    contentLable = [[UILabel alloc]init];
    contentLable.font = [UIFont systemFontOfSize:16];
    contentLable.textColor = [UIColor blackColor];
    contentLable.text = _data[@"content"];
    contentLable.numberOfLines = 0;
    CGSize size = [contentLable boundingRectWithSize:CGSizeMake(self.view.width-36, 0)];
    contentLable.frame = CGRectMake(0, 0, size.width, size.height);
    scrollView.contentSize = CGSizeMake(self.view.width-56, contentLable.height);
    [scrollView addSubview:contentLable];
    
    NSArray *arr = _data[@"sub_pic"];
    NSString *imgSrring = arr[0];
    NSData *imgData = [[NSData alloc]initWithBase64EncodedString:imgSrring options:NSDataBase64DecodingIgnoreUnknownCharacters];
    subjectIMG.image = [UIImage imageWithData:imgData];

    subjectLable.text = _data[@"subject"];
   
    NSString *beginStr = [Utility timeintervalToDate:[_data[@"begintime"] doubleValue] Formatter:@"MM月dd日HH时"];
    if (![_data[@"endtime"] doubleValue] == 0) {
        endStr = [Utility timeintervalToDate:[_data[@"endtime"] doubleValue] Formatter:@"MM月dd日HH时"];
    }
    placeLable.text = [NSString stringWithFormat:@"地点:%@",_data[@"address"]];
    
    if ([_data[@"tasktype"] integerValue] == 0) {
        typeLable.text = @"类型:普通任务";
        timeLable.text = [NSString stringWithFormat:@"时间:%@",beginStr];
    }
    else {
        typeLable.text = @"类型:时限任务";
        timeLable.text = [NSString stringWithFormat:@"时间:%@-%@",beginStr,endStr];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (IBAction)commitButtonClick:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"正在发布，请稍后"];
    [DataService requestURL:[NSString stringWithFormat:@"%@addTask",BaseUrl] httpMethod:@"POST" timeout:30 params:_data responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                sureButton.userInteractionEnabled = YES;
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                sureButton.userInteractionEnabled = YES;
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
            sureButton.userInteractionEnabled = YES;
        }
    }];
    sureButton.userInteractionEnabled = NO;

}



@end
