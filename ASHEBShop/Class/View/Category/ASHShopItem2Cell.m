//
//  ASHShopItem2Cell.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/3.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHShopItem2Cell.h"
#import "ASHTopicModel.h"
@interface ASHShopItem2Cell()
@property (weak, nonatomic) IBOutlet UIView *shopView1;
@property (weak, nonatomic) IBOutlet UIView *shopView2;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView1;
@property (weak, nonatomic) IBOutlet UILabel *oriPriceLabel1;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice1;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel1;
@property (weak, nonatomic) IBOutlet UILabel *vipCountLabel1;
@property (weak, nonatomic) IBOutlet UIButton *shopButton1;
@property (weak, nonatomic) IBOutlet UIButton *shopButton2;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *oriPriceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *vipPriceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel2;
@property (weak, nonatomic) IBOutlet UILabel *vipCountLabel2;
@property (nonatomic, strong)ASHCouponInfoModel* model;
@property (nonatomic, strong)ASHCouponInfoModel* model2;
@end
@implementation ASHShopItem2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ASHCouponInfoModel *)model secondModel:(ASHCouponInfoModel *)model2
{

    [self.shopImageView1 sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_pic]];
    if (model.post_free) {
        self.titleLabel1.text = [NSString stringWithFormat:@"         %@",model.title];
        self.couponImageView1.hidden = NO;
    }else{
        self.titleLabel1.text = model.title;
        self.couponImageView1.hidden = YES;
    }
    self.oriPriceLabel1.text = [NSString stringWithFormat:@"原价¥%@",model.raw_price];
    self.vipPrice1.text = [NSString stringWithFormat:@"券后¥%@",model.zk_price];
    if (model.month_sales < 10000) {
        _saleCountLabel1.text = [NSString stringWithFormat:@"月销%ld",model.month_sales];
    }else{
        _saleCountLabel1.text = [NSString stringWithFormat:@"月销%.1f万",model.month_sales/10000.0];
    }
    _vipCountLabel1.text = [NSString stringWithFormat:@"%ld元券",[model.raw_price integerValue] - [model.zk_price integerValue]];
    
    if (!model2) {
        self.shopView2.hidden = YES;
        self.shopButton2.hidden = YES;
    }else{
        self.shopView2.hidden = NO;
        self.shopButton2.hidden = NO;
        [self.shopImageView2 sd_setImageWithURL:[NSURL URLWithString:model2.thumbnail_pic]];
        if (model2.post_free) {
            self.titleLabel2.text = [NSString stringWithFormat:@"         %@",model2.title];
            self.couponImageView1.hidden = NO;
        }else{
            self.titleLabel2.text = model2.title;
            self.couponImageView2.hidden = YES;
        }
        self.oriPriceLabel2.text = [NSString stringWithFormat:@"原价¥%@",model2.raw_price];
        self.vipPriceLabel2.text = [NSString stringWithFormat:@"券后¥%@",model2.zk_price];
        if (model2.month_sales < 10000) {
            _saleCountLabel2.text = [NSString stringWithFormat:@"月销%ld",model2.month_sales];
        }else{
            _saleCountLabel2.text = [NSString stringWithFormat:@"月销%.1f万",model2.month_sales/10000.0];
        }
        _vipCountLabel2.text = [NSString stringWithFormat:@"%ld元券",[model2.raw_price integerValue] - [model2.zk_price integerValue]];
    }
    _model = model;
    _model2 = model2;
    
}
- (IBAction)itemBtnClick:(UIButton*)button {
    if (self.itemClickAction) {
        if (button.tag == 1) {
            self.itemClickAction(_model);
        }else{
            self.itemClickAction(_model2);
        }
        
    }
}

@end
