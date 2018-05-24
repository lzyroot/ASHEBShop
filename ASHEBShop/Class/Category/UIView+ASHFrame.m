//
//  UIView+ASHFrame.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/17.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "UIView+ASHFrame.h"

@implementation UIView (ASHFrame)
- (CGFloat)ash_left {
    return self.frame.origin.x;
}

- (void)setAsh_left:(CGFloat)left {
    CGRect frame = self.frame;
    if (frame.origin.x != left) {
        frame.origin.x = left;
        self.frame = frame;
    }
}

- (CGFloat)ash_top {
    return self.frame.origin.y;
}

- (void)setAsh_top:(CGFloat)top {
    CGRect frame = self.frame;
    if (frame.origin.y != top) {
        frame.origin.y = top;
        self.frame = frame;
    }
}

- (CGFloat)ash_right {
    CGRect frame = self.frame;
    return frame.origin.x + frame.size.width;
}

- (void)setAsh_right:(CGFloat)right {
    CGRect frame = self.frame;
    CGFloat newRight = right - frame.size.width;
    if (frame.origin.x != newRight) {
        frame.origin.x = newRight;
        self.frame = frame;
    }
}

- (CGFloat)ash_bottom {
    CGRect frame = self.frame;
    return frame.origin.y + frame.size.height;
}

- (void)setAsh_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    CGFloat newBottom = bottom - frame.size.height;
    if (frame.origin.y != newBottom) {
        frame.origin.y = newBottom;
        self.frame = frame;
    }
}

- (CGFloat)ash_centerX {
    return self.center.x;
}

- (void)setAsh_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    if (center.x != centerX) {
        center.x = centerX;
        self.center = center;
    }
}

- (CGFloat)ash_centerY {
    return self.center.y;
}

- (void)setAsh_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    if (center.y != centerY) {
        center.y = centerY;
        self.center = center;
    }
}

- (CGFloat)ash_width {
    return self.frame.size.width;
}

- (void)setAsh_width:(CGFloat)width {
    if (isnan(width)) {
        width = 0;
    }
    CGRect frame = self.frame;
    if (frame.size.width != width) {
        frame.size.width = width;
        self.frame = frame;
    }
}

- (CGFloat)ash_height {
    return self.frame.size.height;
}

- (void)setAsh_height:(CGFloat)height {
    if (isnan(height)) {
        height = 0;
    }
    CGRect frame = self.frame;
    if (frame.size.height != height) {
        frame.size.height = height;
        self.frame = frame;
    }
}

- (CGSize)ash_size {
    return self.frame.size;
}

- (void)setAsh_size:(CGSize)size {
    CGRect frame = self.frame;
    if (!CGSizeEqualToSize(frame.size, size)) {
        frame.size = size;
        self.frame = frame;
    }
}

- (CGPoint)ash_origin {
    return self.frame.origin;
}

- (void)setAsh_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    if (!CGPointEqualToPoint(frame.origin, origin)) {
        frame.origin = origin;
        self.frame = frame;
    }
}

- (CGPoint)ash_selfcenter {
    CGRect frame = self.frame;
    return CGPointMake(frame.size.width / 2, frame.size.height / 2);
}
@end
