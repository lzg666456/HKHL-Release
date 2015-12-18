//
//  NurseDetailsCell.h
//  鸿康护理
//
//  Created by CaiNiao on 15/11/3.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarView;
@interface NurseDetailsCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *msgDic;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, assign)NSString *isSelect;
- (IBAction)selectButtonClick:(UIButton *)sender;



@end
