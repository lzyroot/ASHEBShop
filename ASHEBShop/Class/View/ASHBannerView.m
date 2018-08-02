//
//  ASHBannerView.m
//  ASHViewKit
//
//  Created by ljh on 15/5/20.
//  Copyright (c) 2015年 ASH. All rights reserved.
//

#import "ASHBannerView.h"
#import <ReactiveCocoa.h>
#import <UIImageView+WebCache.h>

@interface _ASHBannerViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *itemView;
@end

@interface _ASHBannerImageView : UIImageView

@end

@interface ASHBannerView () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

///1000
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleBgView;

@property (strong, nonatomic) NSMutableArray *itemViews;

@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) NSMutableArray *customViews;

@property (assign, nonatomic) NSInteger draggingIndex;
@property (assign, nonatomic) BOOL shouldStop;

@end

@implementation ASHBannerView
- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, ASHScreenWidth, ceil(110 * ASHScreenWidth / 320.0f))];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _initMyself];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initMyself];
    }
    return self;
}
- (void)_initMyself {
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil]
        takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startAutoScroll];
        });
    }];

    self.itemViews = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.customViews = [NSMutableArray array];

    [self initCollectionView];

    self.titleBgView = [UIView new];
    self.titleBgView.userInteractionEnabled = NO;
    self.titleBgView.hidden = YES;
    [self addSubview:self.titleBgView];

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.titleLabel.hidden = YES;
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.titleLabel];

    self.backgroundColor = [UIColor lineColor];
    
    self.shouldStop = NO;
}

- (UIScrollView *)scrollView {
    return _collectionView;
}
- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsZero;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor lineColor];

    // 注册cell
    [_collectionView registerClass:[_ASHBannerViewCell class] forCellWithReuseIdentifier:@"cell"];
    for (int i = 0; i < 6; i++) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%d", i];
        [_collectionView registerClass:[_ASHBannerViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    [self addSubview:_collectionView];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_collectionView.frame, self.bounds)) {
        [self loadData];
    }
}
- (NSInteger)currentIndex {
    NSIndexPath *indexPath = _collectionView.indexPathsForVisibleItems.firstObject;
    NSInteger currentIndex = 0;
    if (_itemViews.count > 0) {
        currentIndex = indexPath.item % _itemViews.count;
    }
    return currentIndex;
}
- (void)setImages:(NSArray *)images {
    _images = [images copy];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    self.titleLabel.hidden = titles.count <= 0;
    self.titleBgView.hidden = self.titleLabel.hidden;
    if (self.currentIndex < titles.count) {
        self.titleLabel.text = titles[self.currentIndex];
    }
}

