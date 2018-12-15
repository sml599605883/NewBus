//
//  Bus_Map_Bike.m
//  NewsBus
//
//  Created by WithLove on 2018/12/13.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_Map_Bike.h"
#import "Bus_BikeViewController.h"

//061208
@interface Bus_Map_Bike ()<MAMapViewDelegate>
{
    CLLocation *clloc;
    NSString *cityStr;
    NSMutableArray *searchList;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;

@end

@implementation Bus_Map_Bike

//地图懒加载
- (MAMapView *)mapView {
    if (!_mapView) {
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - STATUS_BAR_HEIGHT - SELF_NAV_BAR_HEGHT - TAB_BAR_HEIGHT - BottomSafeArea);
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + SELF_NAV_BAR_HEGHT, CGRectGetWidth(rect), CGRectGetHeight(rect))];
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        _mapView.showTraffic = NO;
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
        [_mapView setZoomLevel:17.5 animated:YES];
        //自定义定位经度圈样式
        _mapView.showsUserLocation = YES;
        //地图跟踪模式
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //后台定位
        _mapView.pausesLocationUpdatesAutomatically = NO;
        //        _mapView.userInteractionEnabled = NO;
        //展示交通
        _mapView.showTraffic = NO;
        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
        for (UIView *view in _mapView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchList = [[NSMutableArray alloc] init];
    [self.view addSubview:self.mapView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((SCR_W - 140) /2, SCR_H - TAB_BAR_HEIGHT - BottomSafeArea - 80, 140, 40)];
    [btn setTitle:@"扫码骑走" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(buttonGoToNextController) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *sysImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCR_W - 140) /2 + 15, btn.frame.origin.y + 13, 14, 14)];
    sysImage.image = [UIImage imageNamed:@"sys"];
    
    [self.view addSubview:btn];
    [self.view addSubview:sysImage];
    
    [self addMyNavigationView];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"附近小单车";
    [self.myNavigation addSubview:lab];
}

- (void)buttonGoToNextController {
    Bus_BikeViewController *bike = [[Bus_BikeViewController alloc] init];
    [self.navigationController pushViewController:bike animated:YES];
}

#pragma mark 定位
//定位成功后调用的方法
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    clloc = location;
    if (reGeocode) {
        //        NSLog(@"reGeocode:%@", reGeocode);
        NSString *str = [NSString stringWithFormat:@"%@",reGeocode];
        NSArray *array = [str componentsSeparatedByString:@";"];
        if ([array[9] rangeOfString:@"POIName"].location != NSNotFound) {
            if ([array[3] rangeOfString:@"city"].location != NSNotFound) {
                NSArray *arrayTwo = [array[3] componentsSeparatedByString:@":"];
                cityStr = arrayTwo[1];
                [self searchBUSStranWithLatitude:clloc.coordinate.latitude Longitude:clloc.coordinate.longitude types:@"061208"];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    [searchList removeAllObjects];
    for (AMapPOI *p in response.pois) {
        //        NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@,%@", p.description,p.name,p.location]);
        //搜索结果存在数组
        [searchList addObject:p];
    }
    [self initAnnotations];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

#pragma mark - Initialization
- (void)initAnnotations {
    self.annotations = [NSMutableArray array];
    NSInteger i;
    i = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (AMapPOI *p in searchList) {
        i++;
        AMapGeoPoint *geo = p.location;
        [array addObject:geo];
    }
    
    CLLocationCoordinate2D coordinates[i];
    for (int ii = 0; ii < array.count; ii++) {
        AMapGeoPoint *geo = array[ii];
        coordinates[ii].latitude = geo.latitude;
        coordinates[ii].longitude = geo.longitude;
    }
    for (int iii = 0; iii < i; ++iii) {
//        AMapPOI *p = searchList [iii];
//        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//        pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
//        pointAnnotation.title = @"方恒国际";
//        pointAnnotation.subtitle = @"阜通东大街6号";
//
//        [_mapView addAnnotation:pointAnnotation];
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[iii];
        a1.title = [NSString stringWithFormat:@"小单车"];
        a1.subtitle = @"我是完好的哦";
        [self.annotations addObject:a1];
    }
}
#pragma mark - Map Delegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.image = [UIImage imageNamed:@"自行车"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
//        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
//            annotationView.image = [UIImage imageNamed:@"自行车"];
//        }
//
//        annotationView.canShowCallout = YES;
//        annotationView.animatesDrop = NO;
//        annotationView.draggable = NO;
//        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        annotationView.pinColor = [self.annotations indexOfObject:annotation] % 3;
//
//        if (annotationView) {
//            annotationView.image = [UIImage imageNamed:@"自行车"];
//        }
//
//        return annotationView;
//    }
//
//    return nil;
}

@end
