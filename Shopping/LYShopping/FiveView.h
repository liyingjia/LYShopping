//
//  FiveView.h
//  LYShopping
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandDetailModel.h"

typedef void(^TipBlock)(NSString *productid);

@interface FiveView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imagesView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,copy)TipBlock myBlock;
@property(nonatomic,copy)NSString *productid;
- (IBAction)btnClick:(UIButton *)sender;

-(void)showDataWithModel:(BrandDetailModel *)model Block:(TipBlock)block;

@end
