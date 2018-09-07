//
//  ShopItemCell.m
//  ASHEBShop
//
//  Created by xmfish on 17/3/15.
//  Copyright © 2017年 ash. All rights reserved.
//

#import "ShopItemCell.h"
#import "UILabel+ASHUtil.h"
#import "ASHHomeModel.h"
#import "UIColor+CustomColor.h"
#import <ReactiveCocoa.h>

@interface ShopItemCell()
@property (weak, nonatomic) IBOutlet UIView *shopContentView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *oriPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *couponBtn;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailRight;

@end
@implementation ShopItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    self.shopContentView.backgroundColor = [UIColor whiteColor];
//    self.shopContentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.8];
    self.shopContentView.layer.masksToBounds = YES;
    self.shopContentView.layer.cornerRadius = 5.0;
    
    self.couponTextLabel.layer.masksToBounds = YES;
    self.couponTextLabel.layer.cornerRadius = 3.0;
    self.couponTextLabel.layer.borderWidth = 1.0;
    self.couponTextLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.shopContentView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.shopContentView.layer.shadowRadius = 2;
//    self.shopContentView.layer.shadowOpacity = 1.0;
//    self.shopContentView.layer.shadowColor = [UIColor colorWithWhite:0.6 alpha:0.8].CGColor;
    
    @weakify(self);
    [[self.couponBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.couponAction) {
            self.couponAction(self.model);
        }
    }];
    
    self.titleLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ASHHomeItemModel *)model
{
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.content;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price];
    self.oriPriceLabel.text = [NSString stringWithFormat:@"%.2f", model.oldPrice];
    [self.oriPriceLabel ash_labelByStrikeline];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"¥%ld",(NSInteger)(model.oldPrice-model.price)];
    if (model.couponUrl) {
        self.couponView.hidden = NO;
        self.detailRight.constant = 8;
    }else{
        self.couponView.hidden = YES;
        self.detailRight.constant = -72;
    }
    _model = model;
}
- (void)setDetailModel:(ASHCartDetailModel*)model{
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.title;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.pict_url]];


    NSRange start = [model.coupon_info rangeOfString:@"减"];
    NSString* couponPrice = [model.coupon_info substringWithRange:NSMakeRange(start.location + 1, model.coupon_info.length-1 - start.location-1)];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"¥%@",couponPrice];
    
    self.oriPriceLabel.text = [NSString stringWithFormat:@"%.2f", [model.zk_final_price floatValue]];
    [self.oriPriceLabel ash_labelByStrikeline];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", [model.zk_final_price floatValue] - [couponPrice floatValue]];
    
    self.couponView.userInteractionEnabled = NO;
}
@end
