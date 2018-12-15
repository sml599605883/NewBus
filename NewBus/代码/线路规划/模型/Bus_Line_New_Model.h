//
//  Bus_Line_New_Model.h
//  NewsBus
//
//  Created by WithLove on 2018/11/20.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Bus_Line_New_Model : NSObject

+(Bus_Line_New_Model *)sharedDataHandle;


-(void)addOneMovie:(id)movie;
-(void)deleteMovieByID:(int)delID;
-(id)getAllMovies;

@end

NS_ASSUME_NONNULL_END
