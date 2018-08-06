//
//  ASHSearchButton.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchButton.h"

@interface ASHSearchButton()
@property(nonatomic, strong)UIButton* button;
@end
@implementation ASHSearchButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [_button setTitle:@"输入商品名或粘贴淘宝标题" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_button setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        _button.titleLabel.textColor = [UIColor whiteColor];
        _button.frame = self.bounds;
        [_button addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    

    
}
- (void)searchBtnClick:(UIButton*)button
{
    if (self.searchAction) {
        self.searchAction(button);
    }
}
@end
