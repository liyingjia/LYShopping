//
//  RootViewController.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property(nonatomic,copy)NSString *action;
@property(nonatomic,copy)NSString *sa;
@property(nonatomic,strong)UITableView *tableView;
//当前页码
@property(nonatomic)NSInteger page;
//记录拼接的路径
@property(nonatomic,copy)NSString *requestUrl;
//记录是否是从webView返回来的
@property(nonatomic)BOOL isReturn;


//第一次下载
-(void)firstDownLoad;
//刷新页面
-(void)createRefreshView;
//停止刷新
-(void)endRefresh;
@end
