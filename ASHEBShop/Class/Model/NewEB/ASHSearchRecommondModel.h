//
//  ASHSearchRecommondModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"

@interface ASHSearchRecommondModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray* rec_word_list;
@property (nonatomic, strong)NSMutableArray* search_word_list;

@end
