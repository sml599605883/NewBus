//
//  Bus_Site_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/9.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_Site_Controller.h"
#import "Bus_Site_Cell.h"
#import "Bus_BUS_Line_Controller.h"

@interface Bus_Site_Controller ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
{
    NSMutableArray *array;         ///表格数据数组
    CLLocation *clloc;      ///当前位置
    NSString *cityStr;      ///当前城市
    NSString *nowAddress;   ///当前位置地名
    NSString *startStr;
    NSString *endStr;
    int searchType;
}
@property (weak, nonatomic) IBOutlet UITextField *startTf;      ///起点输入框
@property (weak, nonatomic) IBOutlet UITextField *endTf;        ///终点输入框
@property (weak, nonatomic) IBOutlet UIButton *swopButton;      ///交换按钮
@property (weak, nonatomic) IBOutlet UIButton *lineButton;      ///查询线路按钮
@property (nonatomic, strong) UITableView *table;               ///查询记录展示

@property (nonatomic, strong) Bus_BUS_Line_Controller *busController;

@end

@implementation Bus_Site_Controller

- (Bus_BUS_Line_Controller *)busController {
    if (!_busController) {
        _busController = [[Bus_BUS_Line_Controller alloc] init];
    }
    return _busController;
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.lineButton.frame.size.height + self.lineButton.frame.origin.y + FitX(10) + STATUS_BAR_HEIGHT, SCR_W, SCR_H - FitX(10) - self.lineButton.frame.size.height - self.lineButton.frame.origin.y - STATUS_BAR_HEIGHT - TAB_BAR_HEIGHT - BottomSafeArea) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, tableView.frame.size.height / 2 - 20, SCR_W, 20)];
    lab.textColor = RGB(222, 222, 222);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:18];
    lab.text = @"查询过的路线会在此展示";
    if (array.count == 0 || array == nil) {
        tableView.backgroundColor = [UIColor  whiteColor];
        [tableView addSubview:lab];
    } else {
        [lab removeFromSuperview];
        tableView.backgroundColor = RGB(244, 244, 244);
    }
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Bus_Site_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"record"];
    if (!cell) {
        cell = [[Bus_Site_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"record"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Bus_New_Record *model = array[indexPath.row];
    cell.lineLab.text = [NSString stringWithFormat:@"%@至%@",model.start,model.end];
    cell.timeLab.text = [NSString stringWithFormat:@"%@",[self getDateStringWithTimeStr:model.time]];
    cell.handelDelete = ^(UIButton * but) {
        [self deleteRecordWithID:indexPath.row];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Bus_New_Record *model = array[indexPath.row];
    startStr = model.start;
    endStr = model.end;
    [self newGetAddressWithName:model.start andCity:cityStr type:3];
    [self newGetAddressWithName:model.end andCity:cityStr type:4];
    
    //响应事件
    Bus_Line_New_Model *sc = [[Bus_Line_New_Model alloc] init];
    [sc deleteMovieByID:model.recordID];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"搜索历史";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FitX(30);
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)deleteRecordWithID:(NSInteger)recordID {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除此条搜索记录?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
        Bus_New_Record *model = self->array[recordID];
        Bus_Line_New_Model *sc = [[Bus_Line_New_Model alloc] init];
        [sc deleteMovieByID:model.recordID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getData];
        });
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
//        NSLog(@"取消");
    }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

///交换按钮
- (IBAction)swopButtonDidPress:(id)sender {
    [self.startTf resignFirstResponder];
    [self.endTf resignFirstResponder];
    NSString *str = self.startTf.text;
    self.startTf.text = self.endTf.text;
    self.endTf.text = str;
}
#pragma mark 查询线路按钮
- (IBAction)lineButtonDidPress:(id)sender {
    [self.startTf resignFirstResponder];
    [self.endTf resignFirstResponder];
    if ([self.startTf.text isEqualToString:@""] || self.startTf.text.length == 0 || [self.endTf.text isEqualToString:@""] || self.startTf.text.length == 0) {
        [self.view showHUDWithMessage:@"请填写完整路程"];
        return;
    }
    
    if ([self.endTf.text isEqualToString:@"我的位置"]) {
        [self newGetAddressWithName:self.startTf.text andCity:cityStr type:2];
    } else if ([self.startTf.text isEqualToString:@"我的位置"]) {
        [self newGetAddressWithName:self.endTf.text andCity:cityStr type:1];
    } else {
        startStr = self.startTf.text;
        endStr = self.endTf.text;
        [self newGetAddressWithName:self.endTf.text andCity:cityStr type:3];
        [self newGetAddressWithName:self.startTf.text andCity:cityStr type:4];
    }
}

#pragma mark ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    array = [[NSMutableArray alloc] init];
    [self addMyNavigationView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"线路规划";
    [self.myNavigation addSubview:lab];
    
    [self.view addSubview:self.table];
    
}

#pragma mark 定位
//定位成功后调用的方法
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    clloc = location;
    if (reGeocode)
    {
//        NSLog(@"reGeocode:%@", reGeocode);
        NSString *str = [NSString stringWithFormat:@"%@",reGeocode];
        NSArray *array = [str componentsSeparatedByString:@";"];
        if ([array[9] rangeOfString:@"POIName"].location != NSNotFound) {
            if ([array[3] rangeOfString:@"city"].location != NSNotFound) {
                NSArray *arrayTwo = [array[3] componentsSeparatedByString:@":"];
                cityStr = arrayTwo[1];
                NSArray *arrThree = [array[9] componentsSeparatedByString:@":"];
                nowAddress = [NSString stringWithFormat:@"%@",arrThree[1]];
            }
        }
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.startTf.text = @"我的位置";
    self.endTf.text = @"";
    [self getData];
}

- (void)getData {
    [array removeAllObjects];
    Bus_Line_New_Model *model = [[Bus_Line_New_Model alloc]init];
    NSArray *arr = [[model getAllMovies] mutableCopy];
    for (NSInteger i = arr.count - 1; i >= 0; i--) {
        Bus_New_Record *record = arr[i];
        [array addObject:record];
    }
    [self.table reloadData];
}



- (NSString *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/BeiJing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

#pragma mark 获取地理位置编码
- (void)newGetAddressWithName:(NSString *)name andCity:(NSString *)city type:(int)type {
    if (type == 1) {
        searchType = 1;
    } else if (type == 2) {
        searchType = 2;
    } else if (type == 3) {
        searchType = 3;
    } else if (type == 4) {
        searchType = 4;
    }
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = name;
    request.city                = city;
    request.types               = @"190000";
    request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}
/* 到达地点经纬度回调*/
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0)
    {
        return;
    }
    AMapPOI *amap = response.pois[0];
    if (searchType == 1) {
        Bus_BUS_Line_Controller *navi = [[Bus_BUS_Line_Controller alloc] init];
        navi.city = cityStr;
        navi.stant = self.startTf.text;
        navi.end = self.endTf.text;
        navi.oldLatitude = clloc.coordinate.latitude;
        navi.oldLongitude = clloc.coordinate.longitude;
        navi.newLatitude = amap.location.latitude;
        navi.newLongitude = amap.location.longitude;
        
        Bus_New_Record *record = [Bus_New_Record new];
        record.start = nowAddress;
        record.end  = self.endTf.text;
        record.time  = [self getNowTimeTimestamp];
        //调用数据库中单例
        Bus_Line_New_Model *model = [Bus_Line_New_Model sharedDataHandle];
        [model addOneMovie:record];
        
        [self getData];
        [self.navigationController pushViewController:navi animated:YES];
    } else if (searchType == 2) {
        Bus_BUS_Line_Controller *navi = [[Bus_BUS_Line_Controller alloc] init];
        navi.city = cityStr;
        navi.stant = self.startTf.text;
        navi.end = self.endTf.text;
        navi.oldLatitude = amap.location.latitude;
        navi.oldLongitude = amap.location.longitude;
        navi.newLatitude = clloc.coordinate.latitude;
        navi.newLongitude = clloc.coordinate.longitude;
        
        Bus_New_Record *record = [Bus_New_Record new];
        record.start = self.startTf.text;
        record.end  = nowAddress;
        record.time  = [self getNowTimeTimestamp];
        //调用数据库中单例
        Bus_Line_New_Model *model = [Bus_Line_New_Model sharedDataHandle];
        [model addOneMovie:record];
        
        [self getData];
        
        [self.navigationController pushViewController:navi animated:YES];
    } else {
        self.busController.city = cityStr;
        self.busController.stant = startStr;
        self.busController.end = endStr;
        if (searchType == 3) {
            self.busController.oldLatitude = amap.location.latitude;
            self.busController.oldLongitude = amap.location.longitude;
        } else if (searchType == 4) {
            self.busController.newLatitude = amap.location.latitude;
            self.busController.newLongitude = amap.location.longitude;
            if (self.busController.oldLatitude == 0) {
                [self newGetAddressWithName:startStr andCity:cityStr type:3];
            }
        }
        if (self.busController.newLatitude == 0 || self.busController.oldLatitude == 0) {
            return;
        } else {
            Bus_New_Record *record = [Bus_New_Record new];
            record.start = startStr;
            record.end  = endStr;
            record.time  = [self getNowTimeTimestamp];
            //调用数据库中单例
            Bus_Line_New_Model *model = [Bus_Line_New_Model sharedDataHandle];
            [model addOneMovie:record];
            
            [self getData];
            [self.navigationController pushViewController:self.busController animated:YES];
        }
        
        
    }

}

@end
