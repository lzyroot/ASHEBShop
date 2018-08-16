//
//  ASHCartJonParser.m
//  
//
//  Created by xmfish on 2018/7/30.
//  Copyright © 2018年 . All rights reserved.
//

#import "ASHCartJonParser.h"
#import <YYModel.h>
@protocol CartItemDo

@end

@interface CartItemDo : NSObject

@property(nonatomic, copy) NSString *num_iid;
@property(nonatomic, copy)  NSString *title_display;
@property(nonatomic, copy)  NSString *price;

@end

@implementation CartItemDo

@end

@interface ASHCartJonParser ()

/**
 * 商品信息列表  已排序
 */
@property(nonatomic, strong) NSMutableArray<CartItemDo> *list;
/**
 * 商品信息列表 未排序
 */
@property(nonatomic, strong) NSMutableDictionary *items;
/**
 * 商品群组列表
 */
@property(nonatomic, strong) NSMutableDictionary * groups;
/**
 * 商品包列表
 */
@property(nonatomic, strong) NSMutableDictionary *bundles;
/**
 * 商品包顺序列表
 */
@property(nonatomic, strong) NSMutableArray *allItemv;//
/**
 * 商品键值顺序列表
 */
@property(nonatomic, strong) NSMutableArray *itemKeys;//

@end

@implementation ASHCartJonParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.list = [NSMutableArray<CartItemDo> array];
        self.items = [NSMutableDictionary dictionary];
        self.groups = [NSMutableDictionary dictionary];
        self.bundles = [NSMutableDictionary dictionary];
        self.allItemv = [NSMutableArray array];
        self.itemKeys = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray *)cartPaser:(NSString*)resultStr {
    [self resetCacheData];
    if (resultStr.length == 0) return _list;
    
    NSString *json = resultStr;
    if (![json hasPrefix:@"{"])
        json = [json substringFromIndex:[json rangeOfString:@"{"].location];
    if (![json hasSuffix:@"}"])
        json = [json substringWithRange:NSMakeRange(0, [json rangeOfString:@"}" options:NSBackwardsSearch].location + 1)];//json = json.substring(0, json.lastIndexOf('}') + 1);
    NSDictionary *object = [NSDictionary dicWithString:json];
    
    [self readTbCartData:object ];
        
    NSMutableArray *itemList = [NSMutableArray array];
    for (CartItemDo * item in _list) {
        NSDictionary *dic = @{
                              @"num_iid" : @([[item num_iid] longLongValue]),
                              @"title_display":item.title_display ? :@"",
                              @"price": [NSString stringWithFormat:@"%.2f", [item.price floatValue]]
                              };
        [itemList addObject:dic];
    }
    return itemList;
}


/**
 * 重置缓存数据
 */
- (void)resetCacheData
{
    [_list removeAllObjects];
    [_items removeAllObjects];
    [_groups removeAllObjects];
    [_bundles removeAllObjects];
    [_allItemv removeAllObjects];
    [_itemKeys removeAllObjects];
}

/**
 * 读取淘宝购物车商品数据
 *
 * @param 
 */
- (void)readTbCartData:(NSDictionary *)object
{
    [self readJsonObject:object];//遍历获取 商品信息对象,  bundle顺序对象
    if (self.allItemv.count != 0) {//
        [self structuregAddItem];//
    } else {// 如果未找到排序规则字段，则按数据顺序排序取商品数据
        [self sequenceAddItem];
    }
    
}

/**
 * 按购物车商品顺序排序取商品数据
 */
- (void)structuregAddItem
{
   
        NSUInteger size = self.allItemv.count;
        // 获取购物车商品排序
        for (int i = 0; i < size; i++) {
                NSString *bundleKey = self.allItemv[i];
                NSArray *bundleArray = self.bundles[bundleKey];
            NSString *groupKey = [self readBundleArray:bundleArray];
                if (groupKey.length > 0) {
                    NSArray *groupArray = self.groups[groupKey];
                    [self readGroupArray:groupArray];
                }
           
        }
        
        if (self.items.count > 0) {
            NSUInteger keySize = self.itemKeys.count;
            if (keySize > 0) {
                for (int i = 0; i < keySize; i++) {
                    NSString *key = self.itemKeys[i];
                    NSDictionary *obj = self.items[key];
                    [self readCartItem:obj];
                }
                return;
            }
        } else {// 购物车无数据
            return;
        }
        
        
    
    [self.list removeAllObjects];
    [self sequenceAddItem];
    
}

/**
 * 获取数据群组键值
 *
 * @param bundleArray
 * @return
 */
- (NSString *)readBundleArray:(NSArray *)bundleArray
{
    NSString *key = @"";
    if (bundleArray != nil) {
        NSUInteger size = bundleArray.count;
        for (int i = 0; i < size; i++) {
            NSString *value = bundleArray[i];
            if (value.length > 0 && [value hasPrefix:@"group"]) {
                return value;
            }
            
        }
    }
    
    return key;
}

/**
 * 读取数据包，获取商品键值
 *
 * @param groupArray
 */
