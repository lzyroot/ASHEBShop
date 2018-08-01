//
//  ASHTabManager.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHShareInstace.h"
#import "ASHTabModel.h"
@interface ASHTabManager : ASHShareInstace
@property(nonatomic, readonly,strong)ASHTabModel* model;
@property(nonatomic, readonly,strong)ASHTabModel* hasRecommendmodel;//手动增加今日推荐
@end
