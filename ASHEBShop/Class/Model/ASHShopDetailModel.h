//
//  ASHShopDetailModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/5/21.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"

@protocol ASHShopDetailItemModel <NSObject>
@end
@interface ASHShopDetailItemModel : NSObject
@property (nonatomic, assign)NSInteger praise;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* remark;
@property (nonatomic, assign)NSInteger itemId;
@property (nonatomic, copy)NSString* imageUrl;
@property (nonatomic, copy)NSString* content;
@property (nonatomic, copy)NSString* price;
@property (nonatomic, copy)NSString* goodsUrl;
@end
@interface ASHShopDetailModel : ASHBaseModel

@property (nonatomic, strong)NSMutableArray<ASHShopDetailItemModel>* contentArr;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* desc;
@property (nonatomic, copy)NSString* imageUrl;
@end
