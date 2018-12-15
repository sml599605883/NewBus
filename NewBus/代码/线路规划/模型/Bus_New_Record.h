//
//  Bus_New_Record.h
//  NewsBus
//
//  Created by WithLove on 2018/11/20.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Bus_New_Record : NSObject

@property(nonatomic,assign)int recordID;

@property (nonatomic, strong)NSString *start;
@property (nonatomic, strong)NSString *end;
@property (nonatomic, strong)NSString *time;

@end

NS_ASSUME_NONNULL_END
