//
//  ASHPageViewController.m
//  Pods
//
//  Created by anchor on 2017/4/19.
//
//

#import "ASHPageViewController.h"
#import "UIViewController+ASHChildController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

CGFloat const kAnimationDurationTime = 0.3f;
NSUInteger const kMaxCacheCount = 100;


typedef NS_ENUM(NSInteger, ASHPageScrollDirection) {
    ASHPageScrollDirectionNone = 0,
    ASHPageScrollDirectionLeft = -1,
    ASHPageScrollDirectionRight = 1
};

@interface ASHPageViewController () <NSCacheDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) CGFloat originOffsetX; //用于手势拖动scrollView时，判断方向,x方向
@property (assign, nonatomic) NSUInteger currentPageIndex;
@property (assign, nonatomic) NSUInteger guessToIndex;      //用于手势拖动scrollView时，判断要去的页面
@property (assign, nonatomic) NSUInteger lastSelectedIndex; //用于记录上次选择的index
@property (assign, nonatomic) NSUInteger totalPageCount;

@property (assign, nonatomic) BOOL firstWillAppear;        //用于界定页面首次WillAppear
@property (assign, nonatomic) BOOL firstDidAppear;         //用于界定页面首次DidAppear
@property (assign, nonatomic) BOOL firstDidLayoutSubViews; //用于界定页面首次DidLayoutsubviews
@property (assign, nonatomic) BOOL isDecelerating;         //正在减速操作

// 缓存字段
// childVC被三个地方持有：cache、dic、self.childViewController，特别地，当前childvc还会被外部持有
@property (assign, nonatomic) BOOL isCleaningCache;
@property (strong, nonatomic) NSCache<NSNumber *, UIViewController *> *pagesCache;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, UIViewController *> *cachedPagesDic;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, UIViewController *> *cleaningPagesDic;

// 重用字段
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *pageClassByIdentifier;         // 获取identifier对应的pageClass
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray *> *reusablePagesByIdentifier; // 获取identifier相同的page实例数组

@end

@implementation ASHPageViewController

#pragma mark - lifecycle

- (void)dealloc {
    [_pagesCache removeAllObjects];
    [_cachedPagesDic removeAllObjects];
    [_reusablePagesByIdentifier removeAllObjects];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    @weakify(self);
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        if (self.isViewLoaded && self.view.window && self.cachedPagesDic.count > 0 && self.pagesCache) {
            [self.cachedPagesDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *_Nonnull key, UIViewController *_Nonnull obj, BOOL *_Nonnull stop) {
                @strongify(self);
                [self.pagesCache setObject:obj forKey:key];
            }];
        }
    }];
}

- (void)initialData {
    self.cachePageCount = 0;
    self.originOffsetX = 0.f;
    self.currentPageIndex = 0;
    self.lastSelectedIndex = 0;
    self.guessToIndex = NSUIntegerMax;
    self.firstWillAppear = YES;
    self.firstDidAppear = YES;
    self.firstDidLayoutSubViews = YES;
    self.isDecelerating = NO;
}

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).with.offset(0);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(0);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.firstWillAppear) {
        [self.view layoutIfNeeded];
        if ([self.delegate respondsToSelector:@selector(pageViewController:willTransitionFromIndex:toIndex:)]) {
            [self.delegate pageViewController:self willTransitionFromIndex:self.lastSelectedIndex toIndex:self.currentPageIndex];
        }
        self.firstWillAppear = NO;
    }
    // 最开始进来
    UIViewController *vc = [self createChildViewControllersAtIndex:self.currentPageIndex direction:ASHPageScrollDirectionNone];
    [vc beginAppearanceTransition:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.firstDidAppear) {

        if ([self respondsToSelector:@selector(transitionFromIndex:toIndex:animated:)]) {
            [self transitionFromIndex:self.lastSelectedIndex toIndex:self.currentPageIndex animated:NO];
        }

        if ([self.delegate respondsToSelector:@selector(pageViewController:didTransitionFromIndex:toIndex:)]) {
            [self.delegate pageViewController:self didTransitionFromIndex:self.lastSelectedIndex toIndex:self.currentPageIndex];
        }
        self.firstDidAppear = NO;
    }
    UIViewController *vc = [self controllerAtIndex:self.currentPageIndex];
    [vc endAppearanceTransition];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.firstDidLayoutSubViews) {
        //Solve scrollView bug: can scroll to negative offset when pushing a UIViewController containing a UIScrollView using a UINavigationController.
        if (self.navigationController && self.navigationController.viewControllers.lastObject == self) {
            self.scrollView.contentOffset = CGPointZero;
            self.scrollView.contentInset = UIEdgeInsetsZero;
        }
        [self updateScrollViewContentSizeAfterVCLayout];
        if (CGRectGetWidth(self.scrollView.frame) > 0.0) {
            // 这里会出现vc为nil的情况，原因未知
            //  https://bugly.qq.com/v2/crash-reporting/crashes/d1a1d40a09/57799/report?pid=2
            // crash时候的currentvc：SYAccountVC2_0
            UIViewController *vc = [self controllerAtIndex:self.currentPageIndex];
            CGRect childViewFrame = [self calculateVisibleViewControllerFrameWithIndex:self.currentPageIndex];
            [self ash_addChildViewController:vc inView:self.scrollView withFrame:childViewFrame];

            CGPoint newOffset = [self calculateOffsetWithIndex:self.currentPageIndex width:CGRectGetWidth(self.scrollView.frame) maxWidth:self.scrollView.contentSize.width];
            if (newOffset.x != self.scrollView.contentOffset.x || newOffset.y != self.scrollView.contentOffset.y) {
                self.scrollView.contentOffset = newOffset;
            }
        }
        self.firstDidLayoutSubViews = NO;
    } else {
        [self updateScrollViewContentSizeAfterVCLayout];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIViewController *vc = [self controllerAtIndex:self.currentPageIndex];
    [vc beginAppearanceTransition:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UIViewController *vc = [self controllerAtIndex:self.currentPageIndex];
    [self recyclePage:vc atIndex:self.currentPageIndex];
    [vc endAppearanceTransition];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO; // return YES将会把生命周期自动传递给childControllers，NO将不会自动传递生命周期
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_pagesCache removeAllObjects];
    [_cachedPagesDic removeAllObjects];
    [_reusablePagesByIdentifier removeAllObjects];
}

