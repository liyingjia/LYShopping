//
//  BookModel.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BaseModel.h"

@interface BookModel : BaseModel

@property(nonatomic,copy)NSString *des;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *icon1;
@property(nonatomic,copy)NSString *icon2;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *periods;

@end




/*
 des = "\U5c01\U9762\U6545\U4e8b";
 icon = "/upload/day_130621/201306211416194_listthumb_iphone4.jpg";
 icon1 = "/upload/day_130621/201306211416194_header_iphone4.jpg";
 icon2 = "/upload/day_130621/201306211416194_home_iphone4.jpg";
 id = 686;
 periods = "\U589e\U520aB";
 title = "\U589e\U520aB\U5c01\U9762\U6545\U4e8b";
 url = "";
 year = 2015;
 */