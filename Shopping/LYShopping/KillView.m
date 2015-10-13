//
//  KillView.m
//  LYShopping
//
//  Created by qianfeng on 15/9/24.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "KillView.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"

@implementation KillView

#pragma mark - 展示数据
-(void)showDataWithModel:(MainModel *)model Block:(TipBlock)block
{
    self.myBlock = block;
    self.model = model;
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:model.msmall] placeholderImage:[UIImage imageNamed: @"killbg"]];
    self.titleLabel.text = model.brandname;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[model.premiumPrice stringValue]];
    [self.priceLabel sizeToFit];
    double price = [model.premiumPrice doubleValue]/[model.marketPrice doubleValue];
    self.discountLabel.text = [NSString stringWithFormat:@"%.1f折",price*10];
    self.discountLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.discountLabel.layer.borderWidth = 0.5;
    [self.discountLabel sizeToFit];
    
//    NSNumber *date1 = model.startTime;
//    NSString *time1 = [LZXHelper dateStringFromNumberTimer:[date1 stringValue]];
//    NSNumber *date2 = model.endTime;
//    NSString *time2 = [LZXHelper dateStringFromNumberTimer:[date2 stringValue]];
//    NSString *strTime = [LZXHelper intervalSinceNow:time1 laterDate:time2];
    
    
}

#pragma mark - 点击事件
- (IBAction)btnClick:(UIButton *)sender {
    
    if (self.myBlock) {
        self.myBlock(self.model.url);
    }
}
@end
