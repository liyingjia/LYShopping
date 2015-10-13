//
//  BrandViewController.m
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BrandViewController.h"
#import "AFNetworking.h"
#import "MainModel.h"
#import "BrandCell.h"
#import "RootViewController.h"
#import "ContainerViewController.h"
#import "AllBrandViewController.h"

@interface BrandViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;

@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"品牌馆";
    [self initData];
    [self createHttpRequest];
    [self createView];
}

-(void)initData
{
    self.dataArr = [[NSMutableArray alloc] init];
    [self createButton];
}

-(void)createButton
{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 30)];
//    label.text = @"品牌馆";
//    label.textColor = [UIColor blackColor];
//    self.navigationItem.titleView = label;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"全部品牌" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
    [rightBtn setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)btnClick:(UIBarButtonItem *)button
{
    AllBrandViewController *allBrand =[[AllBrandViewController alloc] init];
    [self.navigationController pushViewController:allBrand animated:YES];
}

-(void)createHttpRequest
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"下载数据" status:@"loading..."];
    __weak typeof(self)weakSelf = self;
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager POST:kBrand parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSArray *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *item in dict) {
                MainModel *model = [[MainModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
            [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)createView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BrandCell" bundle:nil] forCellReuseIdentifier:@"BrandCell"];
    [self.view addSubview:self.tableView];
}

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
    BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCell" forIndexPath:indexPath];
    MainModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth*150/320;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainModel *model = self.dataArr[indexPath.row];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTitle:model.brandName];
    self.navigationItem.backBarButtonItem = backBtn;
    
    NSArray *titles = @[@"人气",@"最新",@"价格",@"价格"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSArray *names = @[@"PopularViewController",@"NewViewController",@"PriceViewController",@"BigPicViewController"];
    ContainerViewController *container = [[ContainerViewController alloc] init];
    for (int i=0; i<titles.count; i++) {
        Class cls = NSClassFromString(names[i]);
        RootViewController *root = [[cls alloc] init];
        root.title = titles[i];
        root.brandId = [model.brandId stringValue];
        [viewControllers addObject:root];
    }
    [self showAnimation];
    container.viewControllers = viewControllers;
    container.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:container animated:YES];
    
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


@end
