//
//  ASHCouponWebVC.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/4.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCouponWebVC.h"
#import <WebKit/WebKit.h>
#import "FeThreeDotGlow.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
@interface ASHCouponWebVC ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
@property(nonatomic, strong) WKWebView* wkWebView;
@property(nonatomic, strong)NSString* itemId;
@property(nonatomic, assign)BOOL isfinish;
@property (strong, nonatomic) FeThreeDotGlow *threeDot;
@end

@implementation ASHCouponWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lineColor];
    
    [self.view addSubview:self.wkWebView];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.couponUrl]]];
    self.isfinish = NO;
    [MobClick event:@"couponpage"];
    
    _threeDot = [[FeThreeDotGlow alloc] initWithView:self.view blur:NO];
    [self.view addSubview:_threeDot];
    [_threeDot show];
}
- (NSString *)filterHtmlString:(NSString *)htmlString{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:htmlString];
    [theScanner scanUpToString:@"<div id=\"downloadBar\">" intoString:NULL];
    [theScanner scanUpToString:@"</body>" intoString:&text];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:text withString:@""];
    return htmlString;
}

-(WKWebView*)wkWebView{
    
    if (!_wkWebView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        // 设置偏好设置
        
        config.preferences = [[WKPreferences alloc] init];
        
        // 默认为0
        
        config.preferences.minimumFontSize = 10;
        
        // 默认认为YES
        
        config.preferences.javaScriptEnabled = YES;
        
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // web内容处理池
        
//        config.processPool = [ProcessPool sharedProcessPool].wkProcessPool;
        
        
        
        // 通过JS与webview内容交互
        
//        config.userContentController = [[WKUserContentController alloc] init];
        
        // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
        
        // 我们可以在WKScriptMessageHandler代理中接收到
        
//        [config.userContentController addScriptMessageHandler:self name:@"webViewApp"];
        
        
        
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,ASHScreenWidth,ASHScreenHeight)
                          
                                            configuration:config];
        self.wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
//        self.wkWebView.scrollView.delegate = self;
        self.wkWebView.backgroundColor = [UIColor lineColor];
        [self.view addSubview:self.wkWebView];
        
        // 导航代理
        
        self.wkWebView.navigationDelegate = self;
        
        // 与webview UI交互代理
        
        self.wkWebView.UIDelegate = self;
        
//        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
        
        //开启手势触摸
        
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        
        // 设置 可以前进 和 后退
        
        //适应你设定的尺寸
        
        [_wkWebView sizeToFit];
        
        
    }
    
    return _wkWebView;
    
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString* doct = @"document.getElementById( \"downloadBar\").style.display= \"none\"";
        [webView evaluateJavaScript:doct completionHandler:^(id _Nullable html, NSError * _Nullable error) {
            NSLog(@"html--:%@",html);
        }];
    });
    
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //获取整个网页的HTML代码
    
    NSString *doc =@"document.body.outerHTML";
    
    [webView evaluateJavaScript:doc
     
              completionHandler:^(id htmlStr,NSError *  error) {

                  
                  NSLog(@"html--:%@",htmlStr);
                  
              }] ;
    @weakify(self);
    [webView evaluateJavaScript:@"document.getElementById(\"itemId\").value;" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        @strongify(self);
        self.itemId = value;
    }];
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.navigationItem.title = title;
        });
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString* doct = @"document.getElementById( \"downloadBar\").style.display= \"none\"";
        [webView evaluateJavaScript:doct completionHandler:^(id _Nullable html, NSError * _Nullable error) {
            NSLog(@"html--:%@",html);
        }];
    });
    
    self.isfinish = YES;
    [_threeDot dismiss];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString* url = navigationAction.request.URL.absoluteString;
    if ([url containsString:@"http://m.sqkb.com/coupon/"] && self.isfinish == YES) {
        ASHCouponWebVC* webVC = [ASHCouponWebVC new];
        webVC.couponUrl = url;
        [self.navigationController pushViewController:webVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    
    if ([url containsString:@"uland.taobao.com/coupon/edetail"] || [url containsString:@"h5.m.taobao.com/awp/core/detail.htm"]) {
        AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
        showParam.openType = AlibcOpenTypeNative;
        id<AlibcTradePage> page = [AlibcTradePageFactory page:url];
        [[AlibcTradeSDK sharedInstance].tradeService show: self page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
            
        } tradeProcessFailedCallback:^(NSError * _Nullable error) {
            NSLog(@"%@", [error description]);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;

    }
    //允许跳转
    if ([url hasPrefix:@"sqkb"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}
- (void)dealloc
{
    
}
@end
