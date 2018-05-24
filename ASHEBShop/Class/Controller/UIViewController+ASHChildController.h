//
//  UIViewController+ASHChildController.h
//  Pods
//

//
//

#import <UIKit/UIKit.h>

@interface UIViewController (ASHChildController)

@property (nonatomic, copy) NSString *ash_pageIdentifier;

- (void)ash_addChildViewController:(UIViewController *)childVC;
- (void)ash_addChildViewController:(UIViewController *)childVC inView:(UIView *)containerView withFrame:(CGRect)frame;
- (void)ash_addChildViewController:(UIViewController *)childVC withFrame:(CGRect)frame;
- (void)ash_addChildViewController:(UIViewController *)childVC addViewBlock:(void (^)(UIViewController *superVC, UIViewController *childVC))addViewBlock;
- (void)ash_removeFromParentViewController;

@end
