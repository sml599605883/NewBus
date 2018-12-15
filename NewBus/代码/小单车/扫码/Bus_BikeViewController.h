//
//  Bus_BikeViewController.h
//  NewsBus
//
//  Created by WithLove on 2018/12/11.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "MyBus_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bus_BikeViewController : MyBus_BaseViewController

@property(nonatomic,strong)NSString *bikeStr;
@property(nonatomic,strong)void(^backBikeNumber) (NSString *);

@end

NS_ASSUME_NONNULL_END
