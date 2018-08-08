//
//  ASHZheKouTimeLineModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"
#import "ASHTopicModel.h"
@protocol ASHZheKouTimeLineInfoModel
@end
@interface ASHZheKouTimeLineInfoModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHTopicItemModel>* topic_list;
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
@interface ASHZheKouTimeLineModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHZheKouTimeLineInfoModel>* timeline_element;
@end
