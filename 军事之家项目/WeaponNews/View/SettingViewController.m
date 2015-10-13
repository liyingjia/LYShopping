//
//  SettingViewController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "SettingViewController.h"
#import "SDImageCache.h"
#import "MyCollectionViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"layout_bg"]];
    self.navigationItem.title = @"设置";
    self.dataArr = [[NSMutableArray alloc] initWithObjects:@"清除缓存",@"我的收藏",@"意见反馈",@"关于我们", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"listitem_right_arrow"]];
    imageView.frame = CGRectMake(self.view.width-2*LeftDistance, Default/2-LeftDistance, LeftDistance, 2*LeftDistance);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSUInteger fileSize = [[SDImageCache sharedImageCache] getSize];
        CGFloat size = fileSize/1024.0/1024.0;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清除缓存" message:[NSString stringWithFormat:@"缓存大小%.6fM",size] preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }else if(indexPath.row == 1){
        MyCollectionViewController *collect = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:collect animated:YES];
        
    }else if (indexPath.row == 2){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"兵器之家" message:@"欢迎阅读兵器之家" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于我们" message:@"你的阅读，就是我们的成功,这里有你知道的和不了解的,全球先进的兵器!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
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
