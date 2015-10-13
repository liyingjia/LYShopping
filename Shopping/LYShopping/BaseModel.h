//
//  BaseModel.h
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
