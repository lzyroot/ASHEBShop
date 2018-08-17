//
//  ASHLoadView.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/16.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHLoadView.h"
@interface ASHLoadView()
@property (strong, nonatomic)UIImageView* loadingView;
@end

@implementation ASHLoadView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 75, 12)];
    if (self) {
        _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 12)];
        [self addSubview:_loadingView];
        NSMutableArray* arr = [NSMutableArray array];
        for (int i = 0; i<21; i++) {
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i+1]];
            [arr addObject:image];
        }
        _loadingView.animationImages = arr;
        _loadingView.animationDuration = 1;
        _loadingView.animationRepeatCount = 0;

    }
    return self;
}
- (void)show{
    self.hidden = NO;
    [_loadingView startAnimating];
}
- (void)hide{
    self.hidden = YES;
    [_loadingView stopAnimating];
}
@end
