//
//  ASHTabCategoryView.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTabCategoryView.h"
#import "ASHTabManager.h"
#import "ASHCategoryItemView.h"
#import "UIImage+ASHUtil.h"
#define TabCategoryBtnTag 1000
#define TabCategoryViewTag 56782
@interface ASHTabCategoryView()
@end
@implementation ASHTabCategoryView
+ (ASHTabCategoryView*)show
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    ASHTabCategoryView* view = [[ASHTabCategoryView alloc] initWithFrame:CGRectMake(0, 104, ASHScreenWidth, ASHScreenHeight)];
    view.tag = TabCategoryViewTag;
    [window addSubview:view];
    
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ASHScreenWidth, 40)];
    UILabel* titlelabel = [[UILabel alloc] initWithFrame:topView.bounds];
    topView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:titlelabel];
    titlelabel.text = @"全部分类";
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3]];
    lineView.frame = CGRectMake(0, 39.5, ASHScreenWidth, 0.5);
    [topView addSubview:lineView];
    
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = [UIFont systemFontOfSize:12.0];
    
    UIButton* bgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
    [bgButton addTarget:view action:@selector(bgTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgButton setImage:[UIImage imageNamed:@"grayclose.png"] forState:UIControlStateNormal];
    bgButton.ash_centerY = 20;
    bgButton.ash_right = ASHScreenWidth - 15;
    [topView addSubview:bgButton];
    
    [window addSubview:topView];
    
    @weakify(view,topView);
    [view setCloseAction:^{
        [UIView animateWithDuration:0.3 animations:^{
            @strongify(view,topView);
            view.ash_centerY = 64;
            view.layer.transform = CATransform3DMakeScale(1, 0.001, 1);
            view.alpha = 0;
            topView.alpha = 0;
        } completion:^(BOOL finished) {
            @strongify(view,topView);
            [view removeFromSuperview];
            [topView removeFromSuperview];
        }];
        
    }];
    
    view.ash_centerY = 64;
    view.layer.transform = CATransform3DMakeScale(1, 0.001, 1);
    view.alpha = 0;
    topView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        topView.alpha = 1;
        
        view.alpha = 1;
        view.layer.transform = CATransform3DIdentity;
        view.ash_top = 104;
    }];
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (instancetype)initWithCategoryArr:(NSArray<ASHCategoryItemModel> *)categoryArr
{
    self = [super initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 100 * (categoryArr.count/4 + (categoryArr.count%4?1:0)) + 20)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUIWithData:categoryArr];
        
    }
    return self;
}
- (void)setupUIWithData:(NSArray<ASHCategoryItemModel> *)categoryArr{
    
    
    CGFloat offsetX = 20;
    CGFloat width = (self.ash_width) / 4 - offsetX;
    CGFloat height = 100;
    for (int i = 0; i < categoryArr.count; i++) {
        CGFloat x = (i % 4) * (width+offsetX) + 10;
        CGFloat y = (i / 4) * height + 5;
        ASHCategoryItemView* bgView = [[ASHCategoryItemView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView setModel:categoryArr[i]];
        [self addSubview:bgView];
        bgView.tag = TabCategoryBtnTag + i;
        @weakify(self);
        [bgView setTapAction:^(NSInteger index) {
            @strongify(self);
            if (self.categoryIndexAction) {
                self.categoryIndexAction(index - TabCategoryBtnTag);
            }
        }];
    }
}
- (void)setupUI{
    
    NSArray<ASHTabItemModel*>* dataArr = [ASHTabManager shareInstance].model.tab_elementArr;
    CGFloat offsetX = 20;
    CGFloat width = (self.ash_width / 4 ) - offsetX;
    CGFloat height = 95;
    
    UIImageView* blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.ash_width, self.ash_height)];
    blurImageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    [self addSubview:blurImageView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, blurImageView.frame.size.width, blurImageView.frame.size.height);
    [blurImageView addSubview:effectView];
    
    UIButton* bgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.ash_width, self.ash_height)];
    [bgButton addTarget:self action:@selector(bgTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgButton];
    
    UIView* whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ash_width, height * (dataArr.count/4 + (dataArr.count%4?1:0) ) + 5) ];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteBGView];
    for (int i = 0; i < dataArr.count; i++) {
        CGFloat x = (i % 4) * (width+offsetX) + 10;
        CGFloat y = (i / 4) * height;
        ASHCategoryItemView* bgView = [[ASHCategoryItemView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView setModel:dataArr[i]];
        [self addSubview:bgView];
        bgView.tag = TabCategoryBtnTag + i;
        @weakify(self);
        [bgView setTapAction:^(NSInteger index) {
            @strongify(self);
            if (self.categoryIndexAction) {
                self.categoryIndexAction(index - TabCategoryBtnTag);
            }
            if (self.closeAction) {
                self.closeAction();
            }
        }];
    }
}
- (void)bgTapAction:(UIButton*)button
{
    
    if (self.closeAction) {
        self.closeAction();
    }
}

@end
