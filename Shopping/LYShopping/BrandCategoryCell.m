//
//  BrandCategoryCell.m
//  LYShopping
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BrandCategoryCell.h"
#import "UIImageView+WebCache.h"

@implementation BrandCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDataWithModel:(BrandModel *)model
{
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:model.msmall] placeholderImage:[UIImage imageNamed: @"homebg"]];
    self.nameLabel.text = model.brandname;
    [self.nameLabel sizeToFit];
    self.productNameLabel.text = model.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[model.price stringValue]];
    if (model.pisSpecial) {
        self.actionLabel.text = @"海外直邮";
    }else{
        self.actionLabel.alpha = 0;
    }
    
    if ([model.stock integerValue]==0) {
        self.actionImage.alpha = 1;
        [self.actionImage setImage:[UIImage imageNamed: @"icon_soldout"]];
    }else{
        self.actionImage.alpha = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
