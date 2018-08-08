//
//  ASHCaetgoryTwoCell.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCaetgoryTwoCell.h"
@interface ASHCaetgoryTwoCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end
@implementation ASHCaetgoryTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:@"http://ms1.sqkb.com/dist/image/index/index-k9-woman-382f38e256.jpg"]];
    [_imageView2 sd_setImageWithURL:[NSURL URLWithString:@"http://ms1.sqkb.com/dist/image/index/index-rank-woman-60bf2a734c.jpg"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)itemBtnClick:(UIButton*)sender {
    if (self.itemClickAction) {
        self.itemClickAction(sender.tag - 1);
    }
}

@end
