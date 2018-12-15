//
//  NewShareActivity.h
//  JBRJ
//
//  Created by WithLove on 2018/9/21.
//  Copyright © 2018年 WithLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewShareActivity : UIActivity

-(instancetype)initShareWithTitle:(NSString *)title ActivityWithImage:(UIImage *)activityImage ShareURL:(NSURL *)url ActivityWithType:(NSString *)activityType;

@end
