//
//  CommentViewController.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property(nonatomic,copy)NSString *id;
@property(nonatomic)BOOL isRefreshing;
@property(nonatomic)BOOL isLoadingMore;
@property(nonatomic)NSInteger page;

-(void)createRefreshView;
-(void)endRefreshView;
-(id)initWithId:(NSString *)uid;
@end
