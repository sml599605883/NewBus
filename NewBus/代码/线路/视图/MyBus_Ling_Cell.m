//
//  MyBus_Ling_Cell.m
//  NewsBus
//
//  Created by WithLove on 2018/11/23.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "MyBus_Ling_Cell.h"

@implementation MyBus_Ling_Cell

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
    }
    return _img;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 300, 20)];
        _lab.font = [UIFont systemFontOfSize:16];
    }
    return _lab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.img];
        [self addSubview:self.lab];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
