//
//  CollectionCell.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/9.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "CollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation CollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _createView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _createView];
    }
    return self;
}

- (void)_createView {
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.width-10, self.width-10)];
//    iconView.backgroundColor = [UIColor blueColor];
    [self addSubview:iconView];
    nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, iconView.bottom, self.width, 30)];
//    nameLable.backgroundColor = [UIColor greenColor];
    nameLable.font = [UIFont systemFontOfSize:16];
    nameLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLable];
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    _infoDic = infoDic;
    [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,_infoDic[@"avatar"]]]];
    nameLable.text = _infoDic[@"username"];
}

@end
