//
//  OnselfCenterCell.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/27.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "OnselfCenterCell.h"

@implementation OnselfCenterCell

- (void)setData:(NSDictionary *)data {
    _data = data;
    _imgView.image = [UIImage imageNamed:data[@"picName"]];
    _lableView.text = data[@"lableName"];
}

@end
