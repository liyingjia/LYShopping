//
//  LoginViewController.h
//  LYShopping
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property(nonatomic,copy)NSString *memberid;
@property(nonatomic,copy)NSString *access_token;

- (IBAction)loginButton:(UIButton *)sender;


- (IBAction)sinaBtn:(UIButton *)sender;

@end
