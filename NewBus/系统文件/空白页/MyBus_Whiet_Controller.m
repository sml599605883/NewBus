//
//  MyBus_Whiet_Controller.m
//  Bookkeeping
//
//  Created by huang on 2018/8/20.
//  Copyright © 2018年 大白菜. All rights reserved.
//

#import "MyBus_Whiet_Controller.h"
#import "MyBus_AppDelegate.h"
#import "MyBus_View_Controller.h"
#import "MyBus_KJudge_Net.h"
#import "MyBus_AppDelegate.h"
#import "MyBus_NetWork_Engine.h"
#import "MyBus_Main_Controller.h"

//#import "AppTabBarController.h"
//#import "GuideViewController.h"
//#import "NewsViewController.h"

@interface MyBus_Whiet_Controller ()

@end

@implementation MyBus_Whiet_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNetWorkStateChange) name:kReachabilityChangedNotification object:self];
    if ([[MyBus_KJudge_Net shareJudgeNet]isConnection] == NO ) {
        UIImageView *wIg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"网络异常"]];
        wIg.bounds = CGRectMake(0, 0, 179, 162);
        wIg.center  = self.view.center;
        wIg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAction:)];
        [wIg addGestureRecognizer:tapGestureRecognizer];
        [self.view addSubview:wIg];
    }else{
        if ([MyBus_NetWork_Engine checkProxySetting]) {
            return;
        }
        [self queryData];
    }
    
}
-(void)toAction:(UITapGestureRecognizer *)gesture
{
    if ([[MyBus_KJudge_Net shareJudgeNet]isConnection] == NO ) {
        return;
    }else{
        gesture.view.hidden = YES;
        if ([MyBus_NetWork_Engine checkProxySetting]) {
            return;
        }
        [self queryData];
    }
}

- (void)queryData{
    
    [MyBus_NetWork_Engine getWithUrlString:HOME_URL_MAIN parameters:@{@"time":[self getCurrentTimeStr],@"device":@"ios"} success:^(NSDictionary *data) {
//        NSLog(@"====%@",data);
//        NSLog(@"11====%@",[data allKeys]);
//        NSLog(@"22====%@",data[@"MagicCash"]);
        
        MyBus_AppDelegate *app = (MyBus_AppDelegate *)[UIApplication sharedApplication].delegate;
//        app.window.rootViewController = app.sideMenu;
//        AppTabBarController *vc = [[AppTabBarController alloc] init];
//        BKMainNavViewController *dabaokatabVC = [[BKMainNavViewController alloc] initWithRootViewController:vc];
        [self addChildViewController:app.mainVC];
        [self.view addSubview:app.mainVC.view];
        /*
         NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
         if (token.length == 0) {
         TCFlowerSeaDengLuViewController *vc = [[TCFlowerSeaDengLuViewController alloc] init];
         TCMainNavController *dabaokatabVC = [[TCMainNavController alloc] initWithRootViewController:vc];
         [self addChildViewController:dabaokatabVC];
         [self.view addSubview:dabaokatabVC.view];
         }
         */
        
        
        NSDictionary *dic = data[@"data"];
        if ([[dic allKeys] containsObject:HOME_URL_URL]) {
            MyBus_View_Controller *dabaokawebView = [[MyBus_View_Controller alloc] init];
            
            dabaokawebView.urlStr = dic[HOME_URL_URL];
            if ([[data allKeys] containsObject:HOME_URL_Color]) {
                dabaokawebView.colorStr = dic[HOME_URL_Color];
            }else{
                dabaokawebView.colorStr = @"0xFFFFFF";
            }
            [self addChildViewController:dabaokawebView];
            [self.view addSubview:dabaokawebView.view];
            [app.mainVC.view removeFromSuperview];
        }
    } failure:^(NSError *error) {
//        NSLog(@"失败了-------");
    }];
    
}
- (NSString *)getCurrentTimeStr{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS "];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadNetWorkStateChange
{
    if ([self DidYouChange]) {
        //在此刷新界面
        [self queryData];
    }
}

- (BOOL)DidYouChange
{
    BOOL flag = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            flag = NO;
            break;
        case ReachableViaWWAN:
            break;
        case ReachableViaWiFi:
            break;
            
        default:
            break;
    }
    
    return flag;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
