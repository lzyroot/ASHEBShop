//
//  ASHTopSessionView.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTopSessionView.h"

@implementation ASHTopSessionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addLeftImageView];
    }
    return self;
}
- (void)addLeftImageView
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 105, 20)];
    imageView.ash_centerY = self.ash_height / 2;
    imageView.image = [UIImage imageNamed:@"setting_coupon_price_bg"];
    [imageView ash_addRoundedCorners:UIRectCornerBottomRight | UIRectCornerTopRight withRadii:CGSizeMake(8, 8)];
    [self addSubview:imageView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:imageView.bounds];
    label.text = @"全网最热优惠券";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor whiteColor];
    label.ash_left = 5;
    [imageView addSubview:label];
}
@end
