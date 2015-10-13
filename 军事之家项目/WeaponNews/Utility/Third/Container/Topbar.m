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
    CGFloat padding = 20;
    // CGSize contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGFloat originX = 0;
    for (int i = 0; i < titles.count; i++) {
        if ([_titles[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        // buttons
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // set button frame      button.intrinsicContentSize.width
        
        CGRect frame = CGRectMake(originX+padding , 0, button.intrinsicContentSize.width, kTopbarHeight);
        button.frame = frame;
        originX = CGRectGetMaxX(frame)+padding; //originX + padding + button.intrinsicContentSize.width;
        
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
//    self.contentSize = CGSizeMake(CGRectGetMaxX([self.buttons.lastObject frame]) + padding, self.frame.size.height);
    
    // mark view
    UIButton *firstButton = self.buttons.firstObject;
    CGRect frame = firstButton.frame;
    self.markView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, CGRectGetMaxY(frame)-3, frame.size.width, 3)];
    _markView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_markView];
    self.button = firstButton;
    [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}


- (void)buttonClick:(UIButton *)sender {
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        self.markView.frame = CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame)-3, button.frame.size.width, 3);
    } completion:^(BOOL finished) {
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button = button;
        [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
}

@end
