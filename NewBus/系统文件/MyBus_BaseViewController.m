//
//  MyBus_BaseViewController.m
//  NewBus
//
//  Created by 嘎嘎嘎 on 2018/12/15.
//  Copyright © 2018 嘎嘎嘎. All rights reserved.
//

#import "MyBus_BaseViewController.h"

@interface MyBus_BaseViewController ()<AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>

@property(nonatomic,strong) AMapLocationManager *locationManager;

@end

@implementation MyBus_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMapServices sharedServices].apiKey = @"654e78af3f22ce3beaa10c2aa72b51b5";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 50;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark ---------------- 自定义的导航条  -----------------
-(UIView *)myNavigation {
    if (!_myNavigation) {
        _myNavigation = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCR_W, FitX(40))];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, - STATUS_BAR_HEIGHT, SCR_W, FitX(40) + STATUS_BAR_HEIGHT)];
        img.tag = 10090;
        img.image = [UIImage imageNamed:@"WechatIMG9"];
        [_myNavigation addSubview:img];
        _myNavigation.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, FitX(39.5), SCR_W, FitX(0.5))];
        lineView.tag = 987;
        lineView.backgroundColor = RGB(243, 243, 243);
        [_myNavigation addSubview:lineView];
    }
    return _myNavigation;
}
// 隐藏导航条下的线条
-(void)hideNavigationUnderLine {
    UIView *lineView = [self.myNavigation viewWithTag:987];
    lineView.hidden = YES;
}

// 添加“<”样式的返回按钮
-(void)addBackButton {
    self.navigationItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5,5, 40, 30);
    [btn setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.myNavigation addSubview:btn];
}
-(void)addBackNewButton {
    self.navigationItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5,5, 40, 30);
    [btn setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myNavigation addSubview:btn];
}

// 添加自定义的导航条
-(void)addMyNavigationView {
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.myNavigation];
}

#pragma mark ---------------------- UI触发方法 -------------------------
// back按钮触发方法
-(void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 地理位置编码
- (void)getAddressWithName:(NSString *)name andCity:(NSString *)city {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = name;
    request.city                = city;
    request.types               = @"150700";
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}
#pragma mark 附近公交站
///附近公交站
- (void)searchBUSStranWithLatitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude types:(NSString *)type{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    request.types = type;
    request.requireExtension = YES;
    request.offset = 10;
    request.sortrule = 0;
    [self.search AMapPOIKeywordsSearch:request];
}
#pragma mark 指定公交站点查询
///指定公交站点查询
- (void)searchBusStranWithStranName:(NSString *)name city:(NSString *)city {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapBusStopSearchRequest *stop = [[AMapBusStopSearchRequest alloc] init];
    stop.keywords = name;
    stop.city = city;
    [self.search AMapBusStopSearch:stop];
}
#pragma mark 指定公交路线查询
///指定公交路线查询
- (void)searchBusLineWithLineName:(NSString *)name city:(NSString *)city {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords = name;
    line.city = city;
    line.requireExtension = YES;
    [self.search AMapBusLineNameSearch:line];
}
#pragma mark 步行路线规划
///步行路线规划
- (void)getTheWalkingRouteWithOldLatitude:(CGFloat)oldLatitude OldLongitude:(CGFloat)oldLongitude NewLatitude:(CGFloat)newLatitude NewLongitude:(CGFloat)newLongtitude {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:oldLatitude longitude:oldLongitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:newLatitude longitude:newLongtitude];
    [self.search AMapWalkingRouteSearch:navi];
}
#pragma mark 公交线路规划
///公交线路规划
- (void)getTheBusRouteWithOldLatitude:(CGFloat)oldLatitude OldLongitude:(CGFloat)oldLongitude NewLatitude:(CGFloat)newLatitude NewLongitude:(CGFloat)newLongtitude cityName:(NSString *)city {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.city             = city;
    //  //终点城市
    //  navi.destinationCity  = @"wuhan";
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:oldLatitude longitude:oldLongitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:newLatitude longitude:newLongtitude];
    [self.search AMapTransitRouteSearch:navi];
}

@end
