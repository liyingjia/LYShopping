//
//  CollectionViewCell.m
//  LYShopping
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDateWithModel:(CategoryModel *)model
{
//    NSLog(@"fsd:%@",model.imgUrl);
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed: @"killbg"]];
    self.titleLabel.text = model.categoryName;
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
}

@end
