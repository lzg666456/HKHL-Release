//
//  MyIssusCell.h
//  鸿康护理
//
//  Created by CaiNiao on 15/11/5.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIssusCell : UITableViewCell 


@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (nonatomic,strong)NSDictionary *msgDic;
- (IBAction)inspectButtonClick:(UIButton *)sender;

@end
