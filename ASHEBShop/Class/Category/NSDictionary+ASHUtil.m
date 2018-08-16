//
//  NSDictionary+ASHUtil.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/16.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "NSDictionary+ASHUtil.h"

@implementation NSDictionary (ASHUtil)
+ (NSDictionary *)dicWithString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
