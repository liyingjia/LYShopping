//
//  SearchCell.m
//  LYShopping
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDataWithModel:(CategoryModel *)model
{
    self.titleLabel.text = model.keyWords;
//    [self.titleLabel sizeToFit];
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
