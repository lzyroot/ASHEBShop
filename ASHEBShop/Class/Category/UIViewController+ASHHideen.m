//
//  UIViewController+ASHHideen.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "UIViewController+ASHHideen.h"

@implementation UIViewController (ASHHideen)

//- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
//    
//    if(viewController == self){
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [navigationController setNavigationBarHidden:YES animated:animated];
//        });
//      
//    }else{
//        
//        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
//            return;
//        }
//        [navigationController setNavigationBarHidden:NO animated:animated];
//        
//        if(navigationController.delegate == self){
//            navigationController.delegate = nil;
//        }
//
//        
//    }
//}


@end
