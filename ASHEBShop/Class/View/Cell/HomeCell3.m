//
//  HomeCell3.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/17.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "HomeCell3.h"
#import "ASHNewHomeModel.h"

@interface HomeCell3()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (nonatomic, strong)UIVisualEffectView *effectView;

@end
@implementation HomeCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    self.effectView.alpha = 0.8;
    [self.contentImageView addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentImageView);
        make.width.mas_equalTo(self.contentImageView);
        make.height.mas_equalTo(44);
    }];
    
    self.likeCountLabel.shadowColor = [UIColor lightGrayColor];
    self.likeCountLabel.shadowOffset = CGSizeMake(1, 1);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}
- (void)setNeedsLayout{
    [super setNeedsLayout];
}
- (void)layoutIfNeeded{
    [super layoutIfNeeded];
}
- (void)setModel:(ASHNewHomeItemModel *)model
{
    _model = model;

    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.contentTitleLabel.text = model.title;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",model.praise];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
