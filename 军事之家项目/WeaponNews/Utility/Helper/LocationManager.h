//
//  LocationManager.h
//  LimitFree
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//声明这个block
typedef void(^GetLocationInformation)(CLLocation *location);

//定位管理
@interface LocationManager : NSObject<CLLocationManagerDelegate>


@property (nonatomic,strong)CLLocationManager *manager;
//定义一个返回定位信息的block
@property (nonatomic,copy)GetLocationInformation callBack;

//获取用户定位信息
+(void)getUserLocation:(GetLocationInformation)block;

//初始化管理器
+(LocationManager *)shareSingleton;

@end
