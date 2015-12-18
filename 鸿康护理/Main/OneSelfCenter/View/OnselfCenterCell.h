//
//  OnselfCenterCell.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/27.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnselfCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong)NSDictionary *data;
@end
