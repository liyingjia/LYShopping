//
//  RegisterViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "RegisterController.h"

@interface RegisterViewController ()

@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic)NSInteger second;
@property (nonatomic)NSTimer *timer;
@property (nonatomic)BOOL num;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getNumBtn:(UIButton *)sender {
    if (self.telenumText.text.length != 11) {
        [self createAlert:@"1"];
    }else{
        [self proving:kGetValidateCode];
        self.second = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFire:) userInfo:nil repeats:60];
        [self.timer fire];
    }
}

-(void)timeFire:(NSTimer *)timer
{
    if (self.second == 1) {
        [timer invalidate];
        self.second = 60;
        [self.getNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getNumBtn setEnabled:YES];
    }else{
        self.second --;
        NSString *title = [NSString stringWithFormat:@"重新发送 %ld",self.second];
        [self.getNumBtn setTitle:title forState:UIControlStateNormal];
        [self.getNumBtn setEnabled:NO];
    }
}

-(void)proving:(NSString *)url
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //mobile=18211673158&v=2.0
    NSDictionary *dict = @{@"mobile":self.telenumText.text,@"v":@"2.0"};
    [self.manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [self createAlert:@"2"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
}

-(void)createAlert:(NSString *)string
{
    if ([string isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确号码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    if ([string isEqualToString:@"2"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    if ([string isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    if ([string isEqualToString:@"4"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已经注册过了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}


- (IBAction)nextBtn:(UIButton *)sender {
    //mobile=18211673158&validateCode=172117&v=2.0
    //mobile=18211673158&password=123456&model=8d0971ac-05c7-346e-ad73-ea0355a97007&channel=4&v=2.0
    
    //检测验证码
    NSDictionary *dict1 = @{@"mobile":self.telenumText.text,@"validateCode":self.identifyCodeText.text,@"v":@"2.0"};
    [self.manager POST:kCheckValidateCode parameters:dict1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        self.num = [dict[@"result"][@"isOk"] boolValue];
//        NSLog(@"num:%d",self.num);
        if (!self.num){
            [self createAlert:@"3"];
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    //检测手机号是否注册过
    NSDictionary *dict2 = @{@"mobile":self.telenumText.text,@"v":@"2.0"};
    [self.manager POST:kExitsMobileNumber parameters:dict2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        NSLog(@"dict2:%@",dict);
        BOOL phone = [dict[@"result"][@"isOk"] boolValue];
        if (phone && self.num){
            [self createAlert:@"4"];
        }else if(self.num){
            RegisterController *regist = [[RegisterController alloc] init];
            regist.phoneNum = self.telenumText.text;
            [self.navigationController pushViewController:regist animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.telenumText resignFirstResponder];
    [self.identifyCodeText resignFirstResponder];
}














@end
