//
//  BeginOpenViewController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BeginOpenViewController.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "CategoryViewController.h"

@interface BeginOpenViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation BeginOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
}

-(void)createCollectionView
{
    self.dataArr = [[NSMutableArray alloc] initWithObjects:@"image1",@"image2",@"image3", nil];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = Screen;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.collectionView.pagingEnabled = YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.dataArr[indexPath.row]]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArr.count-1) {
        MainViewController *main = [[MainViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
        DDMenuController *menu = [[DDMenuController alloc] initWithRootViewController:nav];
        UINavigationController *leftController = [[UINavigationController alloc] initWithRootViewController:[[CategoryViewController alloc] init]];
        menu.leftViewController = leftController;
#if 0
        [self presentViewController:menu animated:YES completion:nil];
#else
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        window.rootViewController = menu;
#endif
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
