//
//  ASHTabModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"

@protocol ASHTabItemModel <NSObject>
@end
@interface ASHTabItemModel : NSObject
@property (nonatomic, assign)NSInteger tab_id;
@property (nonatomic, copy)NSString* name;
@property (nonatomic, copy)NSString* pic;
@property (nonatomic, copy)NSString* pic2;

@end

@interface ASHTabModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHTabItemModel>* tab_elementArr;
@end
