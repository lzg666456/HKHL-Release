//
//  MyIssusCell.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/5.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MyIssusCell.h"
#import "Utility.h"
@implementation MyIssusCell {
    
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *contentLabel;
}


- (void)setMsgDic:(NSDictionary *)msgDic {
    _msgDic = msgDic;
    contentLabel.text = msgDic[@"subject"];
    NSString *str = msgDic[@"begintime"];
    timeLabel.text = [Utility timeintervalToDate:[str integerValue] Formatter:@"MM月dd日hh时"];
    if ([msgDic[@"status"] integerValue] == 0) {
        stateLabel.text = @"审核中";
    }else if ([msgDic[@"status"] integerValue] == 1) {
        stateLabel.text = @"未通过";
    }else if ([msgDic[@"status"] integerValue] == 2) {
        stateLabel.text = @"已通过";
    }else {
        stateLabel.text = @"已完成";
    }
}

- (IBAction)inspectButtonClick:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld",sender.tag];
    NSDictionary *dic = @{@"tag":str};
    [[NSNotificationCenter defaultCenter]postNotificationName:inspectButttonClickNoticifition object:nil userInfo:dic];
}
@end
