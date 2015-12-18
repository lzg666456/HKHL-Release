//
//  SelfCenterCell.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/30.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "SelfCenterCell.h"
@implementation SelfCenterCell

- (void)setKeyLableText:(NSString *)keyLableText {
    _keyLableText = keyLableText;
    keyLable.text = keyLableText;
}

- (void)setMsgString:(NSString *)msgString {
    _msgString = msgString;
    msgText.text = msgString;
}

@end