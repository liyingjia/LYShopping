//
//  WebViewController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "WebViewController.h"
#import "BaseViewController.h"
#import "UMSocial.h"
#import "CoreData+MagicalRecord.h"
#import "MainModel.h"
#import "Entity.h"
#import "MyCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "CommentViewController.h"


@interface WebViewController ()<UIWebViewDelegate,UMSocialUIDelegate,UIScrollViewDelegate>
{
    UIWebView *_webView;
    UIBarButtonItem *_favourBtn;
    UIScrollView *_scrollView;
    UIView *_view;
    UIAlertView *_alertView;
}
@property(nonatomic,strong)MainModel *mainModel;
@property(nonatomic,strong)NSArray *imagesArr;
@property(nonatomic,copy)NSString *action;
@end

@implementation WebViewController

-(id)initWithModel:(MainModel *)model action:(NSString *)action
{
    if (self=[super init]) {
        self.mainModel = model;
        self.action = action;
        [self createView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArr = [[NSArray alloc] init];
}

-(void)showDateWithImages:(NSArray *)images
{
    self.imagesArr = images;
    _view = [[UIView alloc] initWithFrame:_webView.frame];
    _view.backgroundColor = [UIColor blackColor];
    [_webView addSubview:_view];
    if ([self.action isEqualToString: @"piclist"]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self.view addSubview:_scrollView];
        [self showImages];
        UILabel *label = [Factory createLabelWithTitle:@"" frame:CGRectMake(10, ScreenHeight-60, ScreenWidth-20, 50) textColor:[UIColor whiteColor] fontSize:14.f];
        label.text = self.mainModel.title;
        [self.view addSubview:label];
        [_scrollView setContentSize:CGSizeMake(_scrollView.width *self.imagesArr.count, 0)];
    }
}

-(void)showImages
{
    for (NSInteger i=0; i<self.imagesArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.width, ScreenHeight/3, _scrollView.width, ScreenHeight/3)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,self.imagesArr[i]]]];
        [_scrollView addSubview:imageView];
    }
}
#pragma mark - 创建webView
-(void)createView
{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:KitemUrl,self.mainModel.id]]];
    _webView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
   
    [self createBarButton];
}
#pragma mark - 创建BUtton
-(void)createBarButton
{
    UIButton *leftBtn = [Factory createButtonWithTitle:nil frame:CGRectMake(0, 0, 40, 40) target:self selector:@selector(BtnClieck:)];
    leftBtn.tag = 101;
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back_btn_n.png"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back_btn_h.png"] forState:UIControlStateHighlighted];
    [self addItemsWithCustomViews:@[leftBtn] isLeft:YES];
    
    NSArray *images = @[@"comment_btn_n.png",@"share_btn_n.png",@"faved_btn_n.png"];
    NSArray *selectImages = @[@"comment_btn_h.png",@"share_btn_h.png",@"faved_btn_h.png"];
    NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<images.count; i++) {
        UIButton *button = [Factory createButtonWithTitle:nil frame:CGRectMake(0, 0, 40, 40) target:self selector:@selector(BtnClieck:)];
        button.tag = 102 + i;
        [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:selectImages[i]] forState:UIControlStateHighlighted];
        [buttonArr addObject:button];
    }
    [self addItemsWithCustomViews:buttonArr isLeft:NO];
}

- (void)addItemsWithCustomViews:(NSArray *)arr isLeft:(BOOL)isLeft {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (UIView *view in arr) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
        [items addObject:item];
    }
    //判断
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    }else {
        self.navigationItem.rightBarButtonItems = items;
    }
}
#pragma mark - Button点击事件
-(void)BtnClieck:(UIButton *)button{
    switch (button.tag) {
        case 101://返回
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 104://收藏
//            button.selected = YES;
//            [button setBackgroundImage:[UIImage imageNamed:@"faved_btn_n.png"] forState:UIControlStateSelected];
            [self conllectView];
            break;
        case 103://分享
        {
            [self UMShare];
        }
            break;
        case 102://评论
            [self toCommentView];
            break;
        default:
            break;
    }
}

#pragma mark -收藏
-(void)conllectView
{
    //根据title 查找数据库 是否是有该记录
    NSArray *titleArr = [Entity MR_findByAttribute:@"title" withValue:self.mainModel.title];
    if (titleArr.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已经收藏过啦" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    Entity *model = [Entity MR_createEntity];
    model.title = self.mainModel.title;
    model.des = self.mainModel.des;
    model.titlex = self.mainModel.titlex;
    model.icon = self.mainModel.icon;
    model.id = self.mainModel.id;
    model.adddate = self.mainModel.adddate;
    model.timestamp = self.mainModel.timestamp;
    model.action = self.action;
    //同步到本地
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 分享
-(void)UMShare
{
    //隐藏未安装的客户端平台 
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55ffe58ce0f55a91d2000f8d" shareText:@"喜欢就分享一下吧😊" shareImage:[UIImage imageNamed:@"icon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToEmail, nil] delegate:self];
}
//实现回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)toCommentView
{
    CommentViewController *comment = [[CommentViewController alloc] initWithId:self.mainModel.id];
    [self.navigationController pushViewController:comment animated:YES];
}

#pragma mark - UIWebViewDelefate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
#pragma mark - webView协议
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"加载中......" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(120, 48, 38, 38);
        [_alertView addSubview:activityView];
        [activityView startAnimating];
        [_alertView show];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载失败。。。");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
