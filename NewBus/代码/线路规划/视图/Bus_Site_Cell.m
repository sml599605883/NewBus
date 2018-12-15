//
//  Bus_Site_Cell.m
//  NewsBus
//
//  Created by WithLove on 2018/11/20.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_Site_Cell.h"

@implementation Bus_Site_Cell

- (UILabel *)lineLab {
    if (!_lineLab) {
        _lineLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        _lineLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    }
    return _lineLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W - 160 , 13, 100, 20)];
        _timeLab.textColor = RGB(233, 233, 233);
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    }
    return _timeLab;
}

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(SCR_W - 25, 13, 15, 15)];
        _img.image = [UIImage imageNamed:@"xx"];
    }
    return _img;
}

- (UIButton *)deleteBut {
    if (!_deleteBut) {
        _deleteBut = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W - 25, 13, 15, 15)];
//        [_deleteBut setImage:[UIImage imageNamed:@"xx"] forState:UIControlStateNormal];
        CGRect rect = CGRectMake(SCR_W - 40, 5, 30, 30);
        _deleteBut.frame = rect;
        [_deleteBut addTarget:self action:@selector(deleteButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBut;
}
///删除
- (void)deleteButtonDidPress:(UIButton *)sender {
    self.handelDelete(sender);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.lineLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.img];
        [self addSubview:self.deleteBut];
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
