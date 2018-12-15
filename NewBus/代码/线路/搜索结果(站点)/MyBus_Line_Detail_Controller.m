//
//  MyBus_Line_Detail_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/19.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "MyBus_Line_Detail_Controller.h"
#import "MyBus_Line_Detail_Cell.h"

#define CELLBUS @"MyBus_Line_Detail_Cell"
static int number;
@interface MyBus_Line_Detail_Controller ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *allArr;
    AMapBusLine *positiveBUS;       //正向
    AMapBusLine *reverseBUS;        //反向
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation MyBus_Line_Detail_Controller

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + FitX(40), SCR_W, SCR_H - STATUS_BAR_HEIGHT - FitX(40) - BottomSafeArea) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"MyBus_Line_Detail_Cell" bundle:nil] forCellReuseIdentifier:CELLBUS];
    }
    return _table;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [[NSArray alloc] init];
    
    if (number == 1) {
        array = positiveBUS.busStops;
    } else {
        array = reverseBUS.busStops;
    }
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBus_Line_Detail_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CELLBUS];
    NSArray *array = [[NSArray alloc] init];
    
    if (number == 1) {
        array = positiveBUS.busStops;
    } else {
        array = reverseBUS.busStops;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AMapBusStop *buss = array[indexPath.row];
    cell.nameStr = buss.name;
    cell.number = indexPath.row + 1;
    UIImageView *img = [[UIImageView alloc] initWithFrame:cell.bounds];
//    img.image = [UIImage imageNamed:@"1"];
    img.layer.cornerRadius = 8;
    img.layer.masksToBounds = YES;
    if ([self.stratStr containsString:buss.name]) {
        cell.busNum = indexPath.row + 1;
        img.image = [UIImage imageNamed:@"组1"];
    }
    cell.backgroundView = img;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allArr = [[NSArray alloc] init];
    
    [self addMyNavigationView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"站点车辆";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCR_W - FitX(40) - FitX(5),FitX(5), FitX(40), FitY(30));
//    [btn setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    [btn setTitle:@"反向" forState:UIControlStateNormal];
    [btn setTitle:@"正向" forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.myNavigation addSubview:btn];
    
    [self.view addSubview:self.table];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    number = 1;
    [self searchBusLineWithLineName:self.lineStr city:self.cityStr];
    
}

- (void)buttonDidPress:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        number = 0;
    } else {
        sender.selected = NO;
        number = 1;
    }
    [self.table reloadData];
}

/* 公交路线回调*/
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count == 0)
    {
        //解析response获取公交线路信息，具体解析见 Demo
        return;
    }
    positiveBUS = response.buslines[0];          //正向公交
    reverseBUS = response.buslines[1];           //反向公交
    [self.table reloadData];
}


@end
