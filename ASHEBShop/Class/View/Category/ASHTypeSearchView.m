//
//  ASHTypeSearchView.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTypeSearchView.h"

@implementation ASHTypeSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addButton];
    }
    return self;
}
- (void)addButton
{
    CGFloat width = self.ash_width / 4;
    CGFloat height = self.ash_height;
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, width, height);
    [leftButton setTitle:@"综合" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
    leftButton.selected = YES;
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    UIButton* centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    centerButton.frame = CGRectMake(width, 0, width, height);
    [centerButton setTitle:@"销量" forState:UIControlStateNormal];
    centerButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerButton setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
    centerButton.selected = NO;
    centerButton.tag = 2;
    [centerButton addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:centerButton];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(width*2, 0, width, height);
    [rightButton setTitle:@"优惠率" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
    rightButton.selected = NO;
    rightButton.tag = 3;
    [rightButton addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    
    UIButton* lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.frame = CGRectMake(width*3, 0, width, height);
    [lastButton setTitle:@"价格" forState:UIControlStateNormal];
    lastButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lastButton setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
    lastButton.selected = NO;
    lastButton.tag = 4;
    [lastButton addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastButton];
}
- (void)typeBtnClick:(UIButton*)button
{
    if (button.selected) {
        return;
    }
    UIButton* leftButton = [self viewWithTag:1];
    UIButton* centerButton = [self viewWithTag:2];
    UIButton* rightButton = [self viewWithTag:3];
    UIButton* lastButton = [self viewWithTag:4];
    leftButton.selected = NO;
    centerButton.selected = NO;
    rightButton.selected = NO;
    lastButton.selected = NO;
    button.selected = YES;
    if (self.typeSelectAction) {
        self.typeSelectAction(button.tag - 1);
    }
}
- (void)setIndex:(NSInteger)index
{
    UIButton* leftButton = [self viewWithTag:1];
    UIButton* centerButton = [self viewWithTag:2];
    UIButton* rightButton = [self viewWithTag:3];
    UIButton* lastButton = [self viewWithTag:4];
    leftButton.selected = NO;
    centerButton.selected = NO;
    rightButton.selected = NO;
    lastButton.selected = NO;
    
    UIButton* button = [self viewWithTag:index+1];
    button.selected = YES;
}
@end
