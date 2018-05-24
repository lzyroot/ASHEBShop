//
//  IMYNewsSegmentedView.h
//  IMYNews
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol IMYNewsSegmentedViewDelegate <NSObject>

@optional
- (void)IMYNewsSegmentedViewDidSelect:(id)sender index:(NSUInteger)index;
@end

@protocol IMYNewsSegmentedViewDataSource <NSObject>
@required
- (NSUInteger)numberOfSegmentedViews:(id)sender;
- (NSString *)titleForSegmentedView:(id)sender index:(NSUInteger)index;

@optional
- (CGFloat)segmentedViewWidth:(id)sender index:(NSUInteger)index;
@end

@interface IMYNewsSegmentedView : UIView
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong, readonly) UIView *indicatorView;
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *titleSelectFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectColor;

@property (nonatomic, weak, nullable) id<IMYNewsSegmentedViewDelegate> delegate;
@property (nonatomic, weak, nullable) id<IMYNewsSegmentedViewDataSource> dataSource;

- (void)reload;
- (void)reloadAt:(NSUInteger)index;

- (void)showRedDotView;
- (void)hideRedDotView;
- (void)showRedDotView:(NSInteger)index;
- (void)hideRedDotView:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
