//
//  ASHShopItem1Cell.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHShopItem1Cell.h"
#import "ASHCategoryModel.h"
#import "ASHTopicModel.h"
@interface ASHShopItem1Cell()
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipPricelabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipNumLabel;
@property (nonatomic, strong)ASHTopicItemModel* model;

@end
@implementation ASHShopItem1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _shopImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ASHTopicItemModel *)model
{
    _model = model;
    _shopTitleLabel.text = model.title;
    _shopTagLabel.text = model.coupon_info.mydescription;
    _originPriceLabel.text = [NSString stringWithFormat:@"原价 ¥%@",model.coupon_info.raw_price];
    _vipPricelabel.text = [NSString stringWithFormat:@"¥%@",model.coupon_info.zk_price];
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    
    if (model.month_sales < 10000) {
        _shopNumLabel.text = [NSString stringWithFormat:@"月销%ld",model.month_sales];
    }else{
        _shopNumLabel.text = [NSString stringWithFormat:@"月销%.1f万",model.month_sales/10000.0];
    }
    
    _vipNumLabel.text = [NSString stringWithFormat:@"%ld元券",[model.coupon_info.raw_price integerValue] - [model.coupon_info.zk_price integerValue]];
    
    if (model.coupon_info.product_type == 2) {
        _tipsImageView.image = [UIImage imageNamed:@"small_zhe_kou.png"];
        if ([model.coupon_info.discount integerValue] >= 10) {
            _vipNumLabel.text = @"立即抢购";
        }else{
           _vipNumLabel.text = [NSString stringWithFormat:@"%@折",model.coupon_info.discount];
        }
    }else{
        _tipsImageView.image = [UIImage imageNamed:@"small_quan_hou.png"];
        _vipNumLabel.text = [NSString stringWithFormat:@"%ld元券",[model.coupon_info.raw_price integerValue] - [model.coupon_info.zk_price integerValue]];
    }
}
@end
