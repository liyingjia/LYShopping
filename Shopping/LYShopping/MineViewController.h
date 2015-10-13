//
//  MineViewController.h
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineViewController : UIViewController

@property(nonatomic,copy)NSString *Name;
@property(nonatomic)BOOL isLoginPush;
@property(nonatomic)BOOL isCancel;
@property(nonatomic)BOOL loginBool;

+(instancetype)defaultPerson;

@end
