//
//  ASHTabViewModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"
#import "ASHTabModel.h"
@interface ASHTabViewModel : ASHBaseViewModel
@property (nonatomic, strong, readonly)ASHTabModel* model;
@property (nonatomic, strong, readonly)ASHTabModel* zhekouModel;
@end
