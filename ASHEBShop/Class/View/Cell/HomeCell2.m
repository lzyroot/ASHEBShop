//
//  HomeCell2.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "HomeCell2.h"
@interface HomeCell2()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end
@implementation HomeCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentImageView ash_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(4.0, 4.0) viewRect:CGRectMake(0, 0, ASHScreenWidth - 20, self.contentImageView.bounds.size.height)];
//    self.likeCountLabel.shadowColor = [UIColor blackColor];
//    self.likeCountLabel.shadowOffset = CGSizeMake(1, 1);
}

- (void)setModel:(ASHNewHomeModel *)model
{
    _model = model;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img03.liwushuo.com/image/180429/mt959lm75.jpg-w720"]];
    self.titleLabel.text = @"旅行党最爱的礼物，陪你度过悠长假期";
    self.infoLabel.text = @"你身边有没有这样的一类人，总是对各种动植物怀抱着无比的热爱，但真正手把手养却连一颗多肉都养不活，于是只能警告自己再也不能碰这些可爱的小生物，因为抱回家=会狗带。";
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
