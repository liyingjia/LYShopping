//
//  LoginViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "MineViewController.h"
#import "UMSocial.h"

@interface LoginViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,copy)NSString *string;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerClick)];
    self.navigationItem.rightBarButtonItem = registerBtn;
}
#pragma mark - 注册按钮
-(void)registerClick
{
    RegisterViewController *registered = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registered animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma maek - 登录按钮
- (IBAction)loginButton:(UIButton *)sender {
    [self login:kLogin];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sinaBtn:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.usid forKey:kMemberid];
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.accessToken forKey:kAccess_token];
            [MineViewController defaultPerson].loginBool = YES;
            [MineViewController defaultPerson].Name = self.userNameText.text;
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.userName forKey:kUserName];
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.iconURL forKey:kImageUrl];
            BOOL login = [MineViewController defaultPerson].loginBool;
            [[NSUserDefaults standardUserDefaults] setBool:login forKey:kIsLogin];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self createAlert:@"200"];
        }});
}

#pragma mark -登录
-(void)login:(NSString *)url
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //username=18211673158&password=123456&channel=4&isuname=3&v=2.0
    
    /*
     code = 200;
     codeMsg = ok;
     result =     {
     "access_token" = "3a461a53-57a9-4fd7-be72-cc3d727e6104";
     expiresin = 86266;
     memberid = 565137;
     mobile = 18211673158;
     "refresh_token" = "8e3838a0-9cd7-45ed-85d3-872c948315f2";
     result = 1;
     username = "1509300931398_p";
     };
     */
    NSDictionary *dict = @{@"username":self.userNameText.text,@"password":self.passwordText.text,@"channel":@"4",@"isuname":@"3",@"v":@"2.0"};
    
    __weak typeof(self)weakSelf = self;
    [self.manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dict:%@",dict);
        self.string = dict[@"codeMsg"];
        self.memberid = dict[@"result"][@"memberid"];
        self.access_token = dict[@"result"][@"access_token"];
        //保存登陆信息，后面收藏用的到
        [[NSUserDefaults standardUserDefaults] setObject:self.memberid forKey:kMemberid];
        [[NSUserDefaults standardUserDefaults] setObject:self.access_token forKey:kAccess_token];
//        NSLog(@"id%@   add:%@",self.memberid,self.access_token);
        if ([self.string isEqualToString:@"ok"]) {
            [MineViewController defaultPerson].loginBool = YES;
            [MineViewController defaultPerson].Name = self.userNameText.text;
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"result"][@"username"] forKey:kUserName];
            BOOL login = [MineViewController defaultPerson].loginBool;
            [[NSUserDefaults standardUserDefaults] setBool:login forKey:kIsLogin];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf createAlert:@"200"];
        }else if ([self.string isEqualToString:@"手机号码不存在"]){
            [weakSelf createAlert:@"201"];
        }else if ([self.string isEqualToString:@"密码错误"]){
            [weakSelf createAlert:@"202"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 弹出警示框
-(void)createAlert:(NSString *)str
{
    if ([str isEqualToString:@"200"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertActionStyleDefault;
        
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
    if ([str isEqualToString:@"201"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲,手机号码不对!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertActionStyleDefault;
        [alert show];
    }
    if ([str isEqualToString:@"202"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲，密码不对哦!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertActionStyleDefault;
        [alert show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

#pragma mark -
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    MineViewController *mine = [MineViewController defaultPerson];
//    mine.isLoginPush = YES;
//    [MineViewController defaultPerson].Name = self.userNameText.text;
//    mine.loginBool = YES;
//    if (mine.isCancel == YES) {
//        mine.isCancel = NO;
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}










@end
