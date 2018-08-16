//
//  EBShopCartURLProtocol.m
//  IMYEBCoupon
//
//  Created by laozhenqiang on 2018/7/29.
//  Copyright © 2018年 MEB. All rights reserved.
//

#import "ASHShopCartURLProtocol.h"

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";
static NSString *const kHTTPHeaderField = @"ASH-WebView-Taobaocart-Caching";

@implementation ASHShopCartURLProtocol

+ (void)load
{
    [NSURLProtocol  registerClass:[ASHShopCartURLProtocol class]];
    id contextController = NSClassFromString([NSString stringWithFormat:@"%@%@%@",@"WK",@"Browsing",@"ContextController"]);
    SEL registerSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@",@"register",@"SchemeFor",@"CustomProtocol:"]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([contextController respondsToSelector:registerSEL]) {
        [contextController performSelector:registerSEL withObject:@"http"];
        [contextController performSelector:registerSEL withObject:@"https"];
    }
    
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *taobaoBagUrl = @"https://acs.m.taobao.com/h5/mtop.trade.querybag";
    
    
    NSString* UA = [request valueForHTTPHeaderField:@"User-Agent"];
    if ([UA containsString:@" AppleWebKit/"] == NO) {
        return NO;
    }
    
    if ([request valueForHTTPHeaderField:kHTTPHeaderField]) {
        return NO;
    }
    
    if ([request.URL.absoluteString containsString:taobaoBagUrl]) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *req = [self.request mutableCopy];
    //[IMYMeetyouHTTPHooks willRequestHook:req];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:req.URL];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    // NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    
    [req addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    [req setValue:@"ash" forHTTPHeaderField:kHTTPHeaderField];
    self.connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    self.data = [[NSMutableData alloc] init];
}

- (void)stopLoading
{
    [_connection cancel];
    self.connection = nil;
}

#pragma mark - NSURLConnectionDataDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response {
    if (response) {
        [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kASHTaobaoQueryBagFinishNotification object:_data userInfo:@{@"data":_data?:@""}];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [self.client URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

@end
