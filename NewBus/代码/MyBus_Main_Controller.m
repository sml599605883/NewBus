//
//  MyBus_Main_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/9.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "MyBus_Main_Controller.h"
#import "Bus_LineViewController.h"
#import "Bus_Site_Controller.h"
#import "Bus_Map_Bike.h"
#import "Bus_More_Controller.h"

@interface MyBus_Main_Controller ()

@end

@implementation MyBus_Main_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    
    UINavigationController *hVC = [self createNavgationWithControllerName:@"Bus_LineViewController" title:@"离我最近" imgName:@"站点(1)拷贝" selectImgName:@"站点(1)"];
    UINavigationController *kVC = [self createNavgationWithControllerName:@"Bus_Site_Controller" title:@"极速回家" imgName:@"线路行程拷贝" selectImgName:@"线路行程"];
    UINavigationController *jVC = [self createNavgationWithControllerName:@"Bus_Map_Bike" title:@"绿色出行" imgName:@"充电站拷贝" selectImgName:@"充电站"];
    UINavigationController *mVC = [self createNavgationWithControllerName:@"Bus_More_Controller" title:@"还有更多" imgName:@"更多拷贝" selectImgName:@"更多"];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setSelectedImageTintColor:RGB(250,32,53)];
    
    [[UITabBar appearance] setTintColor:RGB(62,130,247)];
    tab.viewControllers = @[kVC,hVC,jVC,mVC];
    [tab.tabBar setBackgroundImage:[UIImage imageNamed:@"123"]];
    [self.view addSubview:tab.view];
    [self addChildViewController:tab];
    
}

-(UINavigationController *)createNavgationWithControllerName:(NSString *)name
                                                       title:(NSString *)title
                                                     imgName:(NSString *)imgname
                                               selectImgName:(NSString *)selectName {
    // 根据类的名称的字符串得到一个类的对象
    UIViewController *vc = [[NSClassFromString(name) alloc] init];
    // 实例化一个导航
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    // 设置导航的标签栏标签
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:imgname] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(62,130,247)} forState:UIControlStateSelected];
    return nav;
}
@end
