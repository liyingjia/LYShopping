//
//  BookCell.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface BookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;

@property (weak, nonatomic) IBOutlet UILabel *periodsLabel1;
@property (weak, nonatomic) IBOutlet UILabel *periodsLabel2;
@property (weak, nonatomic) IBOutlet UILabel *periodsLabel3;
@property (weak, nonatomic) IBOutlet UILabel *periodsLabel4;
@property (weak, nonatomic) IBOutlet UILabel *periodsLabel5;
@property (weak, nonatomic) IBOutlet UILabel *periodsLabel6;

-(void)showDataToCell:(NSArray *)images;

@end
