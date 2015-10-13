//
//  CategoryViewController.m
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "CategoryViewController.h"
#import "SearchViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"
#import "CategoryModel.h"
#import "ContainerViewController.h"
#import "RootViewController.h"

@interface CategoryViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//@property (nonatomic)UISearchBar *searchBar;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *imagesArr;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *categoryIds;
@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = NO;
    [self createSearchBar];
    [self createTableView];
    [self createCollectView];
    [self createHttpRequest];
    [self downloadWithUrl:kCategory cateoryId:@"5"];
}

#pragma mark - 创建searchBar
-(void)createSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 24)];
    searchBar.delegate = self;
    searchBar.translucent = NO;
    searchBar.barStyle = UIBarStyleBlackTranslucent;
    searchBar.layer.masksToBounds = YES;
    searchBar.layer.cornerRadius = 25;
    searchBar.placeholder = @"请输入商品关键字";
    self.navigationItem.titleView = searchBar;
}
#pragma mark - 创建tableView
-(void)createTableView
{
    self.titles = @[@"箱包",@"服装",@"配饰",@"鞋履",@"手表",@"生活家居",@"个护美妆",@"母婴",@"礼品卡"];
    self.categoryIds = @[@"5",@"26",@"12",@"39",@"246",@"415",@"436",@"478",@"312"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 70, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:self.tableView];
}
#pragma mark - 初始化请求连接
-(void)createHttpRequest
{
    self.dataArr = [[NSMutableArray alloc] init];
    self.imagesArr = [[NSMutableArray alloc] init];
    self.titleArr = [[NSMutableArray alloc] init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark - 下载数据
-(void)downloadWithUrl:(NSString *)url cateoryId:(NSString *)categoryId
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"下载数据" status:@"loading..."];
    __weak typeof(self)weakSelf = self;
    NSDictionary *dict = @{@"categoryid":categoryId,@"v":@"2.0"};
    [self.manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [self.dataArr removeAllObjects];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
//            NSArray *goodsBrands = result[@"GoodsBrands"];
//            for (NSDictionary *item in goodsBrands) {
//                CategoryModel *model = [[CategoryModel alloc] init];
//                [model setValuesForKeysWithDictionary:item];
//                [weakSelf.imagesArr addObject:model];
//            }
            
            NSArray *cateroryChild = result[@"CategoryChildren"];
            [weakSelf.titleArr removeAllObjects];
            for (NSDictionary *item in cateroryChild) {
                CategoryModel *model = [[CategoryModel alloc] init];
                model.gatherName = item[@"gatherName"];
                [weakSelf.titleArr addObject:model];
                model.array = item[@"gtCategoryChildrens"];
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *child in model.array) {
                    CategoryModel *model = [[CategoryModel alloc] init];
                    [model setValuesForKeysWithDictionary:child];
                    [arr addObject:model];
                }
                [weakSelf.dataArr addObject:arr];
            }
            [weakSelf.collectionView reloadData];
            [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - 创建collectionView
-(void)createCollectView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(85, 140);
    layout.minimumInteritemSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.tableView.width, 64, ScreenWidth-self.tableView.width, ScreenHeight-64-44) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [self.view addSubview:self.collectionView];
    
}


#pragma mark - UITableViewDelegate 协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont systemFontOfSize:13.f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"default_btn"]];
    cell.backgroundColor = RGB(175, 255, 202);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self downloadWithUrl:kCategory cateoryId:self.categoryIds[indexPath.row]];
}
#pragma mark - UISearchBarDelegate 协议
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController *search = [[SearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark - CollectionViewDelegate 协议
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArr[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    CategoryModel *model = self.dataArr[indexPath.section][indexPath.row];
    [cell showDateWithModel:model];
    return cell;
}

//设置cell的偏移量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//设置头部大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth-self.tableView.width, 30);
}
//定制headView和footView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *model = self.titleArr[indexPath.section];
    
    //    kind  如果系统要复用头部,kind就是头部
    //    kind  如果系统要复用尾部,kind就是尾部
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        //定制头部,头部复用
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-self.tableView.width, 30)];
        label.text = [NSString stringWithFormat:@"----------%@----------",model.gatherName];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor yellowColor];
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
    CategoryModel *model = self.dataArr[indexPath.section][indexPath.row];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTitle:model.categoryName];
    self.navigationItem.backBarButtonItem = backBtn;
    
    NSArray *titles = @[@"人气",@"最新",@"价格",@"价格"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSArray *names = @[@"PopularViewController",@"NewViewController",@"PriceViewController",@"BigPicViewController"];
    ContainerViewController *container = [[ContainerViewController alloc] init];
    for (int i=0; i<titles.count; i++) {
        Class cls = NSClassFromString(names[i]);
        RootViewController *root = [[cls alloc] init];
        root.title = titles[i];
        root.model = model;
        root.brandId = [model.categoryId stringValue];
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



@end














