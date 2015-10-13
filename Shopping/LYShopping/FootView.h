//
//  FootView.h
//  LYShopping
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^skipToView)(NSString *productId);

@interface FootView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,copy)skipToView myBlock;

-(void)downloadDataWithUrl:(NSString *)url pid:(NSString *)proid block:(skipToView)block;

@end
