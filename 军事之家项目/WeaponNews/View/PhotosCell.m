//
//  PhotosCell.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "PhotosCell.h"
#import "UIImageView+WebCache.h"

@implementation PhotosCell

- (void)awakeFromNib {
}

-(void)showDataToCell:(MainModel *)model
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"wb_forward_bg.9"]];
    self.titleLabel.text = model.title;
    self.countLabel.text = model.count;
    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listhead_icon_default"]];
    self.imagesView.layer.masksToBounds = YES;
    self.imagesView.layer.cornerRadius = 10.f;
    if ([model.news isEqualToString:@"1"]) {
        self.iconView.image = [UIImage imageNamed:@"listitem_flag_new.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
