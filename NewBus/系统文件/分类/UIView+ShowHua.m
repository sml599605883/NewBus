//
//  UIView+ShowHua.m
//  Company
//
//  Created by 小小隆 on 2018/6/11.
//  Copyright © 2018年 BaiDu. All rights reserved.
//

#import "UIView+ShowHua.h"

@implementation UIView (ShowHua)

-(void)showHUDWithMessage:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = msg;
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:2.0];
    });
}

-(void)showMBProgressHUD{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.tag = 999;
    [self addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

-(void)hideMBProgressHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:999];
        [hud hide:YES];
        hud = nil;
    });
    
}

@end

