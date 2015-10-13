//
//  KillView.h
//  LYShopping
//
//  Created by qianfeng on 15/9/24.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

typedef void(^TipBlock)(NSString *url);

@interface KillView : UIView

@property(nonatomic,strong)MainModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property(nonatomic,copy)TipBlock myBlock;


- (IBAction)btnClick:(UIButton *)sender;

-(void)showDataWithModel:(MainModel *)model Block:(TipBlock)block;

@end