#pragma mark - pre create childPageVC

// 只有在某个页面显示的时候（选中某个页面，滚动到某个页面，第一次进入），会调用这个方法
// 调用这个方法的时候，会先先后把预加载页面、当前页面加入缓存，然后在下个runloop中，将预加载页面加入到scrollview中
- (UIViewController *)createChildViewControllersAtIndex:(NSUInteger)index direction:(ASHPageScrollDirection)direction {
    if (index >= self.totalPageCount || index == NSUIntegerMax) {
        return nil;
    }
    UIViewController *preVC = nil;
    UIViewController *nextVC = nil;
    NSUInteger preIndex = NSUIntegerMax;
    NSUInteger nextIndex = NSUIntegerMax;
    if (direction == ASHPageScrollDirectionNone) { // 预加载两个方向
        preIndex = index - 1;
        nextIndex = index + 1;
    } else {
        nextIndex = ((index + direction) == NSUIntegerMax) ? 0 : (index + direction);
    }
    if (preIndex != NSUIntegerMax) {
        preVC = [self.cachedPagesDic objectForKey:@(preIndex)];
        if (!preVC) {
            preVC = [self.dataSource pageViewController:self controllerAtIndex:preIndex];
            [self cacheChildVC:preVC atIndex:preIndex];
        }
    }
    if (nextIndex < self.totalPageCount) {
        nextVC = [self.cachedPagesDic objectForKey:@(nextIndex)];
        if (!nextVC) {
            nextVC = [self.dataSource pageViewController:self controllerAtIndex:nextIndex];
            [self cacheChildVC:nextVC atIndex:nextIndex];
        }
    }
    UIViewController *currentVC = [self.cachedPagesDic objectForKey:@(index)];
    if (!currentVC) {
        currentVC = [self.dataSource pageViewController:self controllerAtIndex:index];
    }
    [self cacheChildVC:currentVC atIndex:index];

    if (![self.childViewControllers containsObject:currentVC]) {
        CGRect childViewFrame = [self calculateVisibleViewControllerFrameWithIndex:index];
        [self ash_addChildViewController:currentVC inView:self.scrollView withFrame:childViewFrame];
    }

    // 在下一个runloop加入scrollview
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        if (preVC && ![self.childViewControllers containsObject:preVC]) {
            CGRect childViewFrame = [self calculateVisibleViewControllerFrameWithIndex:preIndex];
            [self ash_addChildViewController:preVC inView:self.scrollView withFrame:childViewFrame];
        }
        if (nextVC && ![self.childViewControllers containsObject:nextVC]) {
            CGRect childViewFrame = [self calculateVisibleViewControllerFrameWithIndex:nextIndex];
            [self ash_addChildViewController:nextVC inView:self.scrollView withFrame:childViewFrame];
        }
    });

    

    return currentVC;
}

- (void)cacheChildVC:(UIViewController *)childVC atIndex:(NSUInteger)index {
    // 这边的代码顺序不能变
    [self.pagesCache setObject:childVC forKey:@(index)];
    [self.cachedPagesDic setObject:childVC forKey:@(index)];
}

