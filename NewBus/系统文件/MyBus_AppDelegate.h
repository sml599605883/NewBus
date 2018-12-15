//
//  MyBus_AppDelegate.h
//  NewBus
//
//  Created by 嘎嘎嘎 on 2018/12/15.
//  Copyright © 2018 嘎嘎嘎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MyBus_Main_Controller.h"
#import "MyBus_Whiet_Controller.h"

@interface MyBus_AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) MyBus_Main_Controller *mainVC;
@property (strong, nonatomic) MyBus_Whiet_Controller *bkVC;

- (void)saveContext;


@end

