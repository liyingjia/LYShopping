//
//  FirstCell.m
//  LYShopping
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "FirstCell.h"
#import "LoginViewController.h"

@implementation FirstCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDataWithModel:(BrandDetailModel *)model block:(SkipToLogin)block
{
    self.brandModel = model;
    self.myBlock = block;
    self.titleLabel.text = model.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[model.price stringValue]];
    [self.priceLabel sizeToFit];
    self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@",[model.marketPrice stringValue]];
    [self.marketPriceLabel sizeToFit];
    double discount = [model.price doubleValue]/[model.marketPrice doubleValue];
    self.discountLabel.text = [NSString stringWithFormat:@"%.1f折",discount*10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(UIButton *)sender {
//    self.manager = [AFHTTPRequestOperationManager manager];
//    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
//    if (!isLogin) {
//        if (self.myBlock) {
//            self.myBlock();
//        }
//    }
//  
//    BOOL isFav = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",self.brandModel.productId]];
//    NSLog(@"isFav:%d",isFav);
//    if (!isFav) {
//        [sender setImage:[UIImage imageNamed: @"icon_love_down"] forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@",self.brandModel.productId]];
//        [self addCollection];
//    }else{
//        [sender setImage:[UIImage imageNamed: @"icon_love_up"] forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@",self.brandModel.productId]];
//        [self deleCollection];
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 增加收藏
-(void)addCollection
{
    //memberid=565137&productid=%@&access_token=426a52b6-958e-4d6c-831f-f0f274ba39db&isbuy=0
    NSDictionary *dict = @{@"memberid":@"565137",@"productid":self.brandModel.productId,@"access_token":@"426a52b6-958e-4d6c-831f-f0f274ba39db",@"isbuy":@"0"};
    [self.manager POST:kAddCollect parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BOOL fav = [dict[@"result"] boolValue];
        if (fav == 1) {
            [self createAlert:@"1"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"连接失败");
    }];
}

#pragma mark - 取消收藏
-(void)deleCollection
{
    //memberid=565137&access_token=426a52b6-958e-4d6c-831f-f0f274ba39db&productid=%@
    NSDictionary *dict = @{@"memberid":@"565137",@"access_token":@"426a52b6-958e-4d6c-831f-f0f274ba39db",@"productid":self.brandModel.productId};
    [self.manager POST:kDeleCollect parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL fav = [dict[@"result"] boolValue];
        if (fav) {
            [self createAlert:@"2"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"连接失败");
    }];

}

-(void)createAlert:(NSString *)string
{
    if ([string isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    if ([string isEqualToString:@"2"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }

}

@end
















