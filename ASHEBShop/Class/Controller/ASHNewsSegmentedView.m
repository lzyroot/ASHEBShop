//
//  ASHNewsSegmentedView.m
//  ASHNews
//
//

#import "ASHNewsSegmentedView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa.h>

@interface ASHSegmengMaskView : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) BOOL isLeft;
- (instancetype)initWithPosition:(BOOL)isLeft;
@end

@interface ASHNewsSegmentedView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat buttonOffset;
@property (nonatomic, strong, readwrite) UIView *indicatorView;

@end


#define DefaultWidth 120
#define ButtonTag 0x17
@implementation ASHNewsSegmentedView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorWidth = [[UIScreen mainScreen] bounds].size.width / 4;
        [self prepareUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    [self updateSubViewFrame];
}

- (void)prepareUI {
    if (self.scrollView.superview != nil) {
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    UIView *leftShadeView = [[ASHSegmengMaskView alloc] initWithPosition:TRUE];
    leftShadeView.userInteractionEnabled = FALSE;
    [self addSubview:leftShadeView];

    UIView *rightShadeView = [[ASHSegmengMaskView alloc] initWithPosition:FALSE];
    rightShadeView.userInteractionEnabled = FALSE;
    [self addSubview:rightShadeView];
    [leftShadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(-5);
        make.width.mas_equalTo(20);
    }];
    [rightShadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(20);
    }];
}


- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.layer.cornerRadius = 1.5;
        [_indicatorView setBackgroundColor:[UIColor mainColor]];
    }
    return _indicatorView;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    [self setSelectedIndex:currentIndex animate:YES];
}
- (void)setSelectedIndex:(NSUInteger)currentIndex animate:(BOOL)animate {
    NSUInteger numsSegmendedViews = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSegmentedViews:)]) {
        numsSegmendedViews = [self.dataSource numberOfSegmentedViews:self];
    }
    if (currentIndex >= numsSegmendedViews) {
        return;
    }
    if (_currentIndex != currentIndex) {
        [self setButtonSelect:_currentIndex select:FALSE];
        _currentIndex = currentIndex;
        UIButton *btn = [self setButtonSelect:currentIndex select:TRUE];
        [self moveIndicatorView:btn animated:animate];
    }
}

- (void)resetSubViews {
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.buttonOffset = 0;
    //    self.currentIndex = 0;
    NSUInteger segmentedViews = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSegmentedViews:)]) {
        segmentedViews = [self.dataSource numberOfSegmentedViews:self];
    }
    if (segmentedViews == 0 || segmentedViews == NSUIntegerMax) {
        return;
    }
    for (int i = 0; i < segmentedViews; i++) {
        NSString *title = nil;
        if ([self.dataSource respondsToSelector:@selector(titleForSegmentedView:index:)]) {
            title = [self.dataSource titleForSegmentedView:self index:i];
        }
        CGFloat buttonWidth = DefaultWidth;
        if ([self.dataSource respondsToSelector:@selector(segmentedViewWidth:index:)]) {
            buttonWidth = [self.dataSource segmentedViewWidth:self index:i];
        }
        [self addButton:i title:title width:buttonWidth];
    }
    [self.scrollView setContentSize:CGSizeMake(self.buttonOffset, self.bounds.size.height)];

    [self.scrollView bringSubviewToFront:self.indicatorView];
}

- (void)addButton:(NSUInteger)index title:(NSString *)title width:(CGFloat)width {
    UIButton *button = [[UIButton alloc] init];
    if ([title isKindOfClass:NSString.class]) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    UIColor *color = self.titleColor;
    if (color == nil) {
        color = [UIColor blackColor];
    }
    [button setTitleColor:color forState:UIControlStateNormal];
    color = self.titleSelectColor;
    if (color == nil) {
        color = [UIColor mainColor];
    }
    [button setTitleColor:color forState:UIControlStateSelected];
    button.titleLabel.font = self.titleFont ? self.titleFont : [UIFont systemFontOfSize:15];
    button.tag = ButtonTag + index;
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self);
        NSUInteger tag = x.tag - ButtonTag;
        if ([self.delegate respondsToSelector:@selector(ASHNewsSegmentedViewDidSelect:index:)]) {
            [self.delegate ASHNewsSegmentedViewDidSelect:self index:tag];
        }
        [self setSelectedIndex:tag animate:TRUE];
    }];

    button.frame = CGRectMake(self.buttonOffset, 0, width, self.bounds.size.height);
    [self.scrollView addSubview:button];
    [button setSelected:self.currentIndex == index];
    button.titleLabel.font = button.selected ? (self.titleSelectFont ?: [UIFont systemFontOfSize:15]) : (self.titleFont ?: [UIFont systemFontOfSize:15]);
    if (self.currentIndex == index) {
        [self moveIndicatorView:button animated:false];
    }
    self.buttonOffset += width;

    CGFloat redDotViewWith = 10.0f;

    UIView *redDotView = [[UIView alloc] init];
    [redDotView setBackgroundColor:[UIColor redColor]];
    redDotView.clipsToBounds = YES;
    redDotView.layer.cornerRadius = redDotViewWith / 2;
    redDotView.tag = -110; //why？感觉红点太多了，要叫110捏
    redDotView.hidden = YES;
    [button addSubview:redDotView];

    [redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.titleLabel).offset(-2);
        make.right.mas_equalTo(button.titleLabel).offset(5);
        make.size.mas_equalTo(CGSizeMake(redDotViewWith, redDotViewWith));
    }];
}

