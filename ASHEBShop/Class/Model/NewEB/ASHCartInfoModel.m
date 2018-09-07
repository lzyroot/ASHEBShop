//
//  ASHCartInfoModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/9/4.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCartInfoModel.h"
@implementation ASHCartDetailModel
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.category = [[aDecoder decodeObjectForKey:@"category"] integerValue];
        
        self.num_iid = [[aDecoder decodeObjectForKey:@"num_iid"] integerValue];
        
        self.commission_rate = [aDecoder decodeObjectForKey:@"commission_rate"];
        
        self.coupon_click_url = [aDecoder decodeObjectForKey:@"coupon_click_url"];
        
        self.coupon_end_time = [aDecoder decodeObjectForKey:@"coupon_end_time"];
        
        self.coupon_start_time = [aDecoder decodeObjectForKey:@"coupon_start_time"];
        
        self.coupon_info = [aDecoder decodeObjectForKey:@"coupon_info"];
        
        self.coupon_remain_count = [[aDecoder decodeObjectForKey:@"coupon_remain_count"] integerValue];
        
        self.coupon_total_count = [[aDecoder decodeObjectForKey:@"coupon_total_count"] integerValue];
        
        self.item_description = [aDecoder decodeObjectForKey:@"item_description"];
        
        self.item_url = [aDecoder decodeObjectForKey:@"item_url"];
        
        self.nick = [aDecoder decodeObjectForKey:@"nick"];
        
        self.pict_url = [aDecoder decodeObjectForKey:@"pict_url"];
        
        self.shop_title = [aDecoder decodeObjectForKey:@"shop_title"];
        
        self.small_images = [aDecoder decodeObjectForKey:@"small_images"];
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        
        self.zk_final_price = [aDecoder decodeObjectForKey:@"zk_final_price"];
        
        self.price = [aDecoder decodeObjectForKey:@"price"];
        
        self.seller_id = [[aDecoder decodeObjectForKey:@"seller_id"] integerValue];
        
        self.user_type= [[aDecoder decodeObjectForKey:@"user_type"] integerValue];
        
        self.volume= [[aDecoder decodeObjectForKey:@"volume"] integerValue];
        
        self.isLike= [[aDecoder decodeObjectForKey:@"isLike"] boolValue];
        
    }
    
    return self;
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(self.category) forKey:@"category"];
    
    [aCoder encodeObject:@(self.num_iid) forKey:@"num_iid"];
    
    [aCoder encodeObject:self.commission_rate forKey:@"commission_rate"];
    
    [aCoder encodeObject:self.coupon_click_url forKey:@"coupon_click_url"];
    
    [aCoder encodeObject:self.coupon_end_time forKey:@"coupon_end_time"];
    
    [aCoder encodeObject:self.coupon_start_time forKey:@"coupon_start_time"];
    
    [aCoder encodeObject:self.coupon_info forKey:@"coupon_info"];
    
    [aCoder encodeObject:@(self.coupon_remain_count) forKey:@"coupon_remain_count"];
    
    [aCoder encodeObject:@(self.coupon_total_count) forKey:@"coupon_total_count"];
    
    [aCoder encodeObject:self.item_description forKey:@"item_description"];
    
    [aCoder encodeObject:self.item_url forKey:@"item_url"];
    
    [aCoder encodeObject:self.nick forKey:@"nick"];
    
    [aCoder encodeObject:self.pict_url forKey:@"pict_url"];
    
    [aCoder encodeObject:self.shop_title forKey:@"shop_title"];
    
    [aCoder encodeObject:self.small_images forKey:@"small_images"];
    
    [aCoder encodeObject:self.title forKey:@"title"];
    
    [aCoder encodeObject:self.zk_final_price forKey:@"zk_final_price"];
    
    [aCoder encodeObject:self.price forKey:@"price"];
    
    [aCoder encodeObject:@(self.user_type) forKey:@"user_type"];
    
    [aCoder encodeObject:@(self.seller_id) forKey:@"seller_id"];
    
    [aCoder encodeObject:@(self.volume) forKey:@"volume"];
    
    [aCoder encodeObject:@(self.isLike) forKey:@"isLike"];
}
@end
@implementation ASHCartInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"match_coupon":@"couponInfo.match_coupon",@"like_coupon":@"couponInfo.like_coupon"};
}
@end
