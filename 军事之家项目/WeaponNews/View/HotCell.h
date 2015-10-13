//
//  HotCell.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface HotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titlex;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *adddate;

-(void)showDataToCell:(MainModel *)model;

@end