- (void)moveIndicatorView:(UIButton *)button animated:(BOOL)animated {
    if (self.indicatorView.hidden == NO) {
        if (self.indicatorView.superview == nil) {
            [self.scrollView addSubview:self.indicatorView];
        }
        CGRect frame = CGRectMake(button.frame.origin.x + (button.bounds.size.width - self.indicatorWidth) / 2, button.bounds.size.height - 3, self.indicatorWidth, 3);

        [self.scrollView bringSubviewToFront:self.indicatorView];
        if (animated) {
            [UIView animateWithDuration:0.45
                             animations:^{
                                 self.indicatorView.frame = frame;
                             }];
        } else {
            self.indicatorView.frame = frame;
        }
        self.indicatorView.hidden = false;
    }
    CGFloat width = self.bounds.size.width;
    if (width == 0) {
        width = ASHScreenWidth;
    }
    if (self.scrollView.contentSize.width <= width) {
        return;
    }
    if (button.center.x > self.center.x) {
        CGFloat offset = button.center.x - self.center.x;
        if (offset > self.scrollView.contentSize.width - width) {
            offset = self.scrollView.contentSize.width - width;
        }
        [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:animated];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:animated];
    }
}
- (UIButton *)setButtonSelect:(NSUInteger)index select:(BOOL)select {
    UIButton *indexButton = nil;
    for (UIButton *button in self.scrollView.subviews) {
        if ([button isKindOfClass:UIButton.class]) {
            if (button.tag == ButtonTag + index) {
                indexButton = button;
                break;
            }
        }
    }
    if (indexButton != nil) {
        [indexButton setSelected:select];
        indexButton.titleLabel.font = select ? (self.titleSelectFont ?: [UIFont systemFontOfSize:15]) : (self.titleFont ?: [UIFont systemFontOfSize:15]);
    }
    return indexButton;
}
- (void)updateSubViewFrame {
    for (UIButton *button in self.scrollView.subviews) {
        if ([button isKindOfClass:UIButton.class]) {
            CGRect frame = button.frame;
            frame.size.height = self.scrollView.bounds.size.height;
            button.frame = frame;
        }
    }
    CGRect frame = self.indicatorView.frame;
    frame.origin.y = self.scrollView.bounds.size.height - frame.size.height;
    self.indicatorView.frame = frame;
}

- (void)reload {
    [self resetSubViews];
}

- (void)reloadAt:(NSUInteger)index {
    NSString *title = nil;
    if ([self.dataSource respondsToSelector:@selector(titleForSegmentedView:index:)]) {
        title = [self.dataSource titleForSegmentedView:self index:index];
    }
    UIButton *btn = [self setButtonSelect:index select:self.currentIndex == index];
    btn.titleLabel.text = title;
}

- (void)showRedDotView {
    for (UIButton *button in self.scrollView.subviews) {
        UIView *redDocView = [button viewWithTag:-110];
        redDocView.hidden = NO;
    }
}

- (void)hideRedDotView {
    for (UIButton *button in self.scrollView.subviews) {
        UIView *redDocView = [button viewWithTag:-110];
        redDocView.hidden = YES;
    }
}

- (void)showRedDotView:(NSInteger)index {
    UIButton *btn = [self buttonWith:index];
    UIView *redDocView = [btn viewWithTag:-110];
    redDocView.hidden = NO;
}

- (void)hideRedDotView:(NSInteger)index {
    UIButton *btn = [self buttonWith:index];
    UIView *redDocView = [btn viewWithTag:-110];
    redDocView.hidden = YES;
}

- (UIButton *)buttonWith:(NSUInteger)index {
    UIButton *button = [self.scrollView viewWithTag:(ButtonTag + index)];
    if ([button isKindOfClass:UIButton.class]) {
        return button;
    }
    return nil;
}

@end


@implementation ASHSegmengMaskView

- (instancetype)initWithPosition:(BOOL)isLeft {
    self = [super init];
    if (self) {
        self.isLeft = isLeft;
        [self customInit];
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    self.gradientLayer.frame = self.bounds;
}

- (void)customInit {
    self.backgroundColor = [UIColor clearColor];
    self.gradientLayer = [CAGradientLayer layer];
    id left = nil;
    id right = nil;
    if (self.isLeft) {
        left = (id)[[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
        right = (id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor;
    } else {
        left = (id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor;
        right = (id)[[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    }
    self.gradientLayer.colors = @[left, right];
    if (self.isLeft) {
        self.gradientLayer.locations = @[[NSNumber numberWithFloat:0.1], [NSNumber numberWithFloat:1]];
    } else {
        self.gradientLayer.locations = @[[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1]];
    }

    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

@end
