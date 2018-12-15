//
//  MyBus_Stran_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/14.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "MyBus_Stran_Controller.h"
#import "MyBus_Line_Detail_Controller.h"
#import "MyBus_BusStran_Navi_Controller.h"
#import "MyBus_Ling_Cell.h"


@interface MyBus_Stran_Controller ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *searchList;
    NSString *cityStr;
    CLLocation *clloc;
    NSString *searchStr;
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation MyBus_Stran_Controller

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, SELF_NAV_BAR_HEGHT + STATUS_BAR_HEIGHT, SCR_H, SCR_H - SELF_NAV_BAR_HEGHT - STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return searchList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBus_Ling_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ccee"];
    if (!cell) {
        cell = [[MyBus_Ling_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ccee"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AMapBusStop *b = searchList[indexPath.section];
//    NSLog(@"%@",b.name);
    cell.img.image = [UIImage imageNamed:@"线路大巴"];
    cell.lab.text = [NSString stringWithFormat:@"%@",b.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMapBusStop *b = searchList[indexPath.section];
    NSArray *array = [b.name componentsSeparatedByString:@"路"]; //从字符"路"中分隔成2个元素的数组
    if (array.count == 1) {
        array = [b.name componentsSeparatedByString:@"线"];
    }
    MyBus_Line_Detail_Controller *line = [[MyBus_Line_Detail_Controller alloc] init];
    line.lineStr = array[0];
    line.cityStr = cityStr;
    line.stratStr = self.nameStr;
    [self.navigationController pushViewController:line animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    searchList = [[NSMutableArray alloc] init];
    [self addMyNavigationView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"站点车辆";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
    [self.view addSubview:self.table];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCR_W - FitX(80) - FitX(5),FitX(5), FitX(80), FitY(30));
    //    [btn setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    [btn setTitle:@"到这里去" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToDaoHangControllerWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myNavigation addSubview:btn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
}
//到哪里去
- (void)goToDaoHangControllerWithButton:(UIButton *)sender {
    [self getAddressWithName:self.nameStr andCity:cityStr];
}

//定位成功后
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    clloc = location;
    if (reGeocode)
    {
//        NSLog(@"reGeocode:%@", reGeocode);
        NSString *str = [NSString stringWithFormat:@"%@",reGeocode];
        NSArray *array = [str componentsSeparatedByString:@";"];
        if ([array[3] rangeOfString:@"city"].location != NSNotFound) {
            NSArray *arrayTwo = [array[3] componentsSeparatedByString:@":"];
            cityStr = arrayTwo[1];
            [self searchBusStranWithStranName:self.nameStr city:cityStr];
        }
    }
}

/* 公交站点回调*/
- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response
{
    if (response.busstops.count == 0)
    {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    [searchList removeAllObjects];
    for (AMapBusStop *p in response.busstops) {
        if (!([p.name rangeOfString:self.nameStr].location == NSNotFound)) {
            for (AMapBusLine *b in p.buslines) {
//                NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@, %@", p.description,p.name,b.name]);
                //搜索结果存在数组
                [searchList addObject:b];
            }
        }
    }
    
    [self.table reloadData];
}
/* 公交站点经纬度回调*/
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    AMapPOI *amap = response.pois[0];
    MyBus_BusStran_Navi_Controller *navi = [[MyBus_BusStran_Navi_Controller alloc] init];
    navi.oldLatitude = clloc.coordinate.latitude;
    navi.oldLongitude = clloc.coordinate.longitude;
    navi.newLatitude = amap.location.latitude;
    navi.newLongitude = amap.location.longitude;
    [self.navigationController pushViewController:navi animated:YES];
}
//- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
//{
//    if (response.geocodes.count == 0)
//    {
//        return;
//    }
//    AMapGeocode *amap = response.geocodes[0];
//    //116.32873499999999
//
////    [self.navigationController pushViewController:navi animated:YES];
//}

@end
