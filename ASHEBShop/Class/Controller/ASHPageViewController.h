//
//  ASHPageViewController.h
//  Pods
//
//  Created by anchor on 2017/4/19.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ASHPageViewController;

@protocol ASHPageViewControllerDelegate <NSObject>

@optional
//// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(ASHPageViewController *)pageViewController willTransitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
//// Sent when a gesture-initiated transition ends.
- (void)pageViewController:(ASHPageViewController *)pageViewController didTransitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end

@protocol ASHPageViewControllerDataSource <NSObject>

@required
- (nullable UIViewController *)pageViewController:(ASHPageViewController *)pageViewController controllerAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfControllersInPageViewController:(ASHPageViewController *)pageViewController;

@optional
- (nullable NSString *)pageViewController:(ASHPageViewController *)pageViewController titleAtIndex:(NSUInteger)index;

@end

@interface ASHPageViewController : UIViewController <UIScrollViewDelegate, ASHPageViewControllerDataSource>

@property (strong, nonatomic, readonly) UIScrollView *scrollView;

@property (weak, nonatomic) id<UIScrollViewDelegate> scrollViewForwardDelegate;
@property (weak, nonatomic) id<ASHPageViewControllerDelegate> delegate;
@property (weak, nonatomic) id<ASHPageViewControllerDataSource> dataSource;
@property (copy, nonatomic, readonly) NSArray<__kindof UIViewController *> *viewControllers;
@property (assign, nonatomic, readonly) NSUInteger totalPageCount;
@property (assign, nonatomic, readonly) NSUInteger currentPageIndex; // 滑动滚动前的那个页面，在滚动结束后才会修改该值
@property (nonatomic, assign) NSUInteger cachePageCount;             // 默认为0，不使用缓存

- (void)setViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)registerClass:(nullable Class)pageClass forPageReuseIdentifier:(NSString *)identifier;
- (__kindof UIViewController *)dequeueReusablePageWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index;

- (NSArray *)visibleViewControllers;

- (void)removeCache;

@end

@interface ASHPageViewController (TransitionOverride)

// subclass override
- (void)transitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
