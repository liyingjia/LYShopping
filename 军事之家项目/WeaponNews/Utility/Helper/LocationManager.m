//
//  LocationManager.m
//  LimitFree
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "LocationManager.h"

//单例所指向的内存区域，整个APP进程只有一次初始化
static LocationManager *manager = nil;

@implementation LocationManager

+(LocationManager *)shareSingleton
{
    @synchronized(self){
        if (!manager) {
            manager = [[LocationManager alloc] init];
        }
    }
    return manager;
}


-(instancetype)init
{
    if (self=[super init]) {
        //初始化系统定位管理器
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        //定位精度
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        //请求授权
        [self.manager requestAlwaysAuthorization];
    }
    return self;
}

/*
 针对系统定位的顶层封装的好处
 1.子试图控制器或其他组件可以用更少的代码完成响应的任务
 2.底层内容或者调用改变，只需改变中间的封装层，对于各个组件并无影响
 */
+(void)getUserLocation:(GetLocationInformation)block
{
    if (!manager) {
        manager = [LocationManager shareSingleton];
    }
    manager.callBack = block;
    [manager.manager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _callBack([locations lastObject]);
    [manager stopUpdatingLocation];
}

@end












