//
//  CommentCell.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell


- (void)awakeFromNib {
    // Initialization code
}

-(void)showDataToCell:(MainModel *)model
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"st_push_bg_n"]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"st_push_bg_h"]];
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;
    self.adddateLabel.text = model.adddate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
