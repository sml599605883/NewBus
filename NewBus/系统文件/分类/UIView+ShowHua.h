//
//  UIView+ShowHua.h
//  Company
//
//  Created by 小小隆 on 2018/6/11.
//  Copyright © 2018年 BaiDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShowHua)

//提示框
-(void)showHUDWithMessage:(NSString *)msg;

//显示菊花
-(void)showMBProgressHUD;
//隐藏菊花
-(void)hideMBProgressHUD;

@end
