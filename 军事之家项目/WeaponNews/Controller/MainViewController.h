//
//  MainViewController.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModel.h"

@interface MainViewController : BaseViewController


@property(nonatomic,copy)NSString *action;
@property(nonatomic,copy)NSString *sa;
@property(nonatomic)NSInteger page;
@property(nonatomic,copy)NSString *requestUrl;
//@property(nonatomic,copy)BaseModel *data;
@property(nonatomic,copy)NSMutableArray *dataArr;

//刷新页面
-(void)createRefreshView;
//停止刷新
-(void)endRefresh;







@end
