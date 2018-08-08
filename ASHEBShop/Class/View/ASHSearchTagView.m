//
//  ASHSearchTagView.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchTagView.h"
@interface ASHSearchTagView()
@property (nonatomic, strong) NSMutableArray *buttonArr;

@end
@implementation ASHSearchTagView
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubviewsWithHeight:frame.size.height titleArray:titleArray];
    }
    return self;
}

- (void)creatSubviewsWithHeight:(CGFloat)allHeight titleArray:(NSArray *)titleArray{
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, allHeight)];
    [self addSubview:scrollView];
    CGFloat nextWidth = 10;
    CGFloat kButtonHeight = 28.0;
    
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //添加到数组内
        [self.buttonArr addObject:button];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font =  [UIFont systemFontOfSize:14];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor lineColor].CGColor;
        button.layer.cornerRadius = 14.0;
        button.layer.borderWidth = 0.5;
        button.tag = 100 + i;
        [scrollView addSubview:button];
        
        NSString *title = titleArray[i];
        CGFloat titleWidth = [title widthForFontSize:14];
        titleWidth += (14 * 2);//给按钮标题距离左右边框留点间距
 
        
        button.frame = CGRectMake(nextWidth, 8, titleWidth, kButtonHeight);
        
        nextWidth = nextWidth + titleWidth + 10;//将要布局下一个按钮的宽度
    }
    
    scrollView.contentSize = CGSizeMake(nextWidth, allHeight);
    scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
}


- (void)buttonAction:(UIButton*)button
{
    if (self.tagIndexAction) {
        self.tagIndexAction(button.tag - 100);
    }
}
@end
