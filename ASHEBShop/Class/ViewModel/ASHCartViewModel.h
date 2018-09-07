//
//  ASHCartViewModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/9/4.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"

@interface ASHCartViewModel : ASHBaseViewModel
@property(nonatomic, strong)NSMutableArray* couponArr;//
- (void)requestHomeDataWithNumId:(NSInteger)num_iid title:(NSString*)title price:(NSString*)price;

@end
