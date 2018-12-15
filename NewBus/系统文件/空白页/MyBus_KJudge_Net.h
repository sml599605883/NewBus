//
//  MyBus_KJudge_Net.h
//  CCFinance
//
//  Created by liangyuan on 16/8/5.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBus_KJudge_Net : NSObject
@property (nonatomic,assign,readonly,getter=isConnection) BOOL Connection;
@property (nonatomic,copy,readonly) NSString* netStatus;

+(instancetype)shareJudgeNet;

@end
