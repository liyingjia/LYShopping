//
//  MainCell.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "MainCell.h"
#import "UIImageView+WebCache.h"
#import "MainModel.h"

@implementation MainCell

- (void)awakeFromNib {
    
}

-(void)showDataToCell:(MainModel *)model
{
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listhead_icon_default"]];
    self.titleLabel.text = model.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
