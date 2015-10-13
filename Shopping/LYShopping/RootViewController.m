//
//  RootViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "RootViewController.h"
#import "BrandModel.h"
#import "BrandCategoryCell.h"
#import "AFNetworking.h"
#import "JHRefresh.h"
#import "BrandDetailViewController.h"


@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic)NSInteger page;
@property (nonatomic)BOOL isRefresh;
@property (nonatomic)BOOL isLoading;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHttpRequest];
    [self createTableView];
    [self createRefresh];
}

-(void)createHttpRequest
{
    self.dataArr = [[NSMutableArray alloc] init];
    self.page = 1;
    self.isRefresh = NO;
    self.isLoading = NO;
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self downloadWithUrl:kDetailCate isRefresh:NO];
}

-(void)downloadWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"下载数据" status:@"loading..."];
    __weak typeof(self)weakSelf = self;
    //pagenumber=%ld&pagesize=10&noStock=1&brandid=%@&v=2.0
    //order = 4,3,2
    NSDictionary *dict = nil;
    if (self.keyWord.length != 0) {
        dict = @{@"pagenumber":[NSString stringWithFormat:@"%ld",self.page],@"pagesize":@"10",@"noStock":@"1",@"searchtext":[NSString stringWithFormat:@"%@",self.keyWord],@"v":@"2.0"};
        
    }else if (self.model.categoryId != NULL) {
        dict = @{@"pagenumber":[NSString stringWithFormat:@"%ld",self.page],@"pagesize":@"10",@"noStock":@"1",@"cid":[NSString stringWithFormat:@"%@",self.brandId],@"v":@"2.0"};
    }else{
        dict = @{@"pagenumber":[NSString stringWithFormat:@"%ld",self.page],@"pagesize":@"10",@"noStock":@"1",@"brandid":[NSString stringWithFormat:@"%@",self.brandId],@"v":@"2.0"};
    }
    [self.manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (weakSelf.page == 1) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *result = dicts[@"result"][@"result"];
            for (NSDictionary *item in result) {
                BrandModel *model = [[BrandModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
            [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载完成"];
            [weakSelf endRefresh];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf endRefresh];
    }];
}
#pragma mark - 创建tableView
-(void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-35) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BrandCategoryCell" bundle:nil] forCellReuseIdentifier:@"BrandCategoryCell"];
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
    BrandCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCategoryCell" forIndexPath:indexPath];
    BrandModel *model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth*90/320;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BrandModel *model = self.dataArr[indexPath.row];
    BrandDetailViewController *brandDetail = [[BrandDetailViewController alloc] init];
    brandDetail.productid = model.productId;
    brandDetail.pisSpecial = model.pisSpecial;
    
    [self.view.window.rootViewController presentViewController:brandDetail animated:YES completion:nil];
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
    //rippleEffect  cube  pageCurl  pageUnCurl  rotate  oglFlip  fade  moveIn  suckEffect
    anima.type = @"suckEffect";
    anima.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:anima forKey:nil];
}

#pragma mark - 创建刷新视图
-(void)createRefresh
{
    __weak typeof(self)weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return;
        }
        weakSelf.isRefresh = YES;
        weakSelf.page = 1;
        [weakSelf downloadWithUrl:kDetailCate isRefresh:YES];
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoading) {
            return;
        }
        weakSelf.page ++;
        weakSelf.isLoading = YES;
        [weakSelf downloadWithUrl:kDetailCate isRefresh:YES];
    }];
}

#pragma mark - 结束刷新
-(void)endRefresh
{
    //下拉
    if (self.isRefresh) {
        self.isRefresh = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    //上拉
    if (self.isLoading) {
        self.isLoading = NO;
        [self.tableView footerEndRefreshing];
    }
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
