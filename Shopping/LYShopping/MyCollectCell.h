//
//  MyCollectCell.h
//  LYShopping
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandDetailModel.h"

@interface MyCollectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *brandName;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *colorText;
@property (weak, nonatomic) IBOutlet UILabel *priceText;

@property (weak, nonatomic) IBOutlet UILabel *isHaveText;

-(void)showDataWithModel:(BrandDetailModel *)model;

@end
