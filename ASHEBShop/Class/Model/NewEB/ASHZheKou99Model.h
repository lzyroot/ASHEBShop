//
//  ASHZheKou99Model.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"
#import "ASHCategoryModel.h"
@interface ASHZheKou99Model : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_99_top;
@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_99_shelf;
@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_99_top_img;
@end
