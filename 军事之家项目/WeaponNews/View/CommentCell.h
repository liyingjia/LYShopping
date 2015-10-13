//
//  CommentCell.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *adddateLabel;

-(void)showDataToCell:(MainModel *)model;

@end
