//
//  RegisterController.m
//  LYShopping
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "RegisterController.h"
#import "AFNetworking.h"
#import "LZXHttpRequest.h"
#import "LoginViewController.h"

@interface RegisterController ()

@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong)LZXHttpRequest *httpRequest;
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtn:(UIButton *)sender {
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //注册
        NSDictionary *dict = @{@"mobile":self.phoneNum,@"password":self.passwordText.text,@"model":@"8d0971ac-05c7-346e-ad73-ea0355a97007",@"channel":@"4",@"v":@"2.0"};
    NSString *url = [kOnRegister stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /*
     
     code = 200;
     codeMsg = ok;
     result =     {
     "access_token" = "1de3f034-21bd-4e4e-9a79-862afeca31a7";
     expiresin = 86399;
     memberid = 566304;
     mobile = 13673513425;
     "refresh_token" = "c1dd4d6f-b7a6-4e7c-b8e5-3d0b9f694de2";
     username = "1510040317121_p";
     };
     */
        [self.manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (![self.passwordText.text isEqualToString:self.confirmPasswordText.text]) {
                [self createAlert:@"1"];
            }else if ([dict[@"codeMsg"] isEqualToString:@"ok"]){
                [self createAlert:@"2"];
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
            }
            NSLog(@"fasdf:%@",dict[@"codeMsg"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@",[error userInfo]);
            NSLog(@"请求失败");
            [self createAlert:@"3"];
        }];
}
#pragma mark - 警示框
-(void)createAlert:(NSString *)string
{
    if ([string isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不一致." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    if ([string isEqualToString:@"2"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜你,注册成功,赶快去登录吧!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    if ([string isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordText resignFirstResponder];
    [self.confirmPasswordText resignFirstResponder];
}



@end
