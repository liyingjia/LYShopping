//
//  AboutUsViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"AboutUsbg"]];
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
