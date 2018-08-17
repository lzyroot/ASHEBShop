//
//  ASHWebCartViewController.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/16.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHWebCartViewController.h"
#import "ASHCartJonParser.h"
#import <WebKit/WebKit.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import "ASHLoadView.h"
@interface ASHWebCartViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIButton* loginBtn;
@property(nonatomic,strong)UIView* backView;
@property(nonatomic, strong) UIWebView* webView;
@property(nonatomic, strong) ASHCartJonParser* parser;
@property(strong, nonatomic) ASHLoadView *loadingView;

@end

@implementation ASHWebCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lineColor];
    
    ALBBSession *session = [ALBBSession sharedInstance];
    if ([session isLogin]) {
        [self setupWebView];
    }else{
        [self setNoLogin];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onQueryBagFinish:) name:kASHTaobaoQueryBagFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kASHTaobaoQLoginSuccess object:nil];
}
- (void)loginSuccess{
    if (!_webView) {
        [self setupWebView];
    }
}
#pragma mark taobaodata
- (void)onQueryBagFinish:(NSNotification *)notification
{
    NSData *data = notification.userInfo[@"data"];
    if ([data isKindOfClass:[NSData class]]) {
        [self handleTaobaoCartData:data];
    }
}

- (void)handleTaobaoCartData:(NSData *)data
{
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSInteger type = 0;
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    paramsDic[@"type"] = @(type);
    if (type == 0) {
        paramsDic[@"itemList"] = [self.parser cartPaser:jsonStr];//[self itemArrayFromCartData:jsonDic];
        if ([paramsDic[@"itemList"] count] == 0) {
            return;
        }
    }
    else {
        NSRange range = [jsonStr rangeOfString:@"("];
        NSString *str1 = [jsonStr substringFromIndex:range.location + 1];
        jsonStr = [str1 substringToIndex:[str1 length] - 1];
        paramsDic[@"typeMessage"] = jsonStr ? : @"";
        if ([paramsDic[@"typeMessage"] length] == 0) {
            return;
        }
    }
}
- (void)setCartVC:(UIViewController *)cartVC webView:(UIWebView *)webView {
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeAuto;
    AlibcTradeTaokeParams *taoKeParams = [[AlibcTradeTaokeParams alloc] init];
    taoKeParams.pid = kASH_TAOBAO_PID;
    id<AlibcTradePage> page = [AlibcTradePageFactory myCartsPage];
    [[AlibcTradeSDK sharedInstance].tradeService show:cartVC
                                              webView:webView
                                                 page:page
                                           showParams:showParam
                                          taoKeParams:taoKeParams
                                           trackParam:nil
                          tradeProcessSuccessCallback:nil
                           tradeProcessFailedCallback:^(NSError *error) {
                               
                           }];
    
}
- (void)setupWebView
{
    _parser = [ASHCartJonParser new];
    [self.view addSubview:self.webView];
    [self setCartVC:self webView:self.webView];
    _loadingView = [ASHLoadView new];
    _loadingView.ash_top = 100;
    _loadingView.ash_centerX = self.view.ash_width / 2;
    [self.view addSubview:_loadingView];
    [_loadingView show];
    
}
- (void)setNoLogin{
    _backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_backView];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 106, 106)];
    imageView.image = [UIImage imageNamed:@"icon_page_nodata_empty"];
    imageView.ash_centerX = self.view.ash_width / 2;
    [_backView addSubview:imageView];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.text = @"授权淘宝登录，一键查看优惠券信息";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.ash_centerX = self.view.ash_width / 2;
    label.ash_top = imageView.ash_bottom + 10;
    [_backView addSubview:label];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(0, 400, 240, 44);
    _loginBtn.ash_centerX = self.view.ash_width / 2;
    _loginBtn.backgroundColor = [UIColor mainColor];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius =  22;
    _loginBtn.ash_top = label.ash_bottom + 20;
    [_backView addSubview:_loginBtn];
    @weakify(self);
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self setupWebView];
            

        });
    }];
}
-(UIWebView*)webView{
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,ASHScreenWidth,ASHScreenHeight)];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,ASHScreenWidth,ASHScreenHeight)];
        _webView.delegate = self;

        
    }
    return _webView;
    
}
#pragma mark - WKNavigationDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
                        
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingView hide];
}
- (void)dealloc
{
    
}

@end
