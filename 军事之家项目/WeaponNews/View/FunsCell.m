//
//  FunsCell.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "FunsCell.h"
#import "UIImageView+WebCache.h"

@implementation FunsCell

- (void)awakeFromNib {
    
}

-(void)showDataToCell:(MainModel *)model
{
    self.titleLabel.text = model.title;
    self.countLabel.text = model.count;
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"wb_forward_bg.9"]];
    NSArray *images = [model.icon componentsSeparatedByString:@","];
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,images[0]]] placeholderImage:[UIImage imageNamed:@"listitem_fm_detail_default"]];
    self.imageView1.layer.masksToBounds = YES;
    self.imageView1.layer.cornerRadius = 5.f;
    
    
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,images[1]]] placeholderImage:[UIImage imageNamed:@"listitem_fm_detail_default"]];
    self.imageView2.layer.masksToBounds = YES;
    self.imageView2.layer.cornerRadius = 5.f;
    
    [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,images[2]]] placeholderImage:[UIImage imageNamed:@"listitem_fm_detail_default"]];
    self.imageView3.layer.masksToBounds = YES;
    self.imageView3.layer.cornerRadius = 5.f;
    
    [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,images[3]]] placeholderImage:[UIImage imageNamed:@"listitem_fm_detail_default"]];
    self.imageView4.layer.masksToBounds = YES;
    self.imageView4.layer.cornerRadius = 5.f;
    
    if (![model.adddate isEqualToString:@""]) {
        self.iconImage.image = [UIImage imageNamed:@"listitem_flag_new.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
