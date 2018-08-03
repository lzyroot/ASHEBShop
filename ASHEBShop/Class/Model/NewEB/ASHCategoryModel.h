//
//  ASHCategoryModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"
@protocol ASHCategoryItemModel <NSObject>
@end
@interface ASHCategoryItemModel : NSObject
@property (nonatomic, assign)NSInteger element_id;
@property (nonatomic, copy)NSString* element_type;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* name;
@property (nonatomic, copy)NSString* subtitle;
@property (nonatomic, copy)NSString* extend;
@property (nonatomic, copy)NSString* pic;
@property (nonatomic, copy)NSString* pic2;
@property (nonatomic, assign)NSInteger pic_width;
@property (nonatomic, assign)NSInteger pic_height;
@property (nonatomic, assign)NSTimeInterval offline_time;
@property (nonatomic, assign)NSInteger index;
@end

@interface ASHCategoryModel : ASHBaseModel

@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_index_banner;
@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_index_timeline;
@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_index_fixed_ad;
@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_cate_banner;
@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_cate_timeline;
@property (nonatomic, strong)NSMutableArray<ASHCategoryItemModel>* zhekou_cate_minipic;
@end
