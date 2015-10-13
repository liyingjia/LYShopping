//
//  HomeViewController.m
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "HomeViewController.h"
#import "ADView.h"
#import "SecondKillView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MainModel.h"
#import "UIButton+WebCache.h"
#import "WebViewController.h"
#import "HomeCell.h"
#import "SearchViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_headView;
    UITableView *_tableView;
    ADView *_view;
    SecondKillView *_secondsView;
    AFHTTPRequestOperationManager *_manager;
}

@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)MainModel *model;
@property (nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,strong)NSMutableArray *urlArr;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"梦-爱珍品";
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"home_top_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItem = search;
    
    
    [self createHeadView];
    [self createHttpRequest];
    [self createTableView];
}
#pragma mark - 创建请求连接
-(void)createHttpRequest
{
    self.dataArr = [[NSMutableArray alloc] init];
    self.imageArr = [[NSMutableArray alloc] init];
    self.urlArr = [[NSMutableArray alloc] init];
    self.titleArr = [[NSMutableArray alloc] init];
    self.model = [[MainModel alloc] init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self downloadWithUrl:kHomeUrl];
}

#pragma mark - 下载数据
-(void)downloadWithUrl:(NSString *)url
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"下载数据" status:@"loading..."];
    __weak typeof(self)weakSerf = self;
    [weakSerf.manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *showList = dict[@"result"][@"showList"];
            for (NSDictionary *item in showList) {
                MainModel *model = [[MainModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [weakSerf.imageArr addObject:model.img];
                [weakSerf.titleArr addObject:model.name];
                [weakSerf.urlArr addObject:model.url];
            }
            [self createButton];
            
            NSArray *grouplst = dict[@"result"][@"grouplst"];
            for (NSDictionary *item in grouplst) {
                MainModel *model = [[MainModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [weakSerf.dataArr addObject:model];
            }
            [weakSerf.tableView reloadData];
            [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 搜索
-(void)searchClick
{
    SearchViewController *search = [[SearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 创建顶部视图
-(void)createHeadView
{
    //头视图
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenWidth*310/320)];
    _headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"headview_background"]];
    //广告栏
    _view = [[ADView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*130/320) block:^(NSString *url) {
        WebViewController *web = [[WebViewController alloc] init];
        [self showAnimation];
        web.url = url;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }];
    _view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"homebg1"]];
    [_headView addSubview:_view];
    //滑动栏
    _secondsView = [[[NSBundle mainBundle] loadNibNamed:@"SecondKillView" owner:nil options:nil] lastObject];
    [_secondsView downloadDataWithUrl:kSecondKill Block:^(NSString *url) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        [backBtn setTitle:@"秒杀"];
        self.navigationItem.backBarButtonItem = backBtn;
        WebViewController *web = [[WebViewController alloc] init];
        web.url = url;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }];

    CGRect frame = _secondsView.frame;
    frame.origin.x = 0;
    frame.origin.y = _view.bottom+ScreenWidth*70/320;
    frame.size.width = ScreenWidth;
    frame.size.height = ScreenWidth*112/320;
    _secondsView.frame = frame;
    [_headView addSubview:_secondsView];
}

#pragma mark - 中间4个button
-(void)createButton
{
    CGFloat width = ScreenWidth*45/320;
    CGFloat space = (ScreenWidth-4*width)/4;
    
    for (int i=0; i<4; i++) {
        UIButton *button = [Factory createButtonWithTitle:self.titleArr[i] frame:CGRectMake(width/2+i*(width+space), _view.bottom+10, width, width) target:self selector:@selector(btnClick:)];
        button.tag = 101 + i;
        [button sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i]] forState:UIControlStateNormal];
//        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.imageArr[i]] forState:UIControlStateNormal];
//        button.imageEdgeInsets = UIEdgeInsetsMake(0,12,25,19);
//        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        button.backgroundColor = [UIColor cyanColor];
//        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        button.titleEdgeInsets = UIEdgeInsetsMake(50, -90, 0, 0);
        [_headView addSubview:button];
        UILabel *label = [Factory createLabelWithTitle:self.titleArr[i] frame:CGRectMake(button.center.x-30, button.bottom+5, 60, 20) textColor:[UIColor blackColor] fontSize:12.f];
        label.textAlignment = NSTextAlignmentCenter;
//        [label sizeToFit];
        [_headView addSubview:label];
    }
}
#pragma mark - button点击事件
-(void)btnClick:(UIButton *)button
{
    NSInteger i = button.tag - 101;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTitle:self.titleArr[i]];
    self.navigationItem.backBarButtonItem = backBtn;
    WebViewController *web = [[WebViewController alloc] init];
    [self showAnimation];
    web.url = self.urlArr[i];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 创建TableView
-(void)createTableView
{
     self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = _headView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"HomeCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate 协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    MainModel *model = self.dataArr[indexPath.row];
    [cell showDateWithModel:model];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"headview_background"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth*230/320;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainModel *model = self.dataArr[indexPath.row];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTitle:model.adShow];
    self.navigationItem.backBarButtonItem = backBtn;
    
    WebViewController *web = [[WebViewController alloc] init];
    [self showAnimation];
    
    NSArray *array = [model.url componentsSeparatedByString:@"&"];
    NSString *str = [array lastObject];
    NSString *url = [kHomeDetail stringByAppendingFormat:@"&%@",str];
    web.url = url;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

-(void)showAnimation
{
    CATransition *anima = [CATransition animation];
    [anima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    //设置动画时间
    anima.duration = 1;
    //kCATransitionFade    新视图逐渐显示在屏幕上，旧视图逐渐淡化出视野
    //kCATransitionMoveIn  新视图移动到旧视图上面，好像盖在上面
    //kCATransitionPush    新视图将旧视图退出去
    //kCATransitionReveal  将旧视图移开显示下面的新视图
    //rippleEffect  cube  pageCurl  pageUnCurl  rotate  oglFlip  fade  moveIn
    anima.type = @"rippleEffect";
    anima.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:anima forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
