//
//  CommentSubmitController.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentSubmitController : UIViewController

@property(nonatomic,copy)NSString *uid;
-(id)initWithId:(NSString *)uid;
@end