#pragma mark - page reuse

- (void)registerClass:(nullable Class)pageClass forPageReuseIdentifier:(NSString *)identifier {
    if (!self.pageClassByIdentifier) {
        self.pageClassByIdentifier = [NSMutableDictionary dictionary];
        self.reusablePagesByIdentifier = [NSMutableDictionary dictionary];
    }
    if ([pageClass isSubclassOfClass:[UIViewController class]] && identifier.length > 0) {
        self.pageClassByIdentifier[identifier] = pageClass;
    }
}

/**
 分配page，从重用池中或者创建新的

 @param identifier 重用标识
 @param index page index
 @return page 实例
 */
- (__kindof UIViewController *)dequeueReusablePageWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index {
    if (index != NSUIntegerMax && identifier.length > 0) {
        // 这里返回vc之前，要先调用vc的prepareForReuse
        UIViewController *vc = nil;
        if (!self.pageClassByIdentifier[identifier]) {
            // 未注册的identifier
            NSAssert(0, @"the identifier : %@ didn't register", identifier);
        }
        NSArray *reusablePages = self.reusablePagesByIdentifier[identifier];
        if (reusablePages.count > 0) {
            vc = reusablePages.firstObject;
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:reusablePages];
            [tmpArray removeObject:vc];
            self.reusablePagesByIdentifier[identifier] = [tmpArray copy];
            vc.ash_pageIdentifier = identifier;
            return vc;
        } else {
            Class pageClass = self.pageClassByIdentifier[identifier];
            vc = [[pageClass alloc] init];
            vc.ash_pageIdentifier = identifier;
            return vc;
        }
    }
    return nil;
}


/**
 回收page

 @param page 回收的page
 @param index page所在index
 */
- (void)recyclePage:(UIViewController *)page atIndex:(NSUInteger)index {
    //    if (index != NSUIntegerMax && page) {
    //        // 一个是回收池，一个是缓存
    //        // 回收池是可以拿出来重用，缓存是下次直接拿出来用
    //        // 因为有一个滚屏的效果，所以
    //        if (page.ash_pageIdentifier.length > 0) {
    //            // 加入重用池
    //            NSArray *reusablePages = self.reusablePagesByIdentifier[page.ash_pageIdentifier];
    //            if (reusablePages.count > 0) {
    //                NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:reusablePages];
    //                [tmpArray addObject:page];
    //                self.reusablePagesByIdentifier[page.ash_pageIdentifier] = [tmpArray copy];
    //            } else {
    //                self.reusablePagesByIdentifier[page.ash_pageIdentifier] = @[page];
    //            }
    //            // 移除显示和使用标志
    //            [self.pagesCache removeObjectForKey:@(index)];
    //            [self.cachedPagesDic removeObjectForKey:@(index)];
    //            [page ash_removeFromParentViewController];
    //            page.ash_pageIdentifier = @"";
    //        }
    //    }
}

#pragma mark - public

- (NSArray *)visibleViewControllers {
    return [self.cachedPagesDic allValues];
}

- (void)removeCache {
    [_pagesCache removeAllObjects];
    [_cachedPagesDic removeAllObjects];
    [_reusablePagesByIdentifier removeAllObjects];
}

#pragma mark - set view controller

- (void)setViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index >= self.totalPageCount ||
        index == self.currentPageIndex) {
        return;
    }
    // Synchronize the indexs and store old select index
    NSUInteger oldLastSelectedIndex = self.lastSelectedIndex;
    self.lastSelectedIndex = self.currentPageIndex;
    self.currentPageIndex = index;
    // Prepare to scroll if scrollView is initialized and displayed correctly
    if (self.viewLoaded) {
        if (CGRectGetWidth(self.scrollView.frame) > 0.0 && self.scrollView.contentSize.width > 0.0) {

            if ([self.delegate respondsToSelector:@selector(pageViewController:willTransitionFromIndex:toIndex:)]) {
                [self.delegate pageViewController:self willTransitionFromIndex:self.lastSelectedIndex toIndex:self.currentPageIndex];
            }
            UIViewController *vc = [self createChildViewControllersAtIndex:index direction:ASHPageScrollDirectionNone];
            // 动画效果，为什么要保存上一个的上一个索引
            [self nonInterativeWillScrollWithAnimation:animated];
            if (animated) {
                [self showPageAnimationWithOldLastSelectedIndex:oldLastSelectedIndex];
            } else {
                [self setScrollViewContentOffset];
                [self nonInterativeDidScrollWithAnimation:NO];
            }
        }
    }
}