- (UIView *)itemViewForIndex:(NSInteger)index data:(id)data {
    UIView *itemView = nil;
    if (_onItemViewCreating) {
        UIView *reusableView = _customViews.lastObject;
        if (reusableView != nil) {
            [_customViews removeLastObject];
        }
        itemView = _onItemViewCreating(reusableView, index, data);
    }

    if (itemView == nil) {
        _ASHBannerImageView *imageView = [self reusableImageView];
        if ([data isKindOfClass:[UIImage class]]) {
            imageView.image = data;
        } else if ([data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSURL class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:data]];
        } else {
            NSCAssert(NO, @"ASHBannerView 数据格式不对");
        }
        itemView = imageView;
    }
    return itemView;
}
- (_ASHBannerImageView *)reusableImageView {
    _ASHBannerImageView *imageView = _imageViews.lastObject;
    if (imageView != nil) {
        [_imageViews removeLastObject];
        imageView.frame = self.bounds;
        imageView.image = nil;
        [imageView sd_cancelCurrentImageLoad];
    } else {
        imageView = [[_ASHBannerImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor lightGrayColor];
    }
    return imageView;
}
- (void)clearAllItemViews {
    for (id subview in _itemViews) {
        if ([subview isKindOfClass:[_ASHBannerImageView class]]) {
            _ASHBannerImageView *imageView = subview;
            [imageView sd_cancelCurrentImageLoad];
            imageView.image = nil;
            [_imageViews addObject:imageView];
        } else {
            [_customViews addObject:subview];
        }
        [subview removeFromSuperview];
    }
    [_itemViews removeAllObjects];
    [self resizeTitleBgView];
}
- (void)loadData {
    [self clearAllItemViews];

    if (_images.count == 0) {
        [self.collectionView reloadData];
        [self fixStartPosition];
        return;
    }

    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = self.bounds.size;
    self.collectionView.frame = self.bounds;

    _pageControl.numberOfPages = _images.count;
    _pageControl.currentPage = 0;
    NSInteger pageControlWidth = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages].width;
    _pageControl.ash_size = CGSizeMake(pageControlWidth, 30);
    self.titleLabel.ash_width = self.ash_width - pageControlWidth - 20 - 15;

    switch (_position) {
        case ASHBannerPageControlAtCenter: {
            self.titleLabel.hidden = YES;
            self.titleBgView.hidden = YES;
            _pageControl.center = CGPointMake(self.ash_width * 0.5, self.ash_height - 12);
            break;
        }
        case ASHBannerPageControlAtLeft: {
            _pageControl.ash_centerY = self.ash_height - 12;
            _pageControl.ash_left = 10;
            self.titleLabel.ash_centerY = self.pageControl.ash_centerY;
            self.titleLabel.ash_left = self.pageControl.ash_right + 15;
            self.titleLabel.ash_right = self.ash_width - 10;
            break;
        }
        case ASHBannerPageControlAtRight: {
            _pageControl.ash_centerY = self.ash_height - 12;
            _pageControl.ash_right = self.ash_width - 10;
            self.titleLabel.ash_centerY = self.pageControl.ash_centerY;
            self.titleLabel.ash_left = 10;
            self.titleLabel.ash_right = self.pageControl.ash_left - 15;

            break;
        }
    }

    if (_pageControl.numberOfPages == 1) {
        _pageControl.hidden = YES;
        _collectionView.scrollEnabled = NO;

        id data = _images[0];
        UIView *itemView = [self itemViewForIndex:0 data:data];
        [_itemViews addObject:itemView];
        if (_onDidItemViewCreated) {
            _onDidItemViewCreated(itemView, 0);
        }
    } else {
        _pageControl.hidden = NO;
        _collectionView.scrollEnabled = YES;

        for (NSInteger index = 0; index < _images.count; index++) {
            id data = _images[index];
            UIView *itemView = [self itemViewForIndex:index data:data];
            [_itemViews addObject:itemView];
            if (_onDidItemViewCreated) {
                _onDidItemViewCreated(itemView, index);
            }
        }
    }

    [self startAutoScroll];
    if (self.onDidScrollToIndex) {
        self.onDidScrollToIndex(0);
    }
    [_imageViews removeAllObjects];
    [_customViews removeAllObjects];

    [_collectionView reloadData];
    [self fixStartPosition];
}
// 配置默认起始位置
- (void)fixStartPosition {
    self.pageControl.currentPage = 0;
    if (_itemViews.count > 1) {
        NSInteger maxCount = _itemViews.count * 2000;
        NSInteger itemIndex = maxCount / 2;
        if ([_collectionView numberOfItemsInSection:0] > itemIndex) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    } else if (_itemViews.count > 0) {
        NSInteger itemIndex = 0;
        if ([_collectionView numberOfItemsInSection:0] > itemIndex) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    } else {
        _collectionView.contentOffset = CGPointZero;
    }
    if (self.titles.count > 0) {
        self.titleLabel.text = self.titles.firstObject;
    }
}
- (void)resizeTitleBgView {
    self.titleBgView.frame = CGRectMake(0, self.ash_height - 50, self.ash_width, 50);
    [self.titleBgView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:0.65].CGColor];
    gradientLayer.locations = @[@0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = (CGRect){CGPointZero, self.titleBgView.bounds.size};
    [self.titleBgView.layer addSublayer:gradientLayer];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_itemViews.count > 1) {
        return _itemViews.count * 2000;
    }
    return _itemViews.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell";
    NSInteger index = 0;
    if (_itemViews.count > 0) {
        index = indexPath.item % _itemViews.count;
    }
    if (index < 6) {
        cellIdentifier = [NSString stringWithFormat:@"cell_%d", (int)index];
    }
    _ASHBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIView *itemView = self.itemViews[index];
    cell.itemView = itemView;
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(_ASHBannerViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    if (_itemViews.count > 0) {
        index = indexPath.item % _itemViews.count;
    }
    UIView *itemView = self.itemViews[index];
    cell.itemView = itemView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    if (_itemViews.count > 0) {
        index = indexPath.item % _itemViews.count;
    }
    if (self.onDidClickEvent) {
        self.onDidClickEvent(index);
    }
    [self startAutoScroll];
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = self.currentIndex;
    if (_pageControl.currentPage != index) {
        _pageControl.currentPage = MIN(_pageControl.numberOfPages, MAX(0, index));
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_itemViews.count <= 1) {
        return;
    }
    [self startAutoScroll];
    NSInteger index = self.currentIndex;
    if (_pageControl.currentPage != index) {
        _pageControl.currentPage = MIN(_pageControl.numberOfPages, MAX(0, index));
    }
    if (index < self.titles.count) {
        self.titleLabel.text = self.titles[index];
    } else {
        self.titleLabel.text = @"";
    }
    if (self.draggingIndex != index && self.onDidScrollToIndex) {
        self.onDidScrollToIndex(index);
        self.draggingIndex = index;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_itemViews.count <= 1) {
        return;
    }
    if (decelerate == NO) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self cancelAutoScroll];
    self.draggingIndex = self.currentIndex;
}
#pragma mark timer相关
- (void)startAutoScroll {
    if (_itemViews.count <= 1) {
        return;
    }
    if (_collectionView.isDragging || _collectionView.isTracking) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.shouldStop) {
            [self autoScrollToNext];
        }else{
            self.shouldStop = NO;
        }
        
    });
}
- (void)cancelAutoScroll {
    self.shouldStop = YES;
}
- (void)autoScrollToNext {
    if (_itemViews.count <= 1) {
        return;
    }

    NSInteger index = self.currentIndex + 1;
    self.currentIndex = index;

    if (self.window && [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self startAutoScroll];
    }

    {
        NSInteger newIndex = 0;
        if (_itemViews.count > 0) {
            newIndex = index % _itemViews.count;
        }
        self.draggingIndex = newIndex;
        if (self.onDidScrollToIndex) {
            self.onDidScrollToIndex(newIndex);
        }
    }

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.scrollView.isTracking == NO) {
//            [self scrollViewDidEndDecelerating:self.scrollView];
//        }
//    });
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        [self startAutoScroll];
    } else {
        [self cancelAutoScroll];
    }
}
- (void)setCurrentIndex:(NSInteger)newIndex {
    if (_itemViews.count <= 1) {
        return;
    }
    BOOL isAnimation = YES;
    NSIndexPath *indexPath = self.collectionView.indexPathsForVisibleItems.firstObject;
    if (indexPath == nil) {
        NSInteger maxCount = _itemViews.count * 2000;
        NSInteger itemIndex = maxCount / 2;
        indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
        isAnimation = NO;
    }
    NSInteger currentIndex = 0;
    if (_itemViews.count > 0) {
        currentIndex = indexPath.item % _itemViews.count;
    }
    if (currentIndex == newIndex) {
        return;
    }
    NSInteger newItem = newIndex - currentIndex + indexPath.item;
    if ([_collectionView numberOfItemsInSection:0] > newItem) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:isAnimation];
    }
}
- (UIView *)currentShowView {
    NSInteger page = self.currentIndex;
    return _itemViews[page];
}
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    [_itemViews removeAllObjects];
}
@end

@implementation _ASHBannerImageView
@end

@implementation _ASHBannerViewCell
- (void)setItemView:(UIView *)itemView {
    if (_itemView != itemView) {
        if (_itemView.superview == self.contentView) {
            [_itemView removeFromSuperview];
        }
        _itemView = itemView;
        if (_itemView) {
            _itemView.frame = self.bounds;
            [self.contentView addSubview:_itemView];
        }
    }
}
- (void)prepareForReuse {
    [super prepareForReuse];
    if (_itemView.superview == self.contentView) {
        [_itemView removeFromSuperview];
    }
    _itemView = nil;
}
@end
