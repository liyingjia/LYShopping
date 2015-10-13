//
//  HomeCell.h
//  LYShopping
//
//  Created by qianfeng on 15/9/24.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface HomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *disCountLabel;

-(void)showDateWithModel:(MainModel *)model;

@end
