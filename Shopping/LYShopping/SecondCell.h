//
//  SecondCell.h
//  LYShopping
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property(nonatomic,copy)NSString *color;

-(void)showDataWithArray:(NSArray *)array color:(NSArray *)colors;

@end
