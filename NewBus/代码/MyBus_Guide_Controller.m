//
//  MyBus_Guide_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/9.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "MyBus_Guide_Controller.h"
#import "MyScrollView.h"
#import "MyBus_AppDelegate.h"

@interface MyBus_Guide_Controller ()<ImageScrollViewDelegate>

@end

@implementation MyBus_Guide_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageArr = @[@"1",@"2"];
    
    //滚动视图
    MyScrollView *guide = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_W, SCR_H) style:ImageScrollType_Guide images:imageArr confirmBtnTitle:@"立即体验" confirmBtnTitleColor:[UIColor whiteColor] confirmBtnFrame:CGRectMake( FitX(50), SCR_H - 160, SCR_W - FitX(100), FitX(40)) autoScrollTimeInterval:1.5 delegate:self];
    //添加到父视图
    [self.view addSubview:guide];
    //添加分页控件
    [guide addPageControlToSuperView:self.view];
    
}

//立即体验
-(void)experienceDidHandle{
    //切换窗口跟视图控制器
    MyBus_AppDelegate *app = (MyBus_AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = app.bkVC;
    //持久化当前app版本号
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:AppVer forKey:SAVE_VERSION];
    [ud synchronize];
}


@end
