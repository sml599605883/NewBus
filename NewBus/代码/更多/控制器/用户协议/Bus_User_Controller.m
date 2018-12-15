//
//  Bus_User_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/21.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_User_Controller.h"

@interface Bus_User_Controller ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation Bus_User_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addMyNavigationView];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"协议";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
    [self hideNavigationUnderLine];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGPoint offset = self.textView.contentOffset;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        
        [self.textView setContentOffset: offset];
        
    }];
    
}



@end
