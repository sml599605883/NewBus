//
//  Bus_BUS_Line_Controller.h
//  NewsBus
//
//  Created by WithLove on 2018/11/20.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "MyBus_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bus_BUS_Line_Controller : MyBus_BaseViewController

@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *stant;
@property(nonatomic,strong)NSString *end;

@property(nonatomic,assign)CGFloat oldLatitude;
@property(nonatomic,assign)CGFloat oldLongitude;
@property(nonatomic,assign)CGFloat newLatitude;
@property(nonatomic,assign)CGFloat newLongitude;

@end

NS_ASSUME_NONNULL_END
