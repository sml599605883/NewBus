//
//  MyBus_BusStran_Navi_Controller.h
//  NewsBus
//
//  Created by WithLove on 2018/11/19.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBus_BusStran_Navi_Controller : MyBus_BaseViewController

@property(nonatomic,assign)CGFloat oldLatitude;
@property(nonatomic,assign)CGFloat oldLongitude;
@property(nonatomic,assign)CGFloat newLatitude;
@property(nonatomic,assign)CGFloat newLongitude;



@end

NS_ASSUME_NONNULL_END
