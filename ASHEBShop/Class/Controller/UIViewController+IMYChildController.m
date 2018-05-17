//
//  UIViewController+IMYChildController.m
//  Pods
//
//  Created by anchor on 2017/4/19.
//
//

#import "UIViewController+IMYChildController.h"
#import <objc/runtime.h>

@implementation UIViewController (IMYChildController)

- (void)setImy_pageIdentifier:(NSString *)imy_pageIdentifier {
    objc_setAssociatedObject(self, @selector(imy_pageIdentifier), imy_pageIdentifier, OBJC_ASSOCIATION_COPY);
}

- (NSString *)imy_pageIdentifier {
    return objc_getAssociatedObject(self, @selector(imy_pageIdentifier));
}

- (void)imy_addChildViewController:(UIViewController *)childVC {
    [self imy_addChildViewController:childVC withFrame:self.view.bounds];
}

- (void)imy_addChildViewController:(UIViewController *)childVC inView:(UIView *)containerView withFrame:(CGRect)frame {
    [self imy_addChildViewController:childVC
                        addViewBlock:^(UIViewController *superVC, UIViewController *childVC) {
                            childVC.view.frame = frame;
                            if (![containerView.subviews containsObject:childVC.view]) {
                                [containerView addSubview:childVC.view];
                            }
                        }];
}

- (void)imy_addChildViewController:(UIViewController *)childVC withFrame:(CGRect)frame {
    [self imy_addChildViewController:childVC
                        addViewBlock:^(UIViewController *superVC, UIViewController *childVC) {
                            childVC.view.frame = frame;
                            if (![superVC.view.subviews containsObject:childVC.view]) {
                                [superVC.view addSubview:childVC.view];
                            }
                        }];
}

- (void)imy_addChildViewController:(UIViewController *)childVC addViewBlock:(void (^)(UIViewController *superVC, UIViewController *childVC))addViewBlock {
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

- (void)imy_removeFromParentViewController {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
