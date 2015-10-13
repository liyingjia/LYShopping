//
//  ADView.h
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SkipToView)(NSString *url);

@interface ADView : UIView<UIScrollViewDelegate>

@property(nonatomic,copy)SkipToView myBlock;

-(id)initWithFrame:(CGRect)frame block:(SkipToView)block;

-(void)downloadDataWithUrl:(NSString *)url;

//-(void)downloadWithUrl:(NSString *)url;

-(void)createHttpRequest;

@end
