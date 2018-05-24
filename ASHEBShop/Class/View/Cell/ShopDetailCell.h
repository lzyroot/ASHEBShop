//
//  ShopDetailCell.h
//  ASHEBShop
//
//  Created by xmfish on 2018/5/21.
//  Copyright © 2018年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASHShopDetailItemModel;
@interface ShopDetailCell : UITableViewCell
@property (nonatomic, strong)ASHShopDetailItemModel* model;

- (CGFloat)cellHeight;
@end
