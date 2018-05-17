//
//  HomeCell.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/3.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "HomeCell.h"
@interface HomeCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectNumLabel;

@end
@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectImageView.image = [UIImage imageNamed:@"navItemCollect"];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 5;
}

- (void)setModel:(ASHNewHomeModel *)model
{
    static int a=1;
    if (a == 1) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img02.liwushuo.com/avatar/150327/cc9b9457b_a.png-w180"]];
        self.nameLabel.text = @"大菠萝小编";
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img03.liwushuo.com/image/180429/mt959lm75.jpg-w720"]];
        self.titleLabel.text = @"旅行党最爱的礼物，陪你度过悠长假期";
        self.infoLabel.text = @"旅行";
    }else{
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img01.liwushuo.com/image/160809/my81k9mpv.jpg-w720"]];
        self.nameLabel.text = @"苹果小丸子";
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img01.liwushuo.com/image/180205/46x7m1boz.jpg-w720"]];
        self.titleLabel.text = @"这些雅致清新的礼物，承包文艺范女友的情人节";
        self.infoLabel.text = @"情人节，文艺";
    }
    a++;
    _model = model;

    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
