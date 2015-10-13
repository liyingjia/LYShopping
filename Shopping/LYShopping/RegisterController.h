//
//  RegisterController.h
//  LYShopping
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;

- (IBAction)registerBtn:(UIButton *)sender;

@property(nonatomic,copy)NSString *phoneNum;
@end
