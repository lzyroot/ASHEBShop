//
//  ASHTypeSessionView.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/3.
//  Copyright © 2018年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASHTypeSessionView : UIView
@property(copy,nonatomic)void(^typeSelectAction)(NSInteger index);
- (void)setIndex:(NSInteger)index;
@end
