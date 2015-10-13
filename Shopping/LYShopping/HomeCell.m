//
//  HomeCell.m
//  LYShopping
//
//  Created by qianfeng on 15/9/24.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "HomeCell.h"
#import "UIImageView+WebCache.h"

@implementation HomeCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDateWithModel:(MainModel *)model
{
    self.titleLabel.text = model.adShow;
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:model.appImgUrl] placeholderImage:[UIImage imageNamed: @"homebg"]];
    self.disCountLabel.text = model.saleText;
    [self.disCountLabel sizeToFit];
    
//    NSNumber *start = model.upTime;
//    NSString *startTime = [LZXHelper dateStringFromNumberTimer:[start stringValue]];
    NSNumber *end = model.endTime;
    NSString *endTime = [LZXHelper dateStringFromNumberTimer:[end stringValue]];
//    NSString *time = [self intervalSinceNow:startTime laterDate:endTime];
    NSString *time = [self intervalSinceNow:endTime];
    [self.dateLabel setTitle:time forState:UIControlStateNormal];
}

#pragma mark - 计算时间差
- (NSString *)intervalSinceNow:(NSString *)PreviousDate
{
    //把时间字符串 转化为 时间戳
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *previous=[date dateFromString:PreviousDate];
    NSTimeInterval early=[previous timeIntervalSince1970]*1;
    
    //获取当前事件
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
//    NSDate *later=[date dateFromString:laterDate];
//    NSTimeInterval now=[later timeIntervalSince1970]*1;
//    NSString *timeString=@"";
    
    NSTimeInterval cha=early-now;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        NSInteger timeString1 = [[timeString substringToIndex:timeString.length-6] integerValue];
        NSInteger timeString2 = [[timeString substringToIndex:timeString.length-7] integerValue];
        if (timeString1 - timeString2>=0) {
            timeString = [NSString stringWithFormat:@"剩%ld分钟",timeString2+1];
        }
        timeString=[NSString stringWithFormat:@"剩%ld分钟", timeString2+1];
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        NSInteger timeString1 = [[timeString substringToIndex:timeString.length-6] integerValue];
        NSInteger timeString2 = [[timeString substringToIndex:timeString.length-7] integerValue];
        if (timeString1 - timeString2>=0) {
            timeString = [NSString stringWithFormat:@"剩%ld小时",timeString2+1];
        }
        timeString=[NSString stringWithFormat:@"剩%ld小时", timeString2+1];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        NSInteger timeString1 = [[timeString substringToIndex:timeString.length-6] integerValue];
        NSInteger timeString2 = [[timeString substringToIndex:timeString.length-7] integerValue];
        if (timeString1 - timeString2>=0) {
            timeString = [NSString stringWithFormat:@"剩%ld天",timeString2+1];
        }
        timeString=[NSString stringWithFormat:@"剩%ld天", timeString2+1];
    }
    return timeString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
