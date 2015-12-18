//
//  CollectionCell.h
//  鸿康护理
//
//  Created by CaiNiao on 15/11/9.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell {
    UIImageView *iconView;
    UILabel *nameLable;
}

@property (nonatomic,strong)NSDictionary *infoDic;

@end
