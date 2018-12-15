//
//  Bus_More_Cell.m
//  NewsBus
//
//  Created by WithLove on 2018/11/21.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_More_Cell.h"

@implementation Bus_More_Cell

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
        _img.layer.cornerRadius = 8;
        _img.layer.masksToBounds = YES;
    }
    return _img;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 100, 17)];
        _labTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _labTitle.textColor = [UIColor blackColor];
    }
    return _labTitle;
}

- (UILabel *)labTwoTitle {
    if (!_labTwoTitle) {
        _labTwoTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 200, 14)];
        _labTwoTitle.font = [UIFont systemFontOfSize:12];
        _labTwoTitle.textColor = [UIColor grayColor];
    }
    return _labTwoTitle;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.img];
        [self addSubview:self.labTitle];
        [self addSubview:self.labTwoTitle];
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
