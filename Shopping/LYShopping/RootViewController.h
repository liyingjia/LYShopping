//
//  RootViewController.h
//  LYShopping
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@interface RootViewController : UIViewController

@property(nonatomic,copy)NSString *brandId;
@property(nonatomic)CategoryModel *model;
@property(nonatomic,copy)NSString *keyWord;
@end
