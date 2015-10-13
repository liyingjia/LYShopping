//
//  BookCell.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BookCell.h"
#import "UIImageView+WebCache.h"
#import "BookModel.h"

@implementation BookCell

- (void)awakeFromNib {
    
}

-(void)showDataToCell:(NSArray *)images
{
   
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"manger_item_bg"]];
    BookModel *model = images[0];
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed: @"listitem_fm_icon_default"]];
    self.periodsLabel1.text = model.periods;
    
    model = images[1];
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed: @"listitem_fm_icon_default"]];
    self.periodsLabel2.text = model.periods;
    
    model = images[2];
    [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed: @"listitem_fm_icon_default"]];
    self.periodsLabel3.text = model.periods;
    
    model = images[3];
    [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed: @"listitem_fm_icon_default"]];
    self.periodsLabel4.text = model.periods;
    
    model = images[4];
    [self.imageView5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed: @"listitem_fm_icon_default"]];
    self.periodsLabel5.text = model.periods;
    
    model = images[5];
    [self.imageView6 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed: @"listitem_fm_icon_default"]];
    self.periodsLabel6.text = model.periods;
    
    
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
