//
//  ASHOneImageCell.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHOneImageCell.h"
@interface ASHOneImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;

@end
@implementation ASHOneImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _mImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImageUrl:(NSString *)imageUrl{
    [_mImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
@end
