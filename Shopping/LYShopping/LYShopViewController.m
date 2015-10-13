//
//  LYShopViewController.m
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "LYShopViewController.h"

@interface LYShopViewController ()

@end

@implementation LYShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
}

-(void)createViewControllers
{
    NSArray *vcNames = @[@"HomeViewController",@"CategoryViewController",@"BrandViewController",@"MyCollectViewController",@"MineViewController"];
    NSArray *titles = @[@"首页",@"分类",@"品牌",@"我的收藏",@"我的"];
    NSArray *imagaes = @[@"main_bottom_tab_home_normal",@"main_bottom_tab_search_normal",@"main_bottom_tab_category_normal",@"main_bottom_tab_cart_normal",@"main_bottom_tab_personal_normal"];
    NSArray *secletImage = @[@"main_bottom_tab_home_focus",@"main_bottom_tab_search_focus",@"main_bottom_tab_category_focus",@"main_bottom_tab_cart_focus",@"main_bottom_tab_personal_focus"];
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<titles.count; i++) {
        Class cls = NSClassFromString(vcNames[i]);
        UIViewController *vc = [[cls alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem.image = [[UIImage imageNamed:imagaes[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:secletImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
         nav.tabBarItem.title = titles[i];
        [vcArr addObject:nav];
    }
    self.viewControllers = vcArr;
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
