//
//  FiveView.m
//  LYShopping
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "FiveView.h"
#import "UIImageView+WebCache.h"

@implementation FiveView

-(void)showDataWithModel:(BrandDetailModel *)model Block:(TipBlock)block
{
    self.myBlock = block;
    self.productid = model.productId;
    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:model.msmall] placeholderImage:[UIImage imageNamed: @"killbg"]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[model.price stringValue]];
    self.marketLabel.text = [model.marketPrice stringValue];
    self.nameLabel.text = model.brandname;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.myBlock) {
        self.myBlock(self.productid);
    }
}
@end
