//
//  MyBus_KJudge_Net.m
//  CCFinance
//
//  Created by liangyuan on 16/8/5.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import "MyBus_KJudge_Net.h"

static MyBus_KJudge_Net *judge = nil;
@implementation MyBus_KJudge_Net

-(BOOL)isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    if (!isExistenceNetwork) {
        return NO;
    }
    return isExistenceNetwork;
}
- (BOOL)isConnection{
    return [self isConnectionAvailable];
}

- (NSString*)netStatus{
    NSString *str = nil;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case ReachableViaWiFi:
            str = @"WIFI";
            break;
        case ReachableViaWWAN:
            str = @"数据网络";
            break;
        default:
            str = @"网络连接异常";
            break;
    }
    return str;
}
//单例
+ (instancetype)shareJudgeNet{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        judge = [[MyBus_KJudge_Net alloc]init];
    });
    return judge;
}
@end
