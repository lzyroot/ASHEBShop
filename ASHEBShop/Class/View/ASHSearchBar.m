//
//  ASHSearchBar.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchBar.h"

@implementation ASHSearchBar

- (void)layoutSubviews {
    
    [super layoutSubviews];
    for (UIView *subView in self.subviews[0].subviews) {

        if ([subView isKindOfClass:[UITextField class]]) {
            subView.ash_top = 0;
            subView.ash_height = 30;
            subView.layer.cornerRadius = 0;
            ((UITextField*)subView).borderStyle = UITextBorderStyleNone;
        }
    }
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subView removeFromSuperview];
        }
    }
}

@end
