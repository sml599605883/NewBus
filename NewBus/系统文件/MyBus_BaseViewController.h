//
//  MyBus_BaseViewController.h
//  NewBus
//
//  Created by 嘎嘎嘎 on 2018/12/15.
//  Copyright © 2018 嘎嘎嘎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBus_BaseViewController : UIViewController

@property(nonatomic,strong)UIView *myNavigation;  // 自定义的导航标签视图
@property(nonatomic,strong) AMapSearchAPI *search;

-(void)addMyNavigationView;    // 添加自定义的导航条视图
-(void)addBackButton;                // 添加“<”样式的返回按钮
-(void)addBackNewButton;                // 添加“<”样式的返回按钮
-(void)back:(id)sender;
-(void)hideNavigationUnderLine;      // 隐藏导航条下的线条

/**
 地理位置编码
 */
- (void)getAddressWithName:(NSString *)name andCity:(NSString *)city;
/**
 查询
 */
- (void)searchBUSStranWithLatitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude types:(NSString *)type;
/**
 公交站点查询
 */
- (void)searchBusStranWithStranName:(NSString *)name city:(NSString *)city;
/**
 公交路线查询
 */
- (void)searchBusLineWithLineName:(NSString *)name city:(NSString *)city;
/**
 步行路线规划
 */
- (void)getTheWalkingRouteWithOldLatitude:(CGFloat)oldLatitude OldLongitude:(CGFloat)oldLongitude NewLatitude:(CGFloat)newLatitude NewLongitude:(CGFloat)newLongtitude;
/**
 公交线路规划
 */
- (void)getTheBusRouteWithOldLatitude:(CGFloat)oldLatitude OldLongitude:(CGFloat)oldLongitude NewLatitude:(CGFloat)newLatitude NewLongitude:(CGFloat)newLongtitude cityName:(NSString *)city;


@end

