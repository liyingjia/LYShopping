//
//  NewViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "NewViewController.h"
#import "AFNetworking.h"
#import "BrandModel.h"
#import "JHRefresh.h"

@interface NewViewController ()

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic)NSInteger page;
@property (nonatomic)BOOL isRefresh;
@property (nonatomic)BOOL isLoading;

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHttpRequest];
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
        dict = @{@"pagenumber":[NSString stringWithFormat:@"%ld",self.page],@"pagesize":@"10",@"noStock":@"1",@"searchtext":[NSString stringWithFormat:@"%@",self.keyWord],@"v":@"2.0",@"order":@"4"};
        
    }else if (self.model.categoryId != NULL) {
         dict = @{@"pagenumber":[NSString stringWithFormat:@"%ld",self.page],@"pagesize":@"10",@"noStock":@"1",@"cid":[NSString stringWithFormat:@"%@",self.brandId],@"v":@"2.0",@"order":@"4"};
    }else{
        dict = @{@"pagenumber":[NSString stringWithFormat:@"%ld",self.page],@"pagesize":@"10",@"noStock":@"1",@"brandid":[NSString stringWithFormat:@"%@",self.brandId],@"v":@"2.0",@"order":@"4"};
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
            [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
            [weakSelf endRefresh];
        }
     
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf endRefresh];
    }];
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
        weakSelf.isLoading = YES;
        weakSelf.page ++;
        [weakSelf downloadWithUrl:kDetailCate isRefresh:YES];
    }];
}

#pragma mark - 结束刷新
-(void)endRefresh
{
    if (self.isRefresh) {
        self.isRefresh = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    
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
