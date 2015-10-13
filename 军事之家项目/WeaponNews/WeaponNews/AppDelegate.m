//
//  AppDelegate.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "CategoryViewController.h"
#import "BeginOpenViewController.h"

#import "UMSocial.h"
#import "CoreData+MagicalRecord.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//创建数据库
-(void)initCoreData
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"WeaponNewsData.sqlite"];
}
//初始化友盟
-(void)initUM{
    //55efff08e0f55af3a900269d
    [UMSocialData setAppKey:@"55ffe58ce0f55a91d2000f8d"];
}

#pragma mark - 其他app访问当前app 回调的方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initCoreData];
    //初始化 友盟
    [self initUM];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *main = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
    
    DDMenuController *ddController = [[DDMenuController alloc] initWithRootViewController:nav];
    _menuController = ddController;
    UINavigationController *leftController = [[UINavigationController alloc] initWithRootViewController:[[CategoryViewController alloc] init]];
//    CategoryViewController *leftController = [[CategoryViewController alloc] init];
    ddController.leftViewController = leftController;
    
    BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:kIsOpen];
    if (!isOpen) {
        BeginOpenViewController *begin = [[BeginOpenViewController alloc] init];
        self.window.rootViewController = begin;
    }else{
        self.window.rootViewController = ddController;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsOpen];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
