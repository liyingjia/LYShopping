//
//  CommentSubmitController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "CommentSubmitController.h"
#import "AFNetworking.h"
//#import "CommentViewController.h"

@interface CommentSubmitController ()<UITextViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property(nonatomic,copy)NSString *content;
@property(nonatomic,strong)UITextView *textView;
@end

@implementation CommentSubmitController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"写评论";
    [self createView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

-(id)initWithId:(NSString *)uid
{
    if (self=[super init]) {
        self.uid = uid;
    }
    return self;
}

-(void)createView
{
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
//    self.textView.text = @"写点什么...";
    self.textView.font = [UIFont systemFontOfSize:14.f];
    self.textView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.textView];
    
    UIButton *button1 = [Factory createButtonWithTitle:nil frame:CGRectMake(0, 0, 40, 40) target:self selector:@selector(btnClieck:)];
    button1.tag = 101;
    [button1 setBackgroundImage:[UIImage imageNamed: @"back_btn_n"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed: @"back_btn_h"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIButton *button2 = [Factory createButtonWithTitle:nil frame:CGRectMake(0, 0, 40, 40) target:self selector:@selector(btnClieck:)];
    button2.tag = 102;
    [button2 setBackgroundImage:[UIImage imageNamed: @"send_n"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed: @"send_h"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = rightBtn;
}


-(void)btnClieck:(UIButton *)button
{
    switch (button.tag) {
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            [self sendDataToService];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)sendDataToService
{
    self.content = self.textView.text;
   
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *dict = @{@"action":@"wzpl",@"id":[NSString stringWithFormat:@"%@",self.uid],@"name":@"匿名",@"content":[NSString stringWithFormat:@"%@",self.content],@"avator":@"",@"uid":@"13907332",@"platform":@"a",@"mobile":@"GT-S7562i",@"pid":@"10106",@"e":@"90fff795f0a1f0daecf160e0606761b9"};
    NSString *url = [kCommentSubmit stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict:%@",dict[@"msg"]);
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败");
    }];
}

//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@"写点什么..."]) {
//        textView.text = @"";
//    }
//}
//
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//    if (textView.text.length<1) {
//        textView.text = @"写点什么...";
//    }
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

@end















