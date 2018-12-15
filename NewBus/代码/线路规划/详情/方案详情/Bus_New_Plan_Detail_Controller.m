//
//  Bus_New_Plan_Detail_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/21.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_New_Plan_Detail_Controller.h"

@interface Bus_New_Plan_Detail_Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation Bus_New_Plan_Detail_Controller
@synthesize transit = _transit;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMyNavigationView];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"方案详情";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
    [self initTableView];
}
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + SELF_NAV_BAR_HEGHT, SCR_W, SCR_H - STATUS_BAR_HEIGHT - SELF_NAV_BAR_HEGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 4 : self.transit.segments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *transitDetailCellIdentifier = @"transitDetailCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:transitDetailCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:transitDetailCellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self titleForIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.frame = cell.frame;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [self subTitleForIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    NSString *title = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                title = @"需花费";
                break;
            case 1:
                title = @"预期时间";
                break;
            case 2:
                title = @"总步行距离";
                break;
            case 3:
                title = @"总距离";
                break;
            default:
                title = @"";
        }
    } else {
        AMapSegment *segment = self.transit.segments[indexPath.row];
        
        AMapRailway *railway = segment.railway;
        AMapWalking *walking = segment.walking;
        AMapBusLine *busline = [segment.buslines firstObject];
        if (railway.uid) {
            title = railway.name;
        } else if (busline) {
            title = [NSString stringWithFormat:@"%@至%@ (地铁或公交预计%ld分钟)", busline.departureStop.name, busline.arrivalStop.name,(busline.duration/60)];
        } else {
            title = [NSString stringWithFormat:@"步行约：%ld米（大约预计需要%ld分钟）",(long)walking.distance,walking.duration/60];
        }
    }
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath {
    NSString *subTitle = nil;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                subTitle = [NSString stringWithFormat:@"%.2f(元)", self.transit.cost];
                break;
            case 1:
                subTitle = [NSString stringWithFormat:@"%ld(分钟)", (self.transit.duration/60)];
                break;
            case 2:
                subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.transit.walkingDistance];
                break;
            case 3:
                subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.transit.distance];
                break;
        }
    } else {
        subTitle = nil;
    }
    return subTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"基础信息" : @"换乘路段";
}

@end
