//
//  ASHCategoryVC.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCategoryVC.h"
#import "ASHPageViewController.h"
#import "ViewController.h"
#import "ASHNewsSegmentedView.h"
#import "ASHCategoryListVC.h"
#import <Masonry.h>
@interface ASHCategoryVC ()<ASHPageViewControllerDelegate,ASHPageViewControllerDataSource,UIScrollViewDelegate,ASHNewsSegmentedViewDataSource,ASHNewsSegmentedViewDelegate>
@property(nonatomic, strong)ASHPageViewController* pageViewController;
@property (nonatomic, strong) ASHNewsSegmentedView *segmentView;
@property(nonatomic, copy)NSMutableArray* vcArr;
@property(nonatomic, copy)NSMutableArray* titleArr;
@property(nonatomic, copy)NSMutableArray* idArr;
@end

@implementation ASHCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类";
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.pageViewController.view.ash_top = 45;
    self.pageViewController.view.ash_height -= 44;
    
    
    [self initData];
    
    [self.view addSubview:self.segmentView];
    [self.segmentView reload];
    
}
-(void)initData{
    _titleArr = [NSMutableArray arrayWithArray:@[@"全部",@"精选",@"女装",@"家居家装",@"数码家电",@"母婴",@"美食",@"鞋包配饰",@"美妆个护",@"男装",@"运动户外"]];
    _idArr = [NSMutableArray arrayWithArray:@[@"0",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"12",]];
    _vcArr = [[NSMutableArray alloc] init];
    for (NSString* type in _idArr) {
        ASHCategoryListVC* vc = [ASHCategoryListVC new];
        vc.goodsTypeId = type.integerValue;
        [_vcArr addObject:vc];
    }
}
- (ASHNewsSegmentedView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[ASHNewsSegmentedView alloc] initWithFrame:CGRectMake(0, 0, self.view.ash_width, 44.0)];
        _segmentView.dataSource = self;
        _segmentView.delegate = self;
        _segmentView.titleFont = [UIFont systemFontOfSize:17];
        _segmentView.titleSelectFont = [UIFont systemFontOfSize:17];
        _segmentView.indicatorWidth = 80;
        if (_vcArr.count <= 4) {
            _segmentView.indicatorWidth = 100;
        }
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
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
