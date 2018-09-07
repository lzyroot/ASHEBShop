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
#import "ASHCartViewModel.h"
#import "ASHCouponViewController.h"
@interface ASHWebCartViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIButton* loginBtn;
@property(nonatomic,strong)UIView* backView;
@property(nonatomic, strong) UIWebView* webView;
@property(nonatomic, strong) ASHCartJonParser* parser;
@property(strong, nonatomic) ASHLoadView *loadingView;
@property(nonatomic, strong)ASHCartViewModel* viewModel;
@property(nonatomic, strong)UIButton* refreshBtn;
@property(nonatomic, strong)UILabel* totalCountlabel;
@property(nonatomic, strong)UILabel* totalPricelabel;
@property(nonatomic, strong)UIButton* cartInfoBtn;
@property(nonatomic, strong)NSArray* cartArr;
@end

@implementation ASHWebCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lineColor];
    
    self.navigationItem.title = @"购物车";
    ALBBSession *session = [ALBBSession sharedInstance];
    if ([session isLogin]) {
        [self setupWebView];
    }else{
        [self setNoLogin];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onQueryBagFinish:) name:kASHTaobaoQueryBagFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kASHTaobaoQLoginSuccess object:nil];
    self.viewModel = [ASHCartViewModel new];
    
    
    [self setupCartInfo];


}
- (void)loginSuccess{
    if (!_webView) {
        [self setupWebView];
        
    }
}
#pragma mark CartInfo

- (void)setupCartInfo{
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 60)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor mainColor];
    view.ash_bottom = self.view.ash_height-64;
    if (_shouldBottom) {
        view.ash_bottom = self.view.ash_height - 64 - 49;
    }
    [self.view addSubview:view];
    
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshBtn setImage:[UIImage imageNamed:@"cartrefresh"] forState:UIControlStateNormal];
    self.refreshBtn.frame = CGRectMake(25, 0, 16, 16);
    self.refreshBtn.ash_centerY = view.ash_height / 2;
    self.refreshBtn.userInteractionEnabled = YES;
    [self.refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.refreshBtn];
    
    self.totalCountlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.ash_width, view.ash_height)];
    self.totalCountlabel.ash_left = self.refreshBtn.ash_right + 10;
    self.totalCountlabel.ash_centerY = view.ash_height / 2;
    self.totalCountlabel.backgroundColor = [UIColor clearColor];
    self.totalCountlabel.ash_width = view.ash_width - 60 - (self.refreshBtn.ash_right + 10);
    
    self.totalCountlabel.textColor = [UIColor whiteColor];
    
    [view addSubview:self.totalCountlabel];
    
    self.cartInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cartInfoBtn.frame = CGRectMake(25, 0, 70, 30);
    self.cartInfoBtn.backgroundColor = [UIColor colorWithHex:0xf3b431 alpha:1.0];
    self.cartInfoBtn.ash_centerY = view.ash_height / 2;
    self.cartInfoBtn.ash_right = view.ash_width - 10;
    self.cartInfoBtn.layer.cornerRadius = 15;
    self.cartInfoBtn.layer.masksToBounds = YES;
    [self.cartInfoBtn setTitle:@"去领券" forState:UIControlStateNormal];
    self.cartInfoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.cartInfoBtn addTarget:self action:@selector(cartInfoBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.cartInfoBtn];
    
    [self setCount:0 price:0];
    [self startRefreshAnimation];
}
- (void)cartInfoBtnclick:(UIButton*)button
{
    ASHCouponViewController* vc = [ASHCouponViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshBtnClick:(UIButton*)button{
    [self startRefreshAnimation];
    [self requestWith:self.cartArr withIndex:0];
}
- (void)setCount:(NSInteger)count price:(NSInteger)price{
    self.totalCountlabel.text = [NSString stringWithFormat:@"发现 %ld 张优惠券 可省 %ld 元",count,price];
}
- (void)startRefreshAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                   //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
                                   animation.fromValue = [NSNumber numberWithFloat:0.f];
                                   animation.toValue = [NSNumber numberWithFloat: M_PI *2];
                                   animation.duration = 2;
                                   animation.autoreverses = NO;
                                   animation.fillMode = kCAFillModeForwards;
                                   animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
                                   [self.refreshBtn.layer addAnimation:animation forKey:@"refreshBtn"];
}
- (void)stopRefreshAnimation{
    [self.refreshBtn.layer removeAnimationForKey:@"refreshBtn"];
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
        }else{
            NSArray* array = paramsDic[@"itemList"];
            self.cartArr = array;
            [self requestWith:array withIndex:0];
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
- (void)requestWith:(NSArray*)array withIndex:(NSInteger)index{
    if (index >= array.count) {
        [self stopRefreshAnimation];
        return;
    }
    @weakify(self);
    {
        NSDictionary* dic = array[index];
        if ([[ASHCouponManager shareInstance] hasCacheCoupon:[dic[@"num_iid"] integerValue]]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setCount:[ASHCouponManager shareInstance].couponArr.count price:[[ASHCouponManager shareInstance] totalPrice]];
            });
            [self requestWith:array withIndex:index+1];
            return;
        }
        [_viewModel.requestFinishedSignal subscribeNext:^(id x) {
            @strongify(self);
            if (index < array.count) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self requestWith:array withIndex:index+1];
                });
                
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setCount:[ASHCouponManager shareInstance].couponArr.count price:[[ASHCouponManager shareInstance] totalPrice]];
            });
        }];
        
        [_viewModel requestHomeDataWithNumId: [dic[@"num_iid"] integerValue] title:dic[@"title_display"] price:dic[@"price"]];
        
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
        if (_shouldBottom) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,ASHScreenWidth,ASHScreenHeight-60-64-49)];
        }else{
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,ASHScreenWidth,ASHScreenHeight-60-64)];
        }
        
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
