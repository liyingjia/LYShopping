//
//  MineViewController.m
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MyCollectViewController.h"
#import "SDImageCache.h"
#import "ZCZBarViewController.h"
#import "UIImageView+WebCache.h"
#import "AboutUsViewController.h"

#define kHeadView 150

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UIButton *loginoutButton;
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic)UIImagePickerController *imagePicker;
@end

@implementation MineViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}
#pragma mark - 创建单例
+(instancetype)defaultPerson
{
    static MineViewController *person = nil;
    @synchronized(self){
        if (person == nil) {
            person = [[self alloc] init];
        }
    }
    return person;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self loadHeadView];
}


-(void)loadHeadView
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (isLogin){
        self.label.text = [NSString stringWithFormat:@"用户:%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]];
        self.loginButton.alpha = 0;
        self.loginoutButton = [Factory createButtonWithTitle:@"注销" frame:CGRectZero titleFont:14.f textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] target:self selector:@selector(loginoutClick)];
        self.loginoutButton.frame = CGRectMake(ScreenWidth/2-50, self.label.bottom+10, 100, 30);
        [self.headView addSubview:self.loginoutButton];
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.label.left-70, self.label.top, 60, 60)];
        //获取沙盒路径
        NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *imagePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.label.text]];
//        NSLog(@"%@",imagePath);
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        NSString *imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kImageUrl];
//        NSLog(@"url:%@",imageUrl);
        if (![imageUrl isEqualToString:@""]) {
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        }
        if(image == nil){
            self.headImage.image = [UIImage imageNamed:@"head"];
        }else{
            self.headImage.image = image;
        }
        self.headImage.userInteractionEnabled = YES;
        self.headImage.layer.cornerRadius = self.headImage.width/2;
        self.headImage.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HeadImageClick:)];
        [self.headImage addGestureRecognizer:tap];
        [self.headView addSubview:self.headImage];
    }
}

#pragma mark - 点击头像更换图片
-(void)HeadImageClick:(UITapGestureRecognizer *)tap
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [action showInView:self.view];
}
#pragma mark - 调用相机或相册上传图片
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://调用相册
        {
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            self.imagePicker.allowsEditing = YES;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
            break;
        case 1:
        {
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            self.imagePicker.allowsEditing = YES;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
    }
    UIImage *headImg = [MineViewController imageWithImageSimple:image scaledToSize:CGSizeMake(60, 60)];
    self.headImage.image = headImg;
    [self saveImage:headImg withName:[NSString stringWithFormat:@"%@.jpg",self.label.text]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

+(UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 保存图片到本地
-(void)saveImage:(UIImage *)tempImage withName:(NSString *)imageName
{
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    //　从Documents目录下获取图片
    //　要从Documents下面获取图片，我们首先需要获取Documents目录的路径。
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [paths objectAtIndex:0];
    NSString *fullPathToFile = [document stringByAppendingPathComponent:imageName];
//    NSLog(@"path:%@",fullPathToFile);
    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark - 注销登录
-(void)loginoutClick
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLogin];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要退出吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}
#pragma mark - 点击警示框的按钮
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.loginoutButton.alpha = 0;
        self.loginButton.alpha = 1;
        self.label.text = @"Hi,欢迎来到珍品网!";
        self.headImage.alpha = 0;
    }
}


-(void)initData
{
    self.images = @[@"icon_wallet",@"icon_site",@"icon_set",@"icon_help"];
    self.titles = @[@"清理缓存",@"关于我们",@"二维码扫描",@"意见反馈"];
}

#pragma mark - 创建TableView
-(void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(kHeadView, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHeadView, ScreenWidth, kHeadView)];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.image = [UIImage imageNamed: @"my_personal_not_login_bg"];
    [self.tableView addSubview:self.imageView];
    self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHeadView, ScreenWidth, kHeadView)];
    self.headView.backgroundColor = [UIColor clearColor];
    self.headView.userInteractionEnabled = YES;
    [self.tableView addSubview:self.headView];
    [self createButton];
}
#pragma mark - 创建按钮
-(void)createButton
{
    self.label = [Factory createLabelWithTitle:@"Hi,欢迎来到珍品网!" frame:CGRectZero textColor:[UIColor blackColor] fontSize:15.f];
    [self.label sizeToFit];
    self.label.frame = CGRectMake(ScreenWidth/2-self.label.width/2, self.headView.height/2-20, 200, 20);
    [self.headView addSubview:self.label];
    
    self.loginButton = [Factory createButtonWithTitle:@"登录/注册" frame:CGRectZero titleFont:14.f textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] target:self selector:@selector(loginClick)];
    //[self.loginButton sizeToFit];
    self.loginButton.frame = CGRectMake(ScreenWidth/2-50, self.label.bottom+10, 100, 30);
    [self.headView addSubview:self.loginButton];
}

#pragma mark - 登录
-(void)loginClick
{
    LoginViewController *login = [[LoginViewController alloc] init];
    login.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - 改变图片大小和位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffSet = scrollView.contentOffset.y;
    CGFloat xOffSet = (yOffSet + kHeadView)/2;
    if (yOffSet < -kHeadView) {
        CGRect frame = self.imageView.frame;
        frame.origin.y = yOffSet;
        frame.size.height = -yOffSet;
        frame.origin.x = xOffSet;
        frame.size.width = ScreenWidth + fabs(xOffSet)*2;
        self.imageView.frame = frame;
    }
}

#pragma mark - UITableViewViewDelegate协议
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
    //cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            NSUInteger fileSize = [[SDImageCache sharedImageCache] getSize];
            CGFloat size = fileSize/1024.0/1024.0;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:[NSString stringWithFormat:@"缓存大小%.1fM",size] preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                //清理缓存
                [[SDImageCache sharedImageCache] clearMemory];
                [[SDImageCache sharedImageCache] clearDisk];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 1:
        {
            AboutUsViewController *aboutUs = [[AboutUsViewController alloc] init];
            aboutUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
        case 2:
        {
            ZCZBarViewController *vc = [[ZCZBarViewController alloc] initWithIsQRCode:NO Block:^(NSString *result, BOOL isFinish) {
                NSLog(@"result:%@",result);
            }];
            [self presentViewController:vc animated:YES completion:nil];

        }
            break;
        case 3:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"爱真品" message:@"如果你有什么意见，请联系QQ:877951499" preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
