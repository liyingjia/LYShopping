//
//  SearchCell.h
//  LYShopping
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@interface SearchCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)showDataWithModel:(CategoryModel *)model;

@end
