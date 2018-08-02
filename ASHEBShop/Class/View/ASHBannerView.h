//
//  ASHBannerView.h
//
//  Created by wsh on 15/5/20.
//  Copyright (c) 2015年 xmfish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ASHBannerPageControlAt) {
    ASHBannerPageControlAtCenter,
    ASHBannerPageControlAtLeft,
    ASHBannerPageControlAtRight,
};

@interface ASHBannerView : UIView

/**
*  @brief   支持 UIImage 和 (URL or String)  或者 自定义model  不过需要你实现 onItemViewCreating
            onItemViewCreating方法优先级最高 如果有返回view 则用该view来显示
*/
@property (strong, nonatomic) NSArray* images; /**< 数据源  其实现在不应该叫images的,但是为了兼容之前代码,就不改名字了。*/
@property (strong, nonatomic) NSArray* titles; /**< 每张图片对应的标题 */
@property (assign, nonatomic) NSInteger currentIndex; /**< 当前位置*/
@property (readonly, nonatomic) UIView* currentShowView; /**< 当前显示的view*/

@property (copy, nonatomic) UIView* (^onItemViewCreating)(UIView* reusableView, NSInteger index, id data); /**< 自己创建view 优先级最高*/
@property (copy, nonatomic) void (^onDidItemViewCreated)(UIView* itemView, NSInteger index); /**< 当view添加完毕后的回调*/
@property (copy, nonatomic) void (^onDidClickEvent)(NSInteger index); /**< 点击事件*/
@property (copy, nonatomic) void (^onDidScrollToIndex)(NSInteger index); /**< 滚动事件*/

@property (strong, readonly, nonatomic) UIScrollView* scrollView;
@property (strong, readonly, nonatomic) UIPageControl* pageControl;

@property (assign, nonatomic) ASHBannerPageControlAt position;

@end
