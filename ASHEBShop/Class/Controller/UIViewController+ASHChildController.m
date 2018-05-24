//
//  UIViewController+ASHChildController.m
//  Pods
//

//
//

#import "UIViewController+ASHChildController.h"
#import <objc/runtime.h>

@implementation UIViewController (ASHChildController)

- (void)setAsh_pageIdentifier:(NSString *)ash_pageIdentifier {
    objc_setAssociatedObject(self, @selector(ash_pageIdentifier), ash_pageIdentifier, OBJC_ASSOCIATION_COPY);
}

- (NSString *)ash_pageIdentifier {
    return objc_getAssociatedObject(self, @selector(ash_pageIdentifier));
}

- (void)ash_addChildViewController:(UIViewController *)childVC {
    [self ash_addChildViewController:childVC withFrame:self.view.bounds];
}

- (void)ash_addChildViewController:(UIViewController *)childVC inView:(UIView *)containerView withFrame:(CGRect)frame {
    [self ash_addChildViewController:childVC
                        addViewBlock:^(UIViewController *superVC, UIViewController *childVC) {
                            childVC.view.frame = frame;
                            if (![containerView.subviews containsObject:childVC.view]) {
                                [containerView addSubview:childVC.view];
                            }
                        }];
}

- (void)ash_addChildViewController:(UIViewController *)childVC withFrame:(CGRect)frame {
    [self ash_addChildViewController:childVC
                        addViewBlock:^(UIViewController *superVC, UIViewController *childVC) {
                            childVC.view.frame = frame;
                            if (![superVC.view.subviews containsObject:childVC.view]) {
                                [superVC.view addSubview:childVC.view];
                            }
                        }];
}

- (void)ash_addChildViewController:(UIViewController *)childVC addViewBlock:(void (^)(UIViewController *superVC, UIViewController *childVC))addViewBlock {
    if (!childVC) {
        return;
    }
    BOOL containsVC = [self.childViewControllers containsObject:childVC];
    if (!containsVC) {
        [self addChildViewController:childVC];
    }

    if (addViewBlock) {
        addViewBlock(self, childVC);
    }

    if (!containsVC) {
        [childVC didMoveToParentViewController:self];
    }
}

- (void)ash_removeFromParentViewController {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
