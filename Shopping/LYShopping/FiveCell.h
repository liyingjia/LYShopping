//
//  FiveCell.h
//  LYShopping
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^skipToView)(NSString *productId);

@interface FiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,copy)skipToView myBlock;

-(void)downloadDataWithUrl:(NSString *)url pid:(NSString *)proid block:(skipToView)block;

@end
