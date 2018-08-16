//
//  ASHShopCartURLProtocol.h
//
//
//  Created by  on 2018/7/29.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ASHShopCartURLProtocol : NSURLProtocol<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;

@end
