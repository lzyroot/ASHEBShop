//
//  ASHEBHomeViewController.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHEBHomeViewController.h"
#import "ASHSearchButton.h"
#import "ASHPageViewController.h"
#import "ASHNewsSegmentedView.h"
#import "ASHCategoryListVC.h"
#import "ASHTabViewModel.h"
#import "ASHTabManager.h"
#import "ASHTabCategoryView.h"
#import "ASHEBCategoryVC.h"
#import "ASHEBCategory2VC.h"
@interface ASHEBHomeViewController ()<ASHPageViewControllerDelegate,ASHPageViewControllerDataSource,UIScrollViewDelegate,ASHNewsSegmentedViewDataSource,ASHNewsSegmentedViewDelegate>
@property(nonatomic, strong)ASHPageViewController* pageViewController;
@property (nonatomic, strong) ASHNewsSegmentedView *segmentView;
@property(nonatomic, copy)NSMutableArray* vcArr;
@property(nonatomic, copy)NSMutableArray* titleArr;
@property(nonatomic, copy)NSMutableArray* idArr;

@end

@implementation ASHEBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBar];
    
    if ([ASHTabManager shareInstance].model) {
        [self setupData];
    }else{
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kASH_Post_Tab object:nil] subscribeNext:^(id x) {
            @strongify(self);
            [self setupData];
        }];
    }
    
}
- (void)setupData{
    [self initData];
    [self.view addSubview:self.segmentView];
    [self.segmentView reload];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.pageViewController.view.ash_top = 38;
    self.pageViewController.view.ash_height -= 38;
    
}

- (void)setupBar{
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 30)];

    
    ASHSearchButton* button = [[ASHSearchButton alloc] initWithFrame:CGRectMake(10, 0, ASHScreenWidth - 75, 30)];
    [titleView addSubview:button];
    
    UIButton* cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cartButton.frame = CGRectMake(0, 7, 16, 16);
    [cartButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    cartButton.backgroundColor = [UIColor clearColor];
    cartButton.ash_right = titleView.ash_width - 30;
    [titleView addSubview:cartButton];
    
    self.navigationItem.titleView = titleView;
    self.navigationItem.title = @"";
}

-(void)initData{
    _titleArr = [NSMutableArray array];
    _idArr = [NSMutableArray array];
    _vcArr = [NSMutableArray array];
    for (ASHTabItemModel* model in [ASHTabManager shareInstance].model.tab_elementArr) {
        [_titleArr addObject:model.name];
        [_idArr addObject:@(model.tab_id)];
    }
    for (NSString* type in _idArr) {
        UIViewController* vc;
        if ([type integerValue] == 0) {
            vc = [ASHEBCategoryVC new];
        }else{
            vc = [ASHEBCategory2VC new];
            [(ASHEBCategory2VC*)vc setCategoryId:[type integerValue]];
        }
        
        [_vcArr addObject:vc];
    }
}
- (ASHNewsSegmentedView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[ASHNewsSegmentedView alloc] initWithFrame:CGRectMake(0, 0, self.view.ash_width, 38.0)];
        _segmentView.dataSource = self;
        _segmentView.delegate = self;
        _segmentView.titleFont = [UIFont systemFontOfSize:14];
        _segmentView.titleSelectFont = [UIFont systemFontOfSize:14];
        _segmentView.indicatorWidth = 80;
        if (_vcArr.count <= 4) {
            _segmentView.indicatorWidth = 100;
        }
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3]];
        [_segmentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_segmentView);
            make.height.mas_equalTo(0.7);
        }];
        
    }
    return _segmentView;
}
- (ASHPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        _pageViewController = [[ASHPageViewController alloc] init];
        [_pageViewController.view setBackgroundColor:[UIColor whiteColor]];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        _pageViewController.scrollViewForwardDelegate = self;
    }
    return _pageViewController;
}
#pragma mark ASHPageViewControllerDataSource
- (NSUInteger)numberOfControllersInPageViewController:(ASHPageViewController *)pageViewController{
    return _vcArr.count;
}
- (UIViewController* )pageViewController:(ASHPageViewController *)pageViewController controllerAtIndex:(NSUInteger)index{
    return _vcArr[index];
}
#pragma mark ASHPageViewControllerDelegate
- (void)pageViewController:(ASHPageViewController *)pageViewController didTransitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    [self.segmentView setCurrentIndex:toIndex];
}
- (void)pageViewController:(ASHPageViewController *)pageViewController willTransitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    
}
#pragma mark ASHNewsSegmentedViewDataSource
- (void)ASHNewsSegmentedCategoryClick:(id)sender
{
    [ASHTabCategoryView show];
}
- (NSUInteger)numberOfSegmentedViews:(id)sender{
    return _vcArr.count;
}
- (NSString*)titleForSegmentedView:(id)sender index:(NSUInteger)index{
    return _titleArr[index];
}
- (CGFloat)segmentedViewWidth:(id)sender index:(NSUInteger)index
{
    if ([_titleArr[index] length] > 2) {
        return 100.0;
    }
    return 80;
}
#pragma mark ASHNewsSegmentedViewDelegate
- (void)ASHNewsSegmentedViewDidSelect:(id)sender index:(NSUInteger)index
{
    if (self.segmentView.currentIndex == index) {
        return;
    }
    [self.pageViewController setViewControllerAtIndex:index animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
