//
//  CollectionViewCell.h
//  LYShopping
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)showDateWithModel:(CategoryModel *)model;

@end
