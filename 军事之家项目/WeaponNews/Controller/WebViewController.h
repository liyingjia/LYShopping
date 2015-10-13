//
//  WebViewController.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface WebViewController : UIViewController


@property(nonatomic)BOOL isCollect;
-(id)initWithModel:(MainModel *)model action:(NSString *)action;

-(void)showDateWithImages:(NSArray *)images;

@end
