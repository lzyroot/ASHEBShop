//
//  ASHCategoryItemView.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCategoryItemView.h"

#define TabCategoryBtnTag 1000;

@interface ASHCategoryItemView()
@property(nonatomic, strong)UIImageView* imageView;
@property(nonatomic, strong)UILabel* nameLabel;
@property(nonatomic, strong)UIButton* tapButton;
@property(nonatomic, strong)ASHTabItemModel* model;
@end
@implementation ASHCategoryItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.ash_width = frame.size.width - 15;
        _imageView.ash_height = _imageView.ash_width;
        _imageView.ash_centerX = frame.size.width / 2;
        _imageView.ash_top = 10;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        _nameLabel.ash_bottom = frame.size.height;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:12.0];
        
        _tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapButton.backgroundColor = [UIColor clearColor];
        _tapButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
        [self addSubview:_tapButton];
    }
    return self;
}

- (void)setModel:(ASHTabItemModel *)model
{
    _model = model;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    _nameLabel.text = model.name;
}

- (void)tapButtonClick:(UIButton*)button
{
    if (self.tapAction) {
        self.tapAction(self.tag);
    }
}

@end
