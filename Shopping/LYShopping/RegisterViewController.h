//
//  RegisterViewController.h
//  LYShopping
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *telenumText;
@property (weak, nonatomic) IBOutlet UITextField *identifyCodeText;
- (IBAction)getNumBtn:(UIButton *)sender;

- (IBAction)nextBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *getNumBtn;

@end
