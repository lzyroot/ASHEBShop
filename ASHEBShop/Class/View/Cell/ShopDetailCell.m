//
//  ShopDetailCell.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/21.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ShopDetailCell.h"
#import "ASHShopDetailModel.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
@interface ShopDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConst;

@end
@implementation ShopDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.shadowColor = [UIColor lightGrayColor];
    self.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    _priceLabel.textColor = [UIColor mainColor];
    _buyBtn.layer.masksToBounds = YES;
    _buyBtn.layer.cornerRadius = 5.0;
    _buyBtn.layer.borderWidth = 1.0;
    _buyBtn.layer.borderColor = [UIColor mainColor].CGColor;
    [_buyBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor mainColor] forState:UIControlStateHighlighted];
    _shopImageView.layer.masksToBounds = YES;
    _shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageConst.constant = 180;
}
- (void)setModel:(ASHShopDetailItemModel *)model{
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"    %@",model.title];
    self.contentLabel.text = model.content;
    self.priceLabel.text = model.price;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (IBAction)buyBtnAction:(id)sender {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = keyWindow.rootViewController;
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeAuto;
    id<AlibcTradePage> page = [AlibcTradePageFactory page: _model.goodsUrl];
    [[AlibcTradeSDK sharedInstance].tradeService show: rootViewController page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        NSLog(@"%@", [error description]);
    }];
}

- (CGFloat)cellHeight
{
    CGSize titleSize = [self.textLabel.text boundingRectWithSize:CGSizeMake(self.textLabel.ash_size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textLabel.font} context:nil].size;
    
    CGSize contentSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.contentLabel.ash_size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil].size;
    
    return titleSize.height + contentSize.height + _imageConst.constant +120;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