- (void)nonInterativeWillScrollWithAnimation:(BOOL)animated {
    if (self.currentPageIndex != self.lastSelectedIndex) {
        [[self controllerAtIndex:self.lastSelectedIndex] beginAppearanceTransition:NO animated:animated];
    }
    [[self controllerAtIndex:self.currentPageIndex] beginAppearanceTransition:YES animated:animated];
}

- (void)nonInterativeDidScrollWithAnimation:(BOOL)animated {
    if (self.currentPageIndex != self.lastSelectedIndex) {
        UIViewController *vc = [self controllerAtIndex:self.lastSelectedIndex];
        [self recyclePage:vc atIndex:self.lastSelectedIndex];
        [vc endAppearanceTransition];
    }
    [[self controllerAtIndex:self.currentPageIndex] endAppearanceTransition];

    if ([self respondsToSelector:@selector(transitionFromIndex:toIndex:animated:)]) {
        [self transitionFromIndex:self.lastSelectedIndex toIndex:self.currentPageIndex animated:YES];
    }

    if ([self.delegate respondsToSelector:@selector(pageViewController:didTransitionFromIndex:toIndex:)]) {
        [self.delegate pageViewController:self didTransitionFromIndex:self.lastSelectedIndex toIndex:self.currentPageIndex];
    }
    [self cleanCacheToClean];
}

- (void)showPageAnimationWithOldLastSelectedIndex:(NSUInteger)oldLastSelectedIndex {
    if (self.lastSelectedIndex != self.currentPageIndex) {

        CGSize pageSize = self.scrollView.frame.size;
        ASHPageScrollDirection direction = (self.lastSelectedIndex < self.currentPageIndex) ? ASHPageScrollDirectionRight : ASHPageScrollDirectionLeft;

        UIView *lastView = [self controllerAtIndex:self.lastSelectedIndex].view;
        UIView *currentView = [self controllerAtIndex:self.currentPageIndex].view;
        UIView *oldSelectView = [self controllerAtIndex:oldLastSelectedIndex].view;

        NSUInteger backgroundIndex = [self calculateIndexWithOffset:self.scrollView.contentOffset.x width:CGRectGetWidth(self.scrollView.frame)];
        UIView *backgroundView = nil;

        /*
             *  To solve the problem: when multiple animations were fired, there is an extra unuseful view appeared under the scrollview's two subviews(used to simulate animation: lastView, currentView).
             *
             *  Hide the extra view, and after the animation is finished set its hidden property false.
             */
        if (oldSelectView.layer.animationKeys.count > 0 && lastView.layer.animationKeys.count > 0) {
            UIView *tmpView = [self controllerAtIndex:backgroundIndex].view;
            if (tmpView && tmpView != currentView && tmpView != lastView) {
                backgroundView = tmpView;
                backgroundView.hidden = YES;
            }
        }

        // Cancel animations is not completed when multiple animations are fired
        [self.scrollView.layer removeAllAnimations];
        [oldSelectView.layer removeAllAnimations];
        [lastView.layer removeAllAnimations];
        [currentView.layer removeAllAnimations];

        // oldSelectView is not useful for simulating animation, move it to origin position.
        [self moveBackToOriginPositionIfNeeded:oldSelectView index:oldLastSelectedIndex];

        // Bring the views for simulating scroll animation to front and make them visible
        [self.scrollView bringSubviewToFront:lastView];
        [self.scrollView bringSubviewToFront:currentView];
        lastView.hidden = NO;
        currentView.hidden = NO;

        // Calculate start positions , animate to positions , end positions for simulating animation views(lastView, currentView)
        CGPoint lastViewStartOrigin = lastView.frame.origin;
        CGPoint currentViewStartOrigin = lastView.frame.origin;
        CGPoint lastViewAnimateToOrigin = lastView.frame.origin;
        if (direction == ASHPageScrollDirectionRight) {
            currentViewStartOrigin.x += CGRectGetWidth(self.scrollView.frame);
            lastViewAnimateToOrigin.x -= CGRectGetWidth(self.scrollView.frame);
        } else {
            currentViewStartOrigin.x -= CGRectGetWidth(self.scrollView.frame);
            lastViewAnimateToOrigin.x += CGRectGetWidth(self.scrollView.frame);
        }

        CGPoint currentViewAnimateToOrigin = lastView.frame.origin;
        CGPoint lastViewEndOrigin = lastView.frame.origin;
        CGPoint currentViewEndOrigin = currentView.frame.origin;

        /*
             *  Simulate scroll animation
             *  Bring two views(lastView, currentView) to front and simulate scroll in neighbouring position.
             */
        lastView.frame = CGRectMake(lastViewStartOrigin.x, lastViewStartOrigin.y, pageSize.width, pageSize.height);
        currentView.frame = CGRectMake(currentViewStartOrigin.x, currentViewStartOrigin.y, pageSize.width, pageSize.height);

        [UIView animateWithDuration:kAnimationDurationTime
            delay:0.f
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^{
                lastView.frame = CGRectMake(lastViewAnimateToOrigin.x, lastViewAnimateToOrigin.y, pageSize.width, pageSize.height);
                currentView.frame = CGRectMake(currentViewAnimateToOrigin.x, currentViewAnimateToOrigin.y, pageSize.width, pageSize.height);
            }
            completion:^(BOOL finished) {
                __weak typeof(self) weakSelf = self;
                if (finished) {
                    lastView.frame = CGRectMake(lastViewEndOrigin.x, lastViewEndOrigin.y, pageSize.width, pageSize.height);
                    currentView.frame = CGRectMake(currentViewEndOrigin.x, currentViewEndOrigin.y, pageSize.width, pageSize.height);
                    backgroundView.hidden = NO;
                    if (weakSelf) {
                        [weakSelf moveBackToOriginPositionIfNeeded:currentView index:weakSelf.currentPageIndex];
                        [weakSelf moveBackToOriginPositionIfNeeded:lastView index:weakSelf.lastSelectedIndex];
                        [weakSelf setScrollViewContentOffset];
                        [weakSelf nonInterativeDidScrollWithAnimation:YES];
                    }
                }
            }];
    } else {
        // Scroll without animation if current page is the same with last page
        [self setScrollViewContentOffset];
        [self nonInterativeDidScrollWithAnimation:YES];
    }
}

