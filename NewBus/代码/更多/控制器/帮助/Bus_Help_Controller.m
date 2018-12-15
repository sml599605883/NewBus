//
//  Bus_Help_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/26.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_Help_Controller.h"
#import "XDMultTableView.h"

@interface Bus_Help_Controller ()<XDMultTableViewDatasource,XDMultTableViewDelegate>
{
    NSArray *titleArr;
    NSArray *contentArr;
    CGSize contetnSize;
}
@property(nonatomic, readwrite, strong)XDMultTableView *tableView;
@property(nonatomic, strong)UIView *titleView;

@end

@implementation Bus_Help_Controller

-(XDMultTableView *)tableView{
    if (!_tableView) {
        _tableView = [[XDMultTableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + FitX(40), SCR_W, SCR_H - STATUS_BAR_HEIGHT - FitX(40))];
        _tableView.openSectionArray = nil;
        _tableView.delegate = self;
        _tableView.datasource = self;
        _tableView.tableViewHeader = self.titleView;
        _tableView.backgroundColor = [UIColor whiteColor];
        //        _tableView.autoAdjustOpenAndClose = NO;
    }
    return _tableView;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, SELF_NAV_BAR_HEGHT + STATUS_BAR_HEIGHT, SCR_W, 40)];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        lab.font = [UIFont systemFontOfSize:15];
        lab.text = @"使用帮助";
        [_titleView addSubview:lab];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArr = @[@"1.怎么看我在哪里？",@"2.怎么看附近有哪路公交车？",@"3.怎么去附近的站点？",@"4.什么都不知道怎么办？",@"5.不知道线路详情怎么办？",@"6.我的电动车/新能源汽车没电了！",@"太好用了我要推荐给朋友"];
    contentArr = @[
                   @"打开现金巴士，在首页上半部分有地图显示，您可以滑动地图查看附近情况！",
                   @"打开现金巴士，在首页下半部分有附近公交站点的展示，您可以滑动查看附进公交站点！",
                   @"再看到你附近的站点之后，点击即可查看该站点会经过的公交车或者机场巴士（如果对某条线路不熟悉可以点击查看该条线路所经过的所有站点）！",
                   @"只知道想去哪了？没问题！点击线路页面，输入想去的地点点击搜索即可！多种线路、多种方式、随时随地、想去就去！",
                   @"点击搜索后在地图上会给您展示大致路线，你至需放大点击定点图标即可了解怎么走！",
                   @"点击充电站页面，随时定位您附近的所有充电站！",
                   @"点击更多页面，点击分享给好友---完美！"
                   ];
    [self addMyNavigationView];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"使用指南";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
    [self hideNavigationUnderLine];
    [self.view addSubview:self.tableView];
}
#pragma mark - datasource
/**
 每个分组有多少行
 */
- (NSInteger)mTableView:(XDMultTableView *)mTableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
/**
 每个分组内容
 */
- (XDMultTableViewCell *)mTableView:(XDMultTableView *)mTableView
              cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
    view.backgroundColor = RGB(233, 233, 233);
    contetnSize = CGSizeMake(FitX(315), MAXFLOAT);
    CGSize fitcontetnSize = [contentArr[indexPath.section] boundingRectWithSize:contetnSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:15]} context:nil].size;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, SCR_W - 20, fitcontetnSize.height)];
    lab.text = contentArr[indexPath.section];
    lab.font = [UIFont systemFontOfSize:15];
    lab.numberOfLines = 0;
    [view addSubview:lab];
    
    cell.backgroundView = view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/**
 有多少分组
 */
- (NSInteger)numberOfSectionsInTableView:(XDMultTableView *)mTableView{
    return 7;
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
    
    contetnSize = CGSizeMake(FitX(315), MAXFLOAT);
    CGSize fitcontetnSize = [titleArr[section] boundingRectWithSize:contetnSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:15]} context:nil].size;
    
    
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_W, 20 + fitcontetnSize.height)];
    vv.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCR_W - 30, fitcontetnSize.height)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.numberOfLines = 0;
    lab.text = titleArr[section];
    
    [vv addSubview:lab];
    return vv;
}

#pragma mark - delegate
- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    contetnSize = CGSizeMake(FitX(315), MAXFLOAT);
    CGSize fitcontetnSize = [contentArr[indexPath.section] boundingRectWithSize:contetnSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]} context:nil].size;
    return fitcontetnSize.height + 16;
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForHeaderInSection:(NSInteger)section{
    contetnSize = CGSizeMake(FitX(315), MAXFLOAT);
    CGSize fitcontetnSize = [titleArr[section] boundingRectWithSize:contetnSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:15]} context:nil].size;
    
    return 20 + fitcontetnSize.height;
}


- (void)mTableView:(XDMultTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section{
//    NSLog(@"即将展开");
}


- (void)mTableView:(XDMultTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section{
//    NSLog(@"即将关闭");
}

- (void)mTableView:(XDMultTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"点击cell");
}



@end
