//
//  SelectedCell.h
//  鸿康护理
//
//  Created by CaiNiao on 15/10/30.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedCell : UITableViewCell {
    
    __weak IBOutlet UILabel *contentLable;
}
@property (nonatomic,copy)NSString *lableText;
@end