- (void)moveBackToOriginPositionIfNeeded:(UIView *)view index:(NSUInteger)index {
    if (index >= self.totalPageCount || !view) {
        return;
    }

    CGPoint originPosition = [self calculateOffsetWithIndex:index width:self.scrollView.frame.size.width maxWidth:self.scrollView.contentSize.width];
    if (view.frame.origin.x != originPosition.x) {
        CGRect newFrame = view.frame;
        newFrame.origin = originPosition;
        view.frame = newFrame;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging && scrollView == self.scrollView) {
        CGFloat offset = scrollView.contentOffset.x;
        CGFloat width = CGRectGetWidth(scrollView.frame);
        if (width == 0) {
            if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
                [self.scrollViewForwardDelegate scrollViewDidScroll:scrollView];
            }
            return;
        }

        NSUInteger lastGuessIndex = self.guessToIndex == NSUIntegerMax ? self.currentPageIndex : self.guessToIndex;
        ASHPageScrollDirection direction = ASHPageScrollDirectionNone;
        if (offset < 0) {
            self.guessToIndex = 0;
        } else {
            if (self.originOffsetX < offset) { // turn to right
                self.guessToIndex = (NSUInteger)(ceilf(offset / width));
                direction = ASHPageScrollDirectionRight;
            } else if (self.originOffsetX >= offset) { // turn to left
                direction = ASHPageScrollDirectionLeft;
                self.guessToIndex = (NSUInteger)(floorf(offset / width));
            }
        }


        if (self.guessToIndex >= self.totalPageCount) {
            return;
        }

        if ((!self.scrollView.isDecelerating && self.guessToIndex != self.currentPageIndex) || // 加速滑动时，并且取得页面不等于当前页面
            self.scrollView.isDecelerating) {                                                  // 减速
            if (lastGuessIndex != self.guessToIndex) {

                if ([self.delegate respondsToSelector:@selector(pageViewController:willTransitionFromIndex:toIndex:)]) {
                    [self.delegate pageViewController:self willTransitionFromIndex:self.currentPageIndex toIndex:self.guessToIndex];
                }
                // 加入过度页面
                /**
                 *  Solve problem: When scroll with interaction, scroll page from one direction to the other for more than one time, the beginAppearanceTransition() method will invoke more than once but only one time endAppearanceTransition() invoked, so that the life cycle methods not correct.
                 *  When lastGuessIndex = self.currentPageIndex is the first time which need to invoke beginAppearanceTransition().
                 当滑动scroll view，beginAppearanceTransition()将被多次调用，但是endAppearanceTransition()只被调用一次，声明周期出错
                 */
                UIViewController *disappearVC = nil;
                if (lastGuessIndex == self.currentPageIndex) { // 每次滚动开始，都先调用这个，因为这个时候guessIndex=currentIndex
                    [[self controllerAtIndex:self.currentPageIndex] beginAppearanceTransition:NO animated:YES];
                } else if (lastGuessIndex < self.totalPageCount) {
                    disappearVC = [self controllerAtIndex:lastGuessIndex];
                    [disappearVC beginAppearanceTransition:NO animated:YES];
                }
                UIViewController *appearVC = [self createChildViewControllersAtIndex:self.guessToIndex direction:direction];
                [appearVC beginAppearanceTransition:YES animated:YES];
                [disappearVC endAppearanceTransition];
                [appearVC endAppearanceTransition];
                [self recyclePage:disappearVC atIndex:lastGuessIndex];
            }
        }
    }

    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewForwardDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        self.isDecelerating = YES;
    }
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollViewForwardDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self updatePageViewAfterTragging:scrollView];
        self.isDecelerating = NO;
    }
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewForwardDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView && !scrollView.isDecelerating) {
        self.originOffsetX = scrollView.contentOffset.x;
        self.guessToIndex = self.currentPageIndex;
    }
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollViewForwardDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.scrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat width = CGRectGetWidth(scrollView.frame);
        if (scrollView.isDecelerating) {
            if (velocity.x > 0) { // to right
                self.originOffsetX = floorf(offsetX / width) * width;
            } else if (velocity.x < 0) {
                self.originOffsetX = ceilf(offsetX / width) * width;
            }
        }
        // 如果松手时位置，刚好不需要decelerating。则主动调用刷新page。
        BOOL notNeedToDecelerating = (NSInteger)(offsetX * 100) % (NSInteger)(width * 100) == 0;
        if (notNeedToDecelerating) {
            [self updatePageViewAfterTragging:scrollView];
        }
    }

    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollViewForwardDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)updatePageViewAfterTragging:(UIScrollView *)scrollView {
    // 最终停下的位置
    NSUInteger newIndex = [self calculateIndexWithOffset:scrollView.contentOffset.x width:CGRectGetWidth(scrollView.frame)];
    // 本次开始滑动前的那个页面
    NSUInteger oldIndex = self.currentPageIndex;
    // 确定新的当前页
    self.currentPageIndex = newIndex;
    if (newIndex == oldIndex) { // 最终确定的位置与开始位置相同时，需要重新显示开始位置的视图，以及消失最近一次猜测的位置的视图。
        if (self.guessToIndex < self.totalPageCount) {
            UIViewController *appearVC = [self controllerAtIndex:newIndex];
            UIViewController *disappearVC = [self controllerAtIndex:self.guessToIndex];
            [disappearVC beginAppearanceTransition:NO animated:YES];
            [appearVC beginAppearanceTransition:YES animated:YES];
            [disappearVC endAppearanceTransition];
            [appearVC endAppearanceTransition];
            [self recyclePage:disappearVC atIndex:self.guessToIndex];
        }
    } else {
        UIViewController *appearVC = [self createChildViewControllersAtIndex:newIndex direction:oldIndex <= newIndex ? ASHPageScrollDirectionRight : ASHPageScrollDirectionLeft]; // 最终确定的页面，可能会因为页面卡顿，导致不是guessToIndex那个vc，可能不在缓存中，需要临时创建
        UIViewController *disappearVC = [self controllerAtIndex:oldIndex];                                                                                                        // old一定是原来的current，这个current的消失，在scroll那边启动过
        [appearVC beginAppearanceTransition:YES animated:YES];
        [disappearVC endAppearanceTransition];
        [appearVC endAppearanceTransition];
        [self recyclePage:disappearVC atIndex:oldIndex];
    }

    //归位，用于下次滚动比较
    self.originOffsetX = scrollView.contentOffset.x;
    // 更正guess page
    self.guessToIndex = self.currentPageIndex;

    if ([self respondsToSelector:@selector(transitionFromIndex:toIndex:animated:)]) {
        [self transitionFromIndex:oldIndex toIndex:self.currentPageIndex animated:YES];
    }

    if ([self.delegate respondsToSelector:@selector(pageViewController:didTransitionFromIndex:toIndex:)]) {
        [self.delegate pageViewController:self didTransitionFromIndex:oldIndex toIndex:self.currentPageIndex];
    }

    [self cleanCacheToClean];
}

