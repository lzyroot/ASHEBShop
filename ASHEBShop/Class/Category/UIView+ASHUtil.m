//
//  UIView+ASHUtil.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "UIView+ASHUtil.h"

@implementation UIView (ASHUtil)

- (void)ash_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)ash_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}
+ (void)showToast:(NSString *)title
{
    UIWindow* view = (UIWindow*)[UIApplication sharedApplication].windows[0];
    MBProgressHUD* progressHUD = [[MBProgressHUD alloc] initWithFrame:view.bounds];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.center = view.center;
    progressHUD.label.text = title;
    [view addSubview:progressHUD];
    [progressHUD showAnimated:NO];
    [progressHUD hideAnimated:YES afterDelay:2.0];
}
@end
