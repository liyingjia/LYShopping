//
//  HotCell.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "HotCell.h"
#import "UIImageView+WebCache.h"

@implementation HotCell

- (void)awakeFromNib {
    
}

-(void)showDataToCell:(MainModel *)model
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"st_botton_bg_n"]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"share_bar_bg"]];
    if ([model.icon isEqualToString:@""]) {
        //设置titlex的偏移量和宽度
        CGRect frame = self.titlex.frame;
        frame.size.width = ScreenWidth-15;
        frame.origin.x = 10;
        self.titlex.frame = frame;
        //设置title的偏移量和宽度
        CGRect titleFrame = self.title.frame;
        titleFrame.size.width = ScreenWidth-15;
        titleFrame.origin.x = 10;
        self.title.frame = titleFrame;
        self.imageViews.alpha = 0;
    }else{
        //重新设置描述的偏移量和宽度
        CGRect frame = self.titlex.frame;
        frame.size.width = ScreenWidth-_imageViews.width-15;
        frame.origin.x = _imageViews.width+10;
        self.titlex.frame = frame;
        //重新设置title的偏移量和宽度
        CGRect titleFrame = self.title.frame;
        titleFrame.size.width = ScreenWidth-_imageViews.width-15;
        titleFrame.origin.x = _imageViews.width+10;
        self.title.frame = titleFrame;
        
        self.imageViews.alpha = 1.0;
        [self.imageViews sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listitem_jmhd_default"]];
        self.imageViews.layer.masksToBounds = YES;
        self.imageViews.layer.cornerRadius = 3.f;
    }
    
    self.titlex.text = model.titlex;
    //判断titlex的内容是否为空
    if ([model.titlex isEqualToString:@""]) {
        CGRect frame = self.title.frame;
        frame.origin.y = 3;
        self.title.frame = frame;
    }else{
        CGRect frame = self.title.frame;
        frame.origin.y = self.titlex.height+5;
        self.title.frame = frame;
    }
    self.title.text = model.title;
    self.title.numberOfLines = 2;
    if ([model.news isEqualToString:@"1"]) {
        self.icon.image = [UIImage imageNamed:@"listitem_flag_new.png"];
    }else if ([model.news isEqualToString:@"2"]) {
        self.icon.image = [UIImage imageNamed:@"listitem_flag_hot"];
    }
    
    self.adddate.text = model.adddate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