// 外部如果要使用ASHPageViewController的scrollView的delegate，不要直接给scrollView的delegate赋值，
// 而是使用scrollViewForwardDelegate将代理链传递出去
// TODO: 代理采用NSProxy来写？内部就不用把scrollview的代理全部实现一遍了OTZ

#pragma mark other scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollViewForwardDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.scrollViewForwardDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollViewForwardDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.scrollViewForwardDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.scrollViewForwardDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.scrollViewForwardDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.scrollViewForwardDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollViewForwardDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollViewForwardDelegate scrollViewDidScrollToTop:scrollView];
    }
}

#pragma mark - ASHPageViewControllerDataSource

- (NSUInteger)numberOfControllersInPageViewController:(ASHPageViewController *)pageViewController {
    NSAssert(NO, @"you must impletement method numberOfControllers:");
    return 0;
}

- (nullable UIViewController *)pageViewController:(ASHPageViewController *)pageViewController controllerAtIndex:(NSUInteger)index {
    NSAssert(NO, @"you must impletement method pageViewController:controllerAtIndex");
    return nil;
}

#pragma mark - NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        // 自动清楚cache中childvc，进到前台后将dic中的childvc复制到cache中
        return;
    }
    @weakify(self);

    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        [self _cache:cache willEvictObject:obj];
    });
}

