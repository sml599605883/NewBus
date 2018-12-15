//
//  MyBus_NetWork_Engine.h
//  SmallWallet
//
//  Created Super Star on 2018/3/6.
//  Copyright © 2018年 大白菜. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
typedef void (^FYCompletioBlock)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^FYSuccessBlock)(NSDictionary *data);
typedef void (^FYCodeBlock)(NSData *data);
typedef void (^FYFailureBlock)(NSError *error);

@interface MyBus_NetWork_Engine : NSObject
/**
 *  get请求
 */
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(FYSuccessBlock)successBlock failure:(FYFailureBlock)failureBlock;
+(void)ImageUrlString:(NSString *)url parameters:(id)parameters success:(FYCodeBlock)successBlock failure:(FYFailureBlock)failureBlock;

/**
 * post请求
 */
+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(FYSuccessBlock)successBlock failure:(FYFailureBlock)failureBlock;
+ (BOOL)checkProxySetting;
@end
