//
//  MyBus_Line_Detail_Cell.h
//  NewsBus
//
//  Created by WithLove on 2018/11/22.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBus_Line_Detail_Cell : UITableViewCell

@property (nonatomic,assign) NSInteger busNum;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,strong) NSString *nameStr;

@end

NS_ASSUME_NONNULL_END
