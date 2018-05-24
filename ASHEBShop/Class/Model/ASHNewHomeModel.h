//
//  ASHNewHomeModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/5/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"
@protocol ASHNewHomeItemModel <NSObject>
@end
@interface ASHNewHomeItemModel : NSObject
@property (nonatomic, assign)NSInteger praise;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* remark;
@property (nonatomic, assign)NSInteger itemId;
@property (nonatomic, copy)NSString* imageUrl;
@property (nonatomic, assign)NSTimeInterval createAt;
@property (nonatomic, assign)NSTimeInterval updateAt;
@end

@interface ASHNewHomeModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHNewHomeItemModel>* dataArr;
@end
