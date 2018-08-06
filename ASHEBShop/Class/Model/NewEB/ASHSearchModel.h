//
//  ASHSearchModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"
@protocol ASHSearchInfoModel <NSObject>
@end
@interface ASHSearchInfoModel : NSObject
@property (nonatomic, assign)NSInteger element_id;
@property (nonatomic, copy)NSString* element_type;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* extend;
@property (nonatomic, copy)NSString* color_num;

@end
@interface ASHSearchModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHSearchInfoModel>* search_hot_word;
@end
