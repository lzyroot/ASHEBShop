//
//  UIViewController+IMYChildController.h
//  Pods
//

//
//

#import <UIKit/UIKit.h>

@interface UIViewController (IMYChildController)

@property (nonatomic, copy) NSString *imy_pageIdentifier;

- (void)imy_addChildViewController:(UIViewController *)childVC;
- (void)imy_addChildViewController:(UIViewController *)childVC inView:(UIView *)containerView withFrame:(CGRect)frame;
- (void)imy_addChildViewController:(UIViewController *)childVC withFrame:(CGRect)frame;
- (void)imy_addChildViewController:(UIViewController *)childVC addViewBlock:(void (^)(UIViewController *superVC, UIViewController *childVC))addViewBlock;
- (void)imy_removeFromParentViewController;

@end
