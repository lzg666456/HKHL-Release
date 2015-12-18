//
//  SelfCenterCell.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/30.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SelfCenterCell : UITableViewCell {
    
    __weak IBOutlet UILabel *keyLable;
    
    __weak IBOutlet UILabel *msgText;
}

@property (nonatomic,copy)NSString *keyLableText;
@property (nonatomic,copy)NSString *msgString;

@end
