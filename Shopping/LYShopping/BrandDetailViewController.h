//
//  BrandDetailViewController.h
//  LYShopping
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandDetailViewController : UIViewController

@property(nonatomic,copy)NSString *productid;
@property(nonatomic)BOOL pisSpecial;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
- (IBAction)favBtnClick:(UIButton *)sender;

- (IBAction)rightBtn:(UIButton *)sender;
- (IBAction)backBtn:(UIButton *)sender;
- (IBAction)buyBtn:(UIButton *)sender;
- (IBAction)shopBtn:(UIButton *)sender;
- (IBAction)bagBtn:(UIButton *)sender;

@end
