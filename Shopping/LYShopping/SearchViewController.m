//
//  SearchViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
#import "CategoryModel.h"
#import "ContainerViewController.h"
#import "RootViewController.h"
#import "SearchCell.h"

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *searchArr;
@property (nonatomic)UISearchBar *searchBar;

@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    NSLog(@"arr%@",self.searchArr);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSearchBar];
    [self createHttpRequest];
    [self createTableView];
    [self createCollectionView];
    
}
#pragma mark - 创建搜索框
-(void)createSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 24)];
    self.searchBar.delegate = self;
    self.searchBar.translucent = NO;
    self.searchBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.layer.cornerRadius = 25;
    self.searchBar.placeholder = @"请输入商品关键字";
    self.navigationItem.titleView = self.searchBar;
}
#pragma mark - 创建UITableVIew
-(void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Default*self.searchArr.count) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
#pragma mark - 创建UICollectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, Default);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth-40, ScreenHeight-20) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellWithReuseIdentifier:@"SearchCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [self.view addSubview:self.collectionView];
}
#pragma mark - 初始化请求连接
-(void)createHttpRequest
{
    self.dataArr = [[NSMutableArray alloc] init];
    self.searchArr = [[NSMutableArray alloc] init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self downloadWithUrl:kSearch];
}
#pragma mark - 下载数据
-(void)downloadWithUrl:(NSString *)url
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"搜索数据" status:@"loading..."];
    __weak typeof(self)weakSelf = self;
    [self.manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dict[@"hotSearchWordsList"];
            for (NSDictionary *item in array) {
                CategoryModel *model = [[CategoryModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [weakSelf.dataArr addObject:model];
            }
        }
        [weakSelf.collectionView reloadData];
        [MMProgressHUD dismissWithSuccess:@"OK" title:@"搜索数据"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate 协议
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CategoryModel *model = self.searchArr[indexPath.row];
    cell.textLabel.text = model.keyWords;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button = [Factory createButtonWithTitle:@"清空搜索历史" frame:CGRectMake(LeftDistance, 5, ScreenWidth-2*LeftDistance, Default-10) target:self selector:@selector(deleteArr)];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1;
    return button;
}
//删除搜索记录
-(void)deleteArr
{
    [self.searchArr removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - UICollectionViewDelegate 协议
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCell" forIndexPath:indexPath];
    CategoryModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

//设置头部大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.searchArr.count != 0) {
        return CGSizeMake(ScreenWidth, ScreenHeight-self.tableView.height);
    }
    return CGSizeMake(ScreenWidth, 30);
}
//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    //    kind  如果系统要复用头部,kind就是头部
    //    kind  如果系统要复用尾部,kind就是尾部
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        //定制头部,头部复用
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        if (self.searchArr.count != 0) {
            [head addSubview:self.tableView];
//        [self.tableView reloadData];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        label.text = @"热门搜索";
        [head addSubview:label];
        return head;
    }
    else
    {
        //定制尾部
        UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath];
        foot.backgroundColor = [UIColor blueColor];
        return foot;
    }
}


//点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *model = self.dataArr[indexPath.row];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTitle:model.keyWords];
    self.navigationItem.backBarButtonItem = backBtn;
    //把搜索内容添加到数组中
    [self.searchArr addObject:model.keyWords];
    
    NSArray *titles = @[@"人气",@"最新",@"价格^",@"大图"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSArray *names = @[@"PopularViewController",@"NewViewController",@"PriceViewController",@"BigPicViewController"];
    ContainerViewController *container = [[ContainerViewController alloc] init];
    for (int i=0; i<titles.count; i++) {
        Class cls = NSClassFromString(names[i]);
        RootViewController *root = [[cls alloc] init];
        root.title = titles[i];
        root.keyWord = model.keyWords;
        [viewControllers addObject:root];
    }
    container.viewControllers = viewControllers;
    container.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:container animated:YES];
}

//设置cell的偏移量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

#pragma mark - -UISearchBarDelegate
//将要进入编辑模式调用
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
//将要退出编辑模式调用
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
//点击cancle按钮时调用
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
//点击搜索按钮被调用
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchArr addObject:searchBar.text];
    [self.tableView reloadData];
//    [self.collectionView reloadData];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTitle:searchBar.text];
    self.navigationItem.backBarButtonItem = backBtn;
    NSArray *titles = @[@"人气",@"最新",@"价格^",@"大图"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSArray *names = @[@"PopularViewController",@"NewViewController",@"PriceViewController",@"BigPicViewController"];
    ContainerViewController *container = [[ContainerViewController alloc] init];
    for (int i=0; i<titles.count; i++) {
        Class cls = NSClassFromString(names[i]);
        RootViewController *root = [[cls alloc] init];
        root.title = titles[i];
        root.keyWord = searchBar.text;
        [viewControllers addObject:root];
    }
    container.viewControllers = viewControllers;
    container.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:container animated:YES];

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
