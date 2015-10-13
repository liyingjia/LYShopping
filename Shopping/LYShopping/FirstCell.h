//
//  FirstCell.h
//  LYShopping
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandDetailModel.h"
#import "AFNetworking.h"

typedef void(^SkipToLogin)(void);

@interface FirstCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIButton *favButton;

- (IBAction)btnClick:(UIButton *)sender;

@property(nonatomic)BrandDetailModel *brandModel;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,copy)SkipToLogin myBlock;

-(void)showDataWithModel:(BrandDetailModel *)model block:(SkipToLogin)block;

@end
