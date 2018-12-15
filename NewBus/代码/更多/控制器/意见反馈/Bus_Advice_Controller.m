//
//  Bus_Advice_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/21.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_Advice_Controller.h"

@interface Bus_Advice_Controller ()

@end

@implementation Bus_Advice_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addMyNavigationView];
    self.myNavigation.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCR_W, FitX(40));
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"反馈";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCR_W - FitX(80) - FitX(5),FitX(5), FitX(80), FitY(30));
    //    [btn setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendToCommper) forControlEvents:UIControlEventTouchUpInside];
    [self.myNavigation addSubview:btn];
    
}

- (void)sendToCommper {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag = 999;
    [self.view addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    int x = arc4random() % 9;
    int y = (arc4random() % 10);
    NSString *str=[NSString stringWithFormat:@"%d.%d",y,x];
    CGFloat f = [str floatValue];
    [self performSelector:@selector(showTextToView) withObject:hud afterDelay:f];
}

- (void)showTextToView {
    MBProgressHUD *lasdHud = (MBProgressHUD *)[self.view viewWithTag:999];
    [lasdHud hide:YES];
    lasdHud = nil;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"反馈成功!";
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];
    [self performSelector:@selector(back:) withObject:hud afterDelay:2.1];
}

@end
