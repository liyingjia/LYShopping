//
//  BrandCell.h
//  LYShopping
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface BrandCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *label;

-(void)showDataWithModel:(MainModel *)model;

@end