- (void)_cache:(NSCache *)cache willEvictObject:(UIViewController *)obj {
    self.isCleaningCache = YES;
    if (obj) {
        // TODO:缓存策略相对复杂，一直往前滚动，会一直触发缓存清理策略
        if ([self.childViewControllers containsObject:obj]) {
            // 如果set.count > 0,说明被cache删除的vc是正在用或者可能将要用上的，所以从cache清除之后，临时放在cleanSet中
            // 滚动稳定之后在继续做处理：重新存入cache或者移除那些最近不会使用的
            [self addEvictionVCToPendingCleanSet:obj];
            // 表示这个vc最近不会再使用过了，从视图中移除子控制器
            if (self.cleaningPagesDic.count == 0) {
                [obj ash_removeFromParentViewController];
            }
        }
        // 同步数据
        NSArray *objKeys = [self.cachedPagesDic allKeysForObject:obj];
        if (objKeys.count > 0) {
            [self.cachedPagesDic removeObjectsForKeys:objKeys];
        }
    }
    self.isCleaningCache = NO;
}

/**
 在缓存清理时，判断要清理的vc是否为即将会使用的vc
 */
- (void)addEvictionVCToPendingCleanSet:(UIViewController *)evictionVC {
    // When scrollView's dragging, tracking and decelerating are all false.At least it means the cache eviction is not triggered by continuous interaction page changing.
    if (!self.scrollView.isDragging && !self.scrollView.isTracking && !self.scrollView.isDecelerating) {
        UIViewController *lastPageVC = [self controllerAtIndex:self.lastSelectedIndex];
        UIViewController *currentPageVC = [self controllerAtIndex:self.currentPageIndex];
        if (lastPageVC == evictionVC) { // 如果是当前或者上次的控制器，加入待清除的vc中
            [self.cleaningPagesDic setObject:evictionVC forKey:@(self.lastSelectedIndex)];
        } else if (currentPageVC == evictionVC) {
            [self.cleaningPagesDic setObject:evictionVC forKey:@(self.currentPageIndex)];
        }
    } else if (self.scrollView.isDragging) { // 正在拖动
        NSUInteger leftIndex;
        NSUInteger rightIndex;
        if (self.guessToIndex == 0) {
            leftIndex = self.guessToIndex;
        } else {
            leftIndex = self.guessToIndex - 1;
        }
        if (self.guessToIndex == self.totalPageCount - 1) {
            rightIndex = self.guessToIndex;
        } else {
            rightIndex = self.guessToIndex + 1;
        }
        UIViewController *leftNeighbourVC = [self controllerAtIndex:leftIndex];
        UIViewController *midPageVC = [self controllerAtIndex:self.guessToIndex];
        UIViewController *rightNeighbourVC = [self controllerAtIndex:rightIndex];
        if (leftNeighbourVC == evictionVC) {
            [self.cleaningPagesDic setObject:leftNeighbourVC forKey:@(leftIndex)];
        } else if (rightNeighbourVC == evictionVC) {
            [self.cleaningPagesDic setObject:rightNeighbourVC forKey:@(rightIndex)];
        } else if (midPageVC == evictionVC) {
            [self.cleaningPagesDic setObject:midPageVC forKey:@(self.guessToIndex)];
        }
    }
}

