//
//  Entity.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titlex;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSString * adddate;
@property (nonatomic, retain) NSString * des;
@property (nonatomic, retain)NSString *action;
@end
