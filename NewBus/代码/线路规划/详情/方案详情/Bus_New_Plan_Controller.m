//
//  Bus_New_Plan_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/21.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_New_Plan_Controller.h"
#import "Bus_New_Plan_Detail_Controller.h"

@interface Bus_New_Plan_Controller ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation Bus_New_Plan_Controller
@synthesize tableView = _tableView;
@synthesize route = _route;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMyNavigationView];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"方案";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
    [self initTableView];
    
}
- (void)initTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + SELF_NAV_BAR_HEGHT, SCR_W, SCR_H - STATUS_BAR_HEIGHT - SELF_NAV_BAR_HEGHT) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.route.transits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *routeDetailCellIdentifier = @"routeDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:routeDetailCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:routeDetailCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld个方案", indexPath.row + 1];
    
    return cell;
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
    return @" ";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self getNewDetailForTransit:self.route.transits[indexPath.row]];
}
- (void)getNewDetailForTransit:(AMapTransit *)transit {
    Bus_New_Plan_Detail_Controller *transitDetailViewController = [[Bus_New_Plan_Detail_Controller alloc] init];
    transitDetailViewController.transit = transit;

    [self.navigationController pushViewController:transitDetailViewController animated:YES];
}

@end
