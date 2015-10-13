//
//  MainCell.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface MainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViews;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)showDataToCell:(MainModel *)model;

@end
