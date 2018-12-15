//
//  MyBus_Line_Detail_Cell.m
//  NewsBus
//
//  Created by WithLove on 2018/11/22.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "MyBus_Line_Detail_Cell.h"

@interface MyBus_Line_Detail_Cell ()

@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation MyBus_Line_Detail_Cell



- (void)setNumber:(NSInteger)number {
    if (number) {
        self.numberLab.text = [NSString stringWithFormat:@"%ld",number];
        self.numberLab.backgroundColor = [UIColor blueColor];
    }
}
- (void)setBusNum:(NSInteger)busNum {
    if (busNum) {
        self.numberLab.backgroundColor = [UIColor redColor];
    }
}

- (void)setNameStr:(NSString *)nameStr {
    if (nameStr) {
        self.nameLab.text = nameStr;
    }
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
