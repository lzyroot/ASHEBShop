//
//  ASHNewsSegmentedView.h
//  ASHNews
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ASHNewsSegmentedViewDelegate <NSObject>

@optional
- (void)ASHNewsSegmentedViewDidSelect:(id)sender index:(NSUInteger)index;
- (void)ASHNewsSegmentedCategoryClick:(id)sender;
@end

@protocol ASHNewsSegmentedViewDataSource <NSObject>
@required
- (NSUInteger)numberOfSegmentedViews:(id)sender;
- (NSString *)titleForSegmentedView:(id)sender index:(NSUInteger)index;

@optional
- (CGFloat)segmentedViewWidth:(id)sender index:(NSUInteger)index;
@end

@interface ASHNewsSegmentedView : UIView
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong, readonly) UIView *indicatorView;
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *titleSelectFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectColor;
@property (nonatomic, assign) BOOL showType;

@property (nonatomic, weak, nullable) id<ASHNewsSegmentedViewDelegate> delegate;
@property (nonatomic, weak, nullable) id<ASHNewsSegmentedViewDataSource> dataSource;

- (void)reload;
- (void)reloadAt:(NSUInteger)index;

- (void)showRedDotView;
- (void)hideRedDotView;
- (void)showRedDotView:(NSInteger)index;
- (void)hideRedDotView:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
