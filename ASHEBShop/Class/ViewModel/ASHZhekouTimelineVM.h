//
//  ASHZhekouTimelineVM.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"
#import "ASHZheKouTimeLineModel.h"
@interface ASHZhekouTimelineVM : ASHBaseViewModel
@property(nonatomic, strong, readonly)ASHZheKouTimeLineModel* model;
@property(nonatomic, assign)NSInteger categoryId;
@end
