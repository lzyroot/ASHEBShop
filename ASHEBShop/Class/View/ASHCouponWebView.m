//
//  ASHCouponWebView.m
//  ASHEBShop
//
//  Created by xmfish on 17/5/4.
//  Copyright © 2017年 ash. All rights reserved.
//

#import "ASHCouponWebView.h"
#import <ReactiveCocoa.h>
@interface ASHCouponWebView()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView* webView;
@property(nonatomic, copy)NSString* couponurl;
@property(nonatomic, strong)UIImageView* closeImageView;
@end
@implementation ASHCouponWebView
- (id)initWithUrl:(NSString *)url
{
    self = [super initWithFrame:CGRectMake(0, 0, ASHScreenWidth, ASHScreenHeight)];
    if (self) {
        _couponurl = url;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    
    UIButton* bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    bgBtn.backgroundColor = [UIColor clearColor];
    @weakify(self);
    [[bgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.closeImageView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.webView.transform = CGAffineTransformScale(self.webView.transform, 0.1, 0.1);
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }];
    [self addSubview:bgBtn];
    
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, (ASHScreenWidth - 40), (ASHScreenWidth * 1.2))];
    self.webView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addSubview:self.webView];
    
    
    self.closeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close.png"]];
    self.closeImageView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y - 38, 32, 32);
    self.closeImageView.hidden = YES;
    [self addSubview:self.closeImageView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_couponurl]]];
    self.webView.delegate = self;
    self.webView.transform = CGAffineTransformScale(self.webView.transform, 0.2, 0.2);
    [UIView animateWithDuration:0.3 animations:^{
        self.closeImageView.hidden = NO;
        self.webView.transform = CGAffineTransformScale(self.webView.transform, 5, 5);
    }];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //隐藏按钮
    NSString* jScript = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:@"delete-btn"] encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:jScript];
}
@end
