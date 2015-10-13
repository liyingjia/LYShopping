//
//  Topbar.m
//  ContainerDemo
//
//  Created by qianfeng on 15/3/3.
//  Copyright (c) 2015年 WeiZhenLiu. All rights reserved.
//

#import "Topbar.h"

@interface Topbar ()

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *button;
@end

@implementation Topbar


- (void)setTitles:(NSMutableArray *)titles {
    self.showsHorizontalScrollIndicator = NO;
    _titles = titles;
    self.buttons = [NSMutableArray array];
//    CGFloat Width = ScreenWidth/titles.count;
    CGFloat padding = ScreenWidth/4;
    // CGSize contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
//    CGFloat originX = 0;
    NSArray *images = @[@"",@"",@"arrow_up",@"arrow_down"];
    for (int i = 0; i < titles.count; i++) {
        if ([_titles[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        // buttons
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 101 + i;
        [button setImage:[[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"default_btn"]]];
        
        button.frame = CGRectMake(i*padding , 0, padding, kTopbarHeight);
        
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
    // mark view
    UIButton *firstButton = self.buttons.firstObject;
    CGRect frame = firstButton.frame;
    self.markView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/4+frame.origin.x-2, CGRectGetMaxY(frame)-3, frame.size.width/2, 1.5)];
    _markView.backgroundColor = [UIColor redColor];
    [self addSubview:_markView];
    self.button = firstButton;
    [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (void)buttonClick:(UIButton *)sender {
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button = sender;
    [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.currentPage = [self.buttons indexOfObject:sender];
    if (_blockHandler) {
        _blockHandler(_currentPage);
    }
}

// overwrite setter of property: selectedIndex
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    UIButton *button = [_buttons objectAtIndex:_currentPage];
    CGRect frame = button.frame;
    frame.origin.x -= 5;
    frame.size.width += 10;
    [self scrollRectToVisible:frame animated:YES];
    [UIView animateWithDuration:0.25f animations:^{
        self.markView.frame = CGRectMake(frame.size.width/4+button.frame.origin.x-2, CGRectGetMaxY(button.frame)-3, button.frame.size.width/2, 1.5);
    } completion:^(BOOL finished) {
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.button = button;
        [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
}

@end
