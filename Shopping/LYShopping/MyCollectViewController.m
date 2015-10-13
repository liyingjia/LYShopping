//
//  MyCollectViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "MyCollectViewController.h"
#import "AFNetworking.h"
#import "MyCollectCell.h"
#import "BrandDetailModel.h"
#import "BrandDetailViewController.h"
#import "JHRefresh.h"
#import "LoginViewController.h"


@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic)NSInteger pageNumber;
@property(nonatomic)BOOL isRefresh;
@property(nonatomic)BOOL isLoading;
@property(nonatomic,strong)LoginViewController *login;
@property(nonatomic)UIButton *button;
@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的收藏";
    [self initData];
    [self createEditBtn];
    [self createRefreshView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createHttpRequest];
}

-(void)initData
{
    self.login = [[LoginViewController alloc] init];
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNumber = 1;
    self.isRefresh = NO;
    self.isLoading = NO;
}

-(void)createEditBtn
{
//    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonSystemItemEdit target:self action:@selector(btnClick)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

-(void)createHttpRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self downloadDataWithUrl:kGetCollect];
    [self createTableView];
}
#pragma mark - 下载数据
-(void)downloadDataWithUrl:(NSString *)url
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!isLogin) {
        
        self.button = [Factory createButtonWithTitle:@"还没有登录哦,快去登录吧" frame:CGRectZero target:self selector:@selector(buttonClick)];
        [self.button sizeToFit];
        
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setBackgroundColor:[UIColor redColor]];
        self.button.frame = CGRectMake(ScreenWidth/2-self.button.width/2, ScreenHeight/2-10, 150, 20);
        [self.view addSubview:self.button];
    }else{
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
        [MMProgressHUD showWithTitle:@"下载数据" status:@"loading..."];
        __weak typeof(self)weakSelf = self;
        //memberid=565137&access_token=426a52b6-958e-4d6c-831f-f0f274ba39db&pagesize=10&pagenumber=%d&v=2.1
        NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:kMemberid];
        NSString *access = [[NSUserDefaults standardUserDefaults] objectForKey:kAccess_token];
        NSDictionary *dict = @{@"memberid":memberid,@"access_token":access,@"pagesize":@"10",@"pagenumber":[NSString stringWithFormat:@"%lld",self.pageNumber],@"v":@"2.1"};
        [self.manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                if (weakSelf.pageNumber == 1) {
                    [weakSelf.dataArr removeAllObjects];
                }
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                [weakSelf.dataArr removeAllObjects];
                NSArray *arr = dict[@"result"][@"result"];
                for (NSDictionary *item in arr) {
                    BrandDetailModel *model = [[BrandDetailModel alloc] init];
                    [model setValuesForKeysWithDictionary:item];
                    [weakSelf.dataArr addObject:model];
                }
                
                [weakSelf.tableView reloadData];
                if (self.dataArr.count != 0) {
                    [self.view addSubview:self.tableView];
                }
                [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
                [weakSelf endRefresh];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
            [weakSelf endRefresh];
        }];

    }
}

-(void)buttonClick
{
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - 创建tableView
-(void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCollectCell" bundle:nil] forCellReuseIdentifier:@"MyCollectCell"];
    
    UILabel *label = [Factory createLabelWithTitle:@"还没有收藏哦!" frame:CGRectZero textColor:[UIColor blackColor] fontSize:15.f];
    [label sizeToFit];
    label.frame = CGRectMake(ScreenWidth/2-label.width/2, ScreenHeight/2-10, 200, 20);
    [self.view addSubview:label];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!isLogin) {
        label.alpha = 0;
    }else{
        self.button.alpha = 0;
    }
    
}
#pragma mark - UITableViewDelegate协议
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
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectCell" forIndexPath:indexPath];
    BrandDetailModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandDetailModel *model = self.dataArr[indexPath.row];
    BrandDetailViewController *brandController = [[BrandDetailViewController alloc] init];
    brandController.productid = model.productId;
//    [self.navigationController pushViewController:brandController animated:YES];
    [self presentViewController:brandController animated:YES completion:nil];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandDetailModel *model = self.dataArr[indexPath.row];
    [self.dataArr removeObject:model];
    [self.tableView reloadData];
    if (self.dataArr.count == 0) {
        self.tableView.alpha = 0;
    }
    [self deleCollection:model];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@",model.productId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self downloadDataWithUrl:kGetCollect];
}

#pragma mark - 取消收藏
-(void)deleCollection:(BrandDetailModel *)model
{
    //memberid=565137&access_token=426a52b6-958e-4d6c-831f-f0f274ba39db&productid=%@
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:kMemberid];
    NSString *access = [[NSUserDefaults standardUserDefaults] objectForKey:kAccess_token];
    NSDictionary *dict = @{@"memberid":memberid,@"access_token":access,@"productid":model.productId};
    [self.manager POST:kDeleCollect parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict:%@",dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"连接失败");
    }];
}

#pragma mark - 创建刷新
-(void)createRefreshView
{
    __weak typeof(self)weakSelf = self;
    [weakSelf.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class]beginRefresh:^{
        if (weakSelf.isRefresh) {
            return;
        }
        weakSelf.isRefresh = YES;
        weakSelf.pageNumber = 1;
        [weakSelf downloadDataWithUrl:kGetCollect];
    }];
    
    [weakSelf.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoading) {
            return;
        }
        weakSelf.isLoading = YES;
        weakSelf.pageNumber ++;
        [weakSelf downloadDataWithUrl:kGetCollect];
    }];
}

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



@end
