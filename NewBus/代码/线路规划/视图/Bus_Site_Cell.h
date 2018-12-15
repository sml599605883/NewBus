//
//  Bus_Site_Cell.h
//  NewsBus
//
//  Created by WithLove on 2018/11/20.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Bus_Site_Cell : UITableViewCell

@property(nonatomic,strong)UILabel *lineLab;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UIButton *deleteBut;

@property(nonatomic,strong)void (^handelDelete)(UIButton *);

@end

NS_ASSUME_NONNULL_END
