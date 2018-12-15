//
//  Bus_LineViewController.m
//  NewsBus
//
//  Created by WithLove on 2018/11/9.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_LineViewController.h"
#import "MyBus_Stran_Controller.h"
#import "MyBus_Ling_Cell.h"
#import "MyBus_Charging_Controller.h"
#import "XDMultTableView.h"

static int a = 0;
@interface Bus_LineViewController ()<UITextFieldDelegate,MAMapViewDelegate,AMapLocationManagerDelegate,XDMultTableViewDatasource,XDMultTableViewDelegate>
{
    UITextField *searchTf;
    NSMutableDictionary *searchDic;        //搜索结果
    NSMutableArray *searchList;
    NSMutableArray *busLine;        //公交站
    NSString *strName;
    NSString *strCity;
}
@property(nonatomic,strong) XDMultTableView *table;
@property(nonatomic, strong)UIView *tableTitleView;
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) MAMapView *mapView;
@property(nonatomic,strong) UILabel *alertLab;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
/**
 *  持续定位是否返回逆地理信息，默认NO。
 */
@property (nonatomic, assign) BOOL locatingWithReGeocode;

@end

@implementation Bus_LineViewController


-(XDMultTableView *)table{
    if (!_table) {
        _table = [[XDMultTableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + SELF_NAV_BAR_HEGHT + FitX(280), SCR_W, SCR_H - STATUS_BAR_HEIGHT - SELF_NAV_BAR_HEGHT - FitX(280) - TAB_BAR_HEIGHT - BottomSafeArea)];
        _table.openSectionArray = nil;
        _table.delegate = self;
        _table.datasource = self;
        _table.tag = 19090;
        _table.tableViewHeader = self.tableTitleView;
        _table.backgroundColor = [UIColor whiteColor];
        //        _tableView.autoAdjustOpenAndClose = NO;
    }
    return _table;
}

-(UIView *)tableTitleView{
    if (!_tableTitleView) {
        _tableTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, SELF_NAV_BAR_HEGHT + STATUS_BAR_HEIGHT, SCR_W, 40)];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        lab.font = [UIFont systemFontOfSize:15];
        lab.text = @"附近站点";
        [_tableTitleView addSubview:lab];
        _tableTitleView.backgroundColor = [UIColor whiteColor];
    }
    return _tableTitleView;
}
/**
 有多少分组
 */
- (NSInteger)numberOfSectionsInTableView:(XDMultTableView *)mTableView{
    return searchList.count;
}

/**
 每个分组的头部标题
 */
//-(NSString *)mTableView:(XDMultTableView *)mTableView titleForHeaderInSection:(NSInteger)section{
//    return titleArr[section];
//}

/**
 每个分组的头部标题
 */
-(UIView *)mTableView:(XDMultTableView *)mTableView viewForHeaderInSection:(NSInteger)section{
    
    AMapPOI *poi = searchList[section];
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_W, 30)];
    vv.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCR_W - 30, 30)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.numberOfLines = 0;
    lab.text = poi.name;
    
    [vv addSubview:lab];
    return vv;
}

/**
 每个分组有多少行
 */
- (NSInteger)mTableView:(XDMultTableView *)mTableView numberOfRowsInSection:(NSInteger)section{
    AMapPOI *poi = searchList[section];
    NSArray *arr = searchDic[poi.name];
    return arr.count;
}
/**
 每个分组的每一行是什么内容
 */
- (XDMultTableViewCell *)mTableView:(XDMultTableView *)mTableView
              cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    AMapPOI *poi = searchList[indexPath.section];
    NSArray *arr = searchDic[poi.name];
    AMapBusLine *map = arr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"线路大巴"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = map.name;
    
    return cell;
}

#pragma mark - delegate
- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)mTableView:(XDMultTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section{
//    NSLog(@"即将展开");
}


- (void)mTableView:(XDMultTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section{
    [mTableView reloadData];
//    NSLog(@"即将关闭");
}

- (void)mTableView:(XDMultTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"点击cell---%ld %ld",indexPath.section,indexPath.row);
}


#pragma mark ------------ 地图
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, SELF_NAV_BAR_HEGHT + STATUS_BAR_HEIGHT, SCR_W, FitX(280))];
        [_titleView addSubview:self.mapView];
    }
    return _titleView;
}

