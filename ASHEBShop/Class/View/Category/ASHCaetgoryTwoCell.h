//
//  ASHCaetgoryTwoCell.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASHCaetgoryTwoCell : UITableViewCell
@property(copy,nonatomic)void(^itemClickAction)(NSInteger index);
@end
