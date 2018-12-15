//
//  Bus_BUS_Line_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/20.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_BUS_Line_Controller.h"
#import "MyBus_MANaviRoute.h"
#import "Bus_New_Plan_Controller.h"
#import "Bus_New_Plan_Detail_Controller.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface Bus_BUS_Line_Controller ()<MAMapViewDelegate>
{
    UILabel *lab;
}
/* 路径规划类型 */
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapRoute *route;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIButton *nextItem;       //下一个方案按钮
@property (nonatomic, strong) UIButton *previousItem;   //上一个方案按钮
@property (nonatomic, strong) UIButton *AllDetailButton;      //该方案详情按钮

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MyBus_MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

@end

@implementation Bus_BUS_Line_Controller

//地图懒加载
- (MAMapView *)mapView {
    if (!_mapView) {
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - STATUS_BAR_HEIGHT - SELF_NAV_BAR_HEGHT);
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + SELF_NAV_BAR_HEGHT, CGRectGetWidth(rect), CGRectGetHeight(rect))];
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        _mapView.showTraffic = YES;
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
        //        _mapView.showTraffic = NO;
        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
        for (UIView *view in _mapView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    return _mapView;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    self.naviRoute = [MyBus_MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse] startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
    
}

/* 清空地图上已有的路线. */
- (void)clear {
    [self.naviRoute removeFromMapView];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MyBus_LineDashPolyline class]]) {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((MyBus_LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashPattern = @[@10, @15];
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MyBus_MANaviPolyline class]]) {
        MyBus_MANaviPolyline *naviPolyline = (MyBus_MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking) {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        } else if (naviPolyline.type == MANaviAnnotationTypeRailway) {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        } else {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]]) {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil) {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:routePlanningCellIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        if ([annotation isKindOfClass:[MyBus_MANaviAnnotation class]]) {
            switch (((MyBus_MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                default:
                    break;
            }
        } else {
            if ([[annotation title] isEqualToString:  (NSString*)RoutePlanningViewControllerStartTitle]) {/* 起点. */
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            } else if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle]) {/* 终点. */
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}
#pragma mark --------------- 切换线路
- (BOOL)increaseCurrentCourse {
    BOOL result = NO;
    if (self.currentCourse < self.totalCourse - 1) {
        self.currentCourse++;
        result = YES;
    }
    return result;
}
- (BOOL)decreaseCurrentCourse {
    BOOL result = NO;
    if (self.currentCourse > 0) {
        self.currentCourse--;
        result = YES;
    }
    return result;
}
- (void)updateTotal {
    self.totalCourse = self.route.transits.count;
}
#pragma mark /* 更新"上一个", "下一个"按钮状态. */
- (void)updateCourseUI {
    /* 上一个. */
    self.previousItem.enabled = (self.currentCourse > 0);
    /* 下一个. */
    self.nextItem.enabled = (self.currentCourse < self.totalCourse - 1);
}
#pragma mark /* 更新"详情"按钮状态. */
- (void)updateDetailUI {
    self.navigationItem.rightBarButtonItem.enabled = self.route != nil;
}
#pragma mark /* 切到上一个方案路线. */
- (void)previousCourseAction {
    if ([self decreaseCurrentCourse]) {
        lab.text = [NSString stringWithFormat:@"%@到%@(方案%ld)",self.stant,self.end,self.currentCourse+1];
        [self clear];
        [self updateCourseUI];
        [self presentCurrentCourse];
    }
}

#pragma mark /* 切到下一个方案路线. */
- (void)nextCourseAction {
    if ([self increaseCurrentCourse]) {
        lab.text = [NSString stringWithFormat:@"%@到%@(方案%ld)",self.stant,self.end,self.currentCourse+1];
        [self clear];
        [self updateCourseUI];
        [self presentCurrentCourse];
    }
}


#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
//    NSLog(@"Error: %@", error);
    [self.view showHUDWithMessage:[NSString stringWithFormat:@"%@",error]];
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    if (response.route == nil)
    {
        return;
    }
    
    //解析response获取路径信息，具体解析见 Demo
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    [self updateCourseUI];
    [self updateDetailUI];
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self addMyNavigationView];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = [NSString stringWithFormat:@"%@到%@(方案%ld)",self.stant,self.end,self.currentCourse+1];
    [self.myNavigation addSubview:lab];
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W - 75, 0, 60, 40)];
    [but setTitle:@"方案" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [but addTarget:self action:@selector(pushToNextController) forControlEvents:UIControlEventTouchUpInside];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.myNavigation addSubview:but];
    [self addBackButton];
    
    
    self.previousItem = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W - SCR_W/4 - 10 , SCR_H - BottomSafeArea - 130, SCR_W/4, 30)];
    [self.previousItem setTitle:@"前一个" forState:UIControlStateNormal];
    self.previousItem.backgroundColor = [UIColor orangeColor];
    self.previousItem.layer.cornerRadius = 15;
    [self.previousItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.previousItem addTarget:self action:@selector(previousCourseAction) forControlEvents:UIControlEventTouchUpInside];
    self.nextItem = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W - SCR_W/4 - 10 , SCR_H - BottomSafeArea - 90, SCR_W/4, 30)];
    [self.nextItem setTitle:@"后一个" forState:UIControlStateNormal];
    self.nextItem.backgroundColor = [UIColor orangeColor];
    self.nextItem.layer.cornerRadius = 15;
    [self.nextItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nextItem addTarget:self action:@selector(nextCourseAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.AllDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W - SCR_W/4 - 10 , SCR_H - BottomSafeArea - 170, SCR_W/4, 30)];
    [self.AllDetailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.AllDetailButton setTitle:@"详情" forState:UIControlStateNormal];
    self.AllDetailButton.backgroundColor = [UIColor orangeColor];
    self.AllDetailButton.layer.cornerRadius = 15;
    [self.AllDetailButton addTarget:self action:@selector(pushToDetailController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.previousItem];
    [self.view addSubview:self.nextItem];
    [self.view addSubview:self.AllDetailButton];
    
}

- (void)pushToNextController {
    Bus_New_Plan_Controller *plan = [[Bus_New_Plan_Controller alloc] init];
    plan.route = self.route;
    [self.navigationController pushViewController:plan animated:YES];
}

- (void)pushToDetailController {
    [self clear];
    
    Bus_New_Plan_Detail_Controller *planDetail = [[Bus_New_Plan_Detail_Controller alloc] init];
    planDetail.transit = self.route.transits[self.currentCourse];
    [self.navigationController pushViewController:planDetail animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.startCoordinate        = CLLocationCoordinate2DMake(self.oldLatitude, self.oldLongitude);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(self.newLatitude, self.newLongitude);
    [self getTheBusRouteWithOldLatitude:self.oldLatitude OldLongitude:self.oldLongitude NewLatitude:self.newLatitude NewLongitude:self.newLongitude cityName:self.city];
    [self addDefaultAnnotations];
}



- (void)addDefaultAnnotations {
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

@end