- (void)cleanCacheToClean {
    //    UIViewController *currentPageVC = [self controllerAtIndex:self.currentPageIndex];
    //    UIViewController *preVC = nil;
    //    NSUInteger preIndex = self.currentPageIndex - 1;
    //    if (preIndex != NSUIntegerMax) {
    //        preVC = [self controllerAtIndex:preIndex];
    //    }
    //    UIViewController *nextVC = nil;
    //    NSUInteger nextIndex = self.currentPageIndex + 1;
    //    if (nextIndex < self.totalPageCount) {
    //        nextVC = [self controllerAtIndex:nextIndex];
    //    }
    //    // 这时候的缓存中，可能有些childvc已经被删除，放到childToCleanSet中，而且这些childVC还在childViewController中
    //    [self.cleaningPagesDic removeAllObjects];
    //    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.cachedPagesDic copy]];
    //    @weakify(self);
    //    [dic enumerateKeysAndObjectsUsingBlock:^(NSNumber *_Nonnull key, UIViewController *_Nonnull obj, BOOL *_Nonnull stop) {
    //        @strongify(self);
    //        if (obj == currentPageVC || obj == preVC || obj == nextVC) {
    //
    //        } else {
    //            [self.cachedPagesDic removeObjectForKey:key];
    //            [self.pagesCache removeObjectForKey:key];
    //            [obj ash_removeFromParentViewController];
    //        }
    //    }];
    //
    //    if (preVC) {
    //        [self cacheChildVC:preVC atIndex:preIndex];
    //    }
    //    if (nextVC) {
    //        [self cacheChildVC:nextVC atIndex:nextIndex];
    //    }
    //    if (currentPageVC) {
    //        [self cacheChildVC:currentPageVC atIndex:self.currentPageIndex];
    //    }
}

#pragma mark - help methods

- (CGRect)calculateVisibleViewControllerFrameWithIndex:(NSUInteger)index {
    CGFloat offsetX = 0.0;
    offsetX = index * CGRectGetWidth(self.scrollView.frame);
    return CGRectMake(offsetX, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
}

- (void)updateScrollViewContentSizeAfterVCLayout {
    if (CGRectGetWidth(self.scrollView.frame) > 0.0) {
        CGFloat width = self.totalPageCount * CGRectGetWidth(self.scrollView.frame);
        CGFloat height = CGRectGetHeight(self.scrollView.frame);
        CGSize oldContentSize = self.scrollView.contentSize;
        if (width != oldContentSize.width || height != oldContentSize.height) {
            self.scrollView.contentSize = CGSizeMake(width, height);
        }
    }
}

- (void)setScrollViewContentOffset {
    CGPoint contentOffset = [self calculateOffsetWithIndex:self.currentPageIndex width:CGRectGetWidth(self.scrollView.frame) maxWidth:self.scrollView.contentSize.width];
    [self.scrollView setContentOffset:contentOffset animated:NO];
}

- (UIViewController *)controllerAtIndex:(NSUInteger)index {
    if (index != NSUIntegerMax && index < self.totalPageCount) {
        return [self.cachedPagesDic objectForKey:@(index)];
    }
    return nil;
}

- (CGPoint)calculateOffsetWithIndex:(NSUInteger)index width:(CGFloat)width maxWidth:(CGFloat)maxWidth {
    CGFloat offsetX = index * width;
    if (offsetX < 0) {
        offsetX = 0;
    }
    if (maxWidth > 0.0 && offsetX > maxWidth - width) {
        offsetX = maxWidth - width;
    }
    return CGPointMake(offsetX, 0);
}

- (NSUInteger)calculateIndexWithOffset:(CGFloat)offset width:(CGFloat)width {
    return (NSUInteger)(fabs(offset) / width);
}

#pragma mark - getters and setters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)setScrollViewForwardDelegate:(id<UIScrollViewDelegate>)scrollViewForwardDelegate {
    if ([scrollViewForwardDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)]) {
        _scrollViewForwardDelegate = scrollViewForwardDelegate;
    }
}

- (NSUInteger)totalPageCount {
    NSUInteger pageCpunt = [self.dataSource numberOfControllersInPageViewController:self];
    if (_totalPageCount != pageCpunt) {
        _totalPageCount = pageCpunt;
        [self updateScrollViewContentSizeAfterVCLayout];
    }
    return _totalPageCount;
}

- (NSArray *)viewControllers {
    UIViewController *currentVC = [self controllerAtIndex:self.currentPageIndex];
    return currentVC ? @[currentVC] : nil;
}

- (NSCache<NSNumber *, UIViewController *> *)pagesCache {
    if (!_pagesCache) {
        _pagesCache = [[NSCache alloc] init];
        _pagesCache.countLimit = self.cachePageCount == 0 ? kMaxCacheCount : self.cachePageCount;
        _pagesCache.delegate = self;
    }
    return _pagesCache;
}

- (NSMutableDictionary<NSNumber *, UIViewController *> *)cachedPagesDic {
    if (!_cachedPagesDic) {
        _cachedPagesDic = [[NSMutableDictionary alloc] initWithCapacity:self.cachePageCount == 0 ? kMaxCacheCount : self.cachePageCount];
    }
    return _cachedPagesDic;
}

- (NSMutableDictionary<NSNumber *, UIViewController *> *)cleaningPagesDic {
    if (!_cleaningPagesDic) {
        _cleaningPagesDic = [[NSMutableDictionary alloc] init];
    }
    return _cleaningPagesDic;
}

@end