- (void)readGroupArray:(NSArray *) groupArray
{
    if (groupArray != nil) {
        NSUInteger size = groupArray.count;
        for (int i = 0; i < size; i++) {
            NSString *value = groupArray[i];
            if (value.length > 0 && [value hasPrefix:@"item"]) {
                [self.itemKeys addObject:value];
            }
        }
    }
}

/**
 * 按数据顺序排序取商品数据
 */
- (void) sequenceAddItem
{
    for (NSString *key in self.items.allKeys) {
        [self readCartItem:self.items[key]];
    }
}

/**
 * 读取数组
 * @param array
 */
- (void) readJsonArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        id obj = array[i];
        if ([obj isKindOfClass:[NSArray class]]) {
            [self readJsonArray:(NSArray *) obj];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [self readJsonObject:(NSDictionary *)obj];
        }
    }
}

/**
 * 读取对象
 * @param object
 */
- (void)readJsonObject:(NSDictionary *) object
{
    NSArray *allKeys = object.allKeys;
    for (NSString *key in allKeys) {
        id obj = object[key];
        if ([obj isKindOfClass:[NSArray class]]) {
            if ([key hasPrefix:@"data"]) {
                [self readJsonArray:(NSArray *) obj];
            } else if ([key hasPrefix:@"allItemv"]) {
                [self saveAllItemv:(NSArray *)obj];//saveAllItemv((JSONArray) obj);
            } else if ([key hasPrefix:@"group"]) {
                [self saveGroupData:key array:(NSArray *) obj];
            } else if ([key hasPrefix:@"bundle"]) {
                [self saveBundleData:key array:(NSArray *) obj];
            }
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([key hasPrefix:@"data"]) {// 数据结构键
                [self readJsonObject:(NSDictionary *) obj];
            } else if ([key hasPrefix:@"hierarchy"]) {// 层级结构键
                [self readJsonObject:(NSDictionary *) obj];
            } else if ([key hasPrefix:@"structure"]) {// 组织结构键
                [self readJsonObject:(NSDictionary *) obj];
            } else if ([key hasPrefix:@"item"]) {// 商品信息键
                [self saveItemJSONObject:key obj:(NSDictionary *) obj];
            }
        }
    }
   
}
                 
                 /**
                  * 保存商品包顺序
                  *
                  * @param obj
                  */
                 - (void)saveAllItemv:(NSArray *)obj
                 {
                     if (obj != nil) {
                         NSInteger size = obj.count;
                         for (int i = 0; i < size; i++) {
                             NSString *bundleKey = obj[i];
                             if (bundleKey != nil && [bundleKey hasPrefix:@"bundle"]) {
                                 [self.allItemv addObject:bundleKey];
                             }
                         }
                     }
                 }
                 
                 /**
                  * 保存数据包数据
                  *
                  * @param key
                  * @param array 数据包
                  */
                 -(void)saveBundleData:(NSString *) key array:(NSArray *) array
                 {
                     if (key.length == 0) return;
                     if (array != nil) {
                        self.bundles[key] =  array;
                     }
                
                 }
                 
                 /**
                  * 保存数据群组数据
                  *
                  * @param key   键值
                  * @param array 数据群组
                  */
                 - (void) saveGroupData:(NSString*)key array:(NSArray *) array
                {
                         if (key.length == 0) return;
                         if (array != nil)
                             self.groups[key] = array;
                }
                 
                 /**
                  * 保存商品对象键值对
                  *
                  * @param key
                  * @param obj
                  */
                 - (void) saveItemJSONObject:(NSString *) key obj:(NSDictionary *)obj
                 {
                         if (key.length == 0) return;
                         if (obj != nil)
                             self.items[key] = obj;
                
                 }
                 /**
                  * 读取商品信息
                  * @param obj
                  */
- (void) readCartItem:(NSDictionary *) obj {
                     if (obj == nil) return;
                     CartItemDo *itemDo = [[CartItemDo alloc] init];
                     
                     
                     if ([obj.allKeys containsObject:@"fields"]) {
                             NSDictionary *fields = obj[@"fields"];
                             if (fields != nil) {
                                 if ([fields.allKeys containsObject:@"itemId"])
                                     itemDo.num_iid = fields[@"itemId"];//EcoStringUtils.getJsonString(fields, "itemId");
                                 if ([fields.allKeys containsObject:@"title"])
                                     itemDo.title_display = fields[@"title"];
                                 if ([fields.allKeys containsObject:@"pay"]) {
                                         NSDictionary *pay = fields[@"pay"];
                                         if (pay != nil && [pay.allKeys containsObject:@"nowTitle"]) {
                                             NSString *now =pay[@"nowTitle"];
                                             if (now.length > 0 && [now hasPrefix:@"￥"])
                                                 now = [now substringFromIndex:1];
                                             itemDo.price = now;
                                         }
                                     
                                 }
                                 
                             }
                        
                     }
                     //TextUtils.isEmpty(num_iid)&&TextUtils.isEmpty(title_display)
                     if (itemDo.num_iid.length > 0 && itemDo.title_display.length > 0)
                         [self addCartItem:itemDo];
                 }
                 
                 /**
                  * 添加商品信息
                  * @param itemDo
                  */
                 - (void) addCartItem:(CartItemDo* ) itemDo {
                  
                     if (itemDo) {
                        [self.list addObject:itemDo];
                     }
                     
                 }



@end
