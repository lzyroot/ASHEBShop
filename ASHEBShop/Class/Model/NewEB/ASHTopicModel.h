//
//  ASHTopicModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"

@protocol ASHCouponInfoModel <NSObject>
@end
@interface ASHCouponInfoModel : NSObject
@property (nonatomic, assign)NSInteger coupon_id;
@property (nonatomic, copy)NSString* raw_price;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* zk_price;
@property (nonatomic, copy)NSString* mydescription;
@property (nonatomic, copy)NSString* pic;
@property (nonatomic, copy)NSString* thumbnail_pic;
@property (nonatomic, copy)NSString* detail_url;
@property (nonatomic, copy)NSString* discount;
@property (nonatomic, copy)NSString* url;
@property (nonatomic, assign)NSInteger item_id;
@property (nonatomic, assign)BOOL post_free;
@property (nonatomic, assign)NSInteger topic_type;
@property (nonatomic, assign)NSInteger product_type;
@property (nonatomic, assign)NSTimeInterval offline_time;
@property (nonatomic, assign)NSInteger month_sales;

@property (nonatomic, assign)BOOL hasMore;//是否多个商品
@property (nonatomic, assign)NSInteger item_count;
@property (nonatomic, assign)NSInteger topic_id;
@end

@protocol ASHTopicItemModel <NSObject>
@end
@interface ASHTopicItemModel : NSObject
@property (nonatomic, assign)NSInteger topic_id;
@property (nonatomic, copy)NSString* element_type;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* subtitle;
@property (nonatomic, copy)NSString* mydescription;
@property (nonatomic, copy)NSString* pic;
@property (nonatomic, copy)NSString* pic2;
@property (nonatomic, assign)NSInteger month_sales;
@property (nonatomic, assign)NSInteger topic_type;
@property (nonatomic, assign)NSTimeInterval offline_time;
@property (nonatomic, assign)NSInteger item_count;
@property (nonatomic, copy)ASHCouponInfoModel* coupon_info;
@end
@interface ASHTopicModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHTopicItemModel>* topic_list;
@property (nonatomic, strong)NSMutableArray<ASHTopicItemModel>* coupon_list;
@property (nonatomic, assign)NSInteger max_count;
@end
