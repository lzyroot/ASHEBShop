//
//  ASHTagView.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTagView.h"
@interface ASHTagView()
@property (nonatomic, strong) NSMutableArray *buttonArr;
@end
@implementation ASHTagView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray withTextColor:(UIColor*)textColor borderColor:(UIColor*)borderColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.tagHeight = [self creatSubviewsWithWidth:frame.size.width titleArray:titleArray withTextColor:textColor borderColor:borderColor];
    }
    return self;
}

- (CGFloat)creatSubviewsWithWidth:(CGFloat)allWidth titleArray:(NSArray *)titleArray withTextColor:(UIColor*)textColor borderColor:(UIColor*)borderColor{
    CGFloat x = 15;
    CGFloat nowWidth = 0;
    CGFloat nextWidth = 0;
    CGFloat kButtonHeight = 28.0;
    int num_per_line = 0;//每行btn的个数
    int num_of_line = 0;//行数
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //添加到数组内
        [self.buttonArr addObject:button];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:textColor forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font =  [UIFont systemFontOfSize:14];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.layer.borderColor = borderColor.CGColor;
        button.layer.cornerRadius = 14.0;
        button.layer.borderWidth = 0.5;
        button.tag = 100 + i;
        [self addSubview:button];
        
        NSString *title = titleArray[i];
        CGFloat titleWidth = [title widthForFontSize:14];
        titleWidth += (14 * 2);//给按钮标题距离左右边框留点间距
        nextWidth = nextWidth + titleWidth + 10;//将要布局下一个按钮的宽度
        if (nextWidth > allWidth) {
            //如果大于限定的宽度 置0 另起一行
            nextWidth = 0;
            nextWidth = nextWidth + titleWidth;
            num_of_line ++;
            nowWidth = 0;
            nowWidth = nowWidth + titleWidth;
            num_per_line = 0;
            button.frame = CGRectMake(x, 5 + (kButtonHeight + 10) * num_of_line, titleWidth, kButtonHeight);
        }else {
            button.frame = CGRectMake(x + nowWidth + num_per_line * 10, 5 + (kButtonHeight + 10) * num_of_line, titleWidth, kButtonHeight);
            nowWidth = nowWidth + titleWidth;
        }
        num_per_line ++;
    }
    
    return (kButtonHeight + 10) * (num_of_line + 1);
}
- (void)buttonAction:(UIButton*)button
{
    if (self.tagIndexAction) {
        self.tagIndexAction(button.tag - 100);
    }
}
@end
