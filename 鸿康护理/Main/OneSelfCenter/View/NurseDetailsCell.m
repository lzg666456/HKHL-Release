//
//  NurseDetailsCell.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/3.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "NurseDetailsCell.h"
#import "StarView.h"
#import "UIImageView+WebCache.h"

@implementation NurseDetailsCell {
    
    __weak IBOutlet UIImageView *_icon;
    __weak IBOutlet UILabel *_userName;
    __weak IBOutlet UILabel *hospital;
    __weak IBOutlet UILabel *age;
    __weak IBOutlet UILabel *expe;
    __weak IBOutlet UILabel *proTitle;
    
}

- (void)setMsgDic:(NSDictionary *)msgDic {
    _msgDic = msgDic;
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 25;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,_msgDic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"参与人员_xxhdpi"]];
    _userName.text = msgDic[@"username"];
    if (![msgDic[@"hospital"] isKindOfClass:[NSNull class]]) {
        
        hospital.text = msgDic[@"hospital"];
    }
    
    age.text = msgDic[@"age"];
    expe.text = [NSString stringWithFormat:@"%@年护理经验",msgDic[@"experience"]];
    
    if (![msgDic[@"jobtitle"] isKindOfClass:[NSNull class]]) {
        
       proTitle.text = msgDic[@"jobtitle"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectButtonClick:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSDictionary *dic = @{@"row":str};
    [[NSNotificationCenter defaultCenter]postNotificationName:selectButtonClickNoticifition object:nil userInfo:dic];
}

- (void)setIsSelect:(NSString *)isSelect {
    _isSelect = isSelect;
    if ([isSelect integerValue] == 0) {
        _selectButton.selected = NO;
    }
    else {
        _selectButton.selected = YES;
    }
  
}
@end
