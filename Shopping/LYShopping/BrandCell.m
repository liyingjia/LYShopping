//
//  BrandCell.m
//  LYShopping
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BrandCell.h"
#import "UIImageView+WebCache.h"

@implementation BrandCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDataWithModel:(MainModel *)model
{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.appImg] placeholderImage:[UIImage imageNamed: @"homebg"]];
    self.label.text = model.brandName;
//    [self.label sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
