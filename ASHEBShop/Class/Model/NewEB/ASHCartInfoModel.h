//
//  ASHCartInfoModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/9/4.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"
@interface ASHCartDetailModel : ASHBaseModel<NSCopying>
@property(nonatomic, assign)NSInteger category;
@property(nonatomic, assign)NSInteger num_iid;
@property(nonatomic, strong)NSString* commission_rate;
@property(nonatomic, strong)NSString* coupon_click_url;
@property(nonatomic, strong)NSString* coupon_end_time;
@property(nonatomic, strong)NSString* coupon_start_time;
@property(nonatomic, strong)NSString* coupon_info;
@property(nonatomic, assign)NSInteger coupon_remain_count;
@property(nonatomic, assign)NSInteger coupon_total_count;
@property(nonatomic, strong)NSString* item_description;
@property(nonatomic, strong)NSString* item_url;
@property(nonatomic, strong)NSString* nick;
@property(nonatomic, strong)NSString* pict_url;
@property(nonatomic, strong)NSString* shop_title;
@property(nonatomic, strong)NSDictionary* small_images;
@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSString* zk_final_price;
@property(nonatomic, strong)NSString* price;
@property(nonatomic, assign)NSInteger seller_id;
@property(nonatomic, assign)NSInteger user_type;
@property(nonatomic, assign)NSInteger volume;
@property(nonatomic, assign)BOOL isLike;
@end
@interface ASHCartInfoModel : ASHBaseModel
@property(nonatomic, strong)ASHCartDetailModel* like_coupon;
@property(nonatomic, strong)ASHCartDetailModel* match_coupon;
@end
