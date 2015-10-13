//
//  MyCollectCell.m
//  LYShopping
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "MyCollectCell.h"
#import "UIImageView+WebCache.h"

@implementation MyCollectCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDataWithModel:(BrandDetailModel *)model
{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.msmall] placeholderImage:[UIImage imageNamed: @"killbg"]];
    self.brandName.text = model.brandname;
    self.productName.text = model.productName;
    self.priceText.text = [NSString stringWithFormat:@"￥%@",[model.price stringValue]];
    self.colorText.text = [NSString stringWithFormat:@"颜色为%@",model.colorText];
    if ([model.stock integerValue]==0) {
        self.isHaveText.text = @"无货";
    }else{
        self.isHaveText.text = @"有货";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