//地图懒加载
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.titleView.bounds];
        MAMapRect ccc = MAMapRectMake(0.0, SELF_NAV_BAR_HEGHT + STATUS_BAR_HEIGHT, SCR_W, FitX(280));
        _mapView.visibleMapRect = [_mapView mapRectThatFits:ccc];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
//        _mapView.showTraffic = YES;
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
        [_mapView setZoomLevel:16.5 animated:YES];
        //自定义定位经度圈样式
        _mapView.showsUserLocation = YES;
        //地图跟踪模式
        _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        //后台定位
        _mapView.pausesLocationUpdatesAutomatically = NO;
        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
        r.strokeColor = [UIColor clearColor];///定位点背景色，不设置默认白色
//        r.showsHeadingIndicator = YES;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
        r.image = [UIImage imageNamed:@"userPosition"];
        [self.mapView updateUserLocationRepresentation:r];
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
    
    searchDic = [[NSMutableDictionary alloc] init];
    
    searchList = [[NSMutableArray alloc] init];
    busLine = [[NSMutableArray alloc] init];
    //把地图放在底层
    [self.view addSubview:self.titleView];
    
    [self addMyNavigationView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"附近站点";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCR_W - 65,5, 60, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"充电站" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushToCharging:) forControlEvents:UIControlEventTouchUpInside];
    [self.myNavigation addSubview:btn];
    
    searchTf = [[UITextField alloc] initWithFrame:CGRectMake(FitX(10), FitX(2), SCR_W - FitX(20), FitX(36))];
    searchTf.placeholder = @"搜索公交路线";
    searchTf.borderStyle = UITextBorderStyleRoundedRect;
    searchTf.delegate = self;
    searchTf.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    [self.myNavigation addSubview:lab];
    
    [self.view addSubview:self.table];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W - 40, STATUS_BAR_HEIGHT + SELF_NAV_BAR_HEGHT + FitX(240), 30, 30)];
    [but setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(backSelfLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:but];
    
}

- (void)pushToCharging:(UIButton *)sender {
    MyBus_Charging_Controller *charging = [[MyBus_Charging_Controller alloc] init];
    [self.navigationController pushViewController:charging animated:YES];
}

- (void)backSelfLocation {
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        return YES;
    }
//    NSLog(@"搜索线路@“%@”",textField.text);
    return YES;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
//    [self backSelfLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
//小蓝点更换
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        self.userLocationAnnotationView = annotationView;
        return annotationView;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}
//定位成功后调用的方法
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
//        NSLog(@"reGeocode:%@", reGeocode);
        NSString *str = [NSString stringWithFormat:@"%@",reGeocode];
        NSArray *array = [str componentsSeparatedByString:@";"];
        if ([array[9] rangeOfString:@"POIName"].location != NSNotFound) {
//            NSArray *arrayTwo = [array[9] componentsSeparatedByString:@":"];
            [self searchBUSStranWithLatitude:location.coordinate.latitude Longitude:location.coordinate.longitude types:@"150700"];
        }
    }
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    [searchList removeAllObjects];
    for (AMapPOI *p in response.pois) {
//        NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@,%@", p.description,p.name,p.address]);
        //搜索结果存在数组
        [searchList addObject:p];
//        searchDic = [NSDictionary dictionaryWithObject:searchList forKey:@"name"];
    }
    AMapPOI *p = searchList[0];
    strName = p.name;
    strCity = p.city;
    [self searchBusStranWithStranName:p.name city:p.city];
//    for ( in searchList) {
//        strName = p.name;
//        strCity = p.city;
//
//    }
    [self.table reloadData];
    [self backSelfLocation];
    
}

/* 公交站点回调*/
- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response
{
    if (response.busstops.count == 0)
    {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    [busLine removeAllObjects];
    for (AMapBusStop *p in response.busstops) {
        if (!([p.name rangeOfString:strName].location == NSNotFound)) {
            for (AMapBusLine *b in p.buslines) {
//                NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@, %@", p.description,p.name,b.name]);
                //搜索结果存在数组
                [busLine addObject:b];
            }
            [searchDic setObject:[busLine mutableCopy] forKey:p.name];
//            searchDic = [NSMutableDictionary dictionaryWithObject:busLine forKey:p.name];
            if (a < searchList.count) {
//                NSLog(@"p.name=== %@",p.name);
                AMapPOI *poi = searchList[a];
                a++;
                strName = poi.name;
                strCity = poi.city;
                [self searchBusStranWithStranName:poi.name city:poi.city];
            }
        }
    }
    
    
    [self.table reloadData];
}



@end
