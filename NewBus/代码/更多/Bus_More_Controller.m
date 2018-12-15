//
//  Bus_More_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/11/9.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_More_Controller.h"
#import "Bus_More_Cell.h"

#import "NewShareActivity.h"
#import "Bus_Help_Controller.h"
#import "Bus_Advice_Controller.h"
#import "Bus_User_Controller.h"
#import "Bus_About_Our_Controller.h"

@interface Bus_More_Controller ()<UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate>
{
    NSArray *arr;
    NSArray *imgArr;
}
@property(nonatomic,strong)UITableView *table;

@end

@implementation Bus_More_Controller

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + SELF_NAV_BAR_HEGHT, SCR_W, SCR_H - STATUS_BAR_HEIGHT - SELF_NAV_BAR_HEGHT - TAB_BAR_HEIGHT - BottomSafeArea) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Bus_More_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Bus_More_Cell"];
        if (!cell) {
            cell = [[Bus_More_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Bus_More_Cell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.img.image = [UIImage imageNamed:@""];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow(CFBridgingRetain(infoDictionary));
        cell.labTwoTitle.text = [NSString stringWithFormat:@"当前版本 %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
        cell.labTitle.text = @"现金巴士";
        cell.img.image = [UIImage imageNamed:@"WechatIMG79"];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Bus_More_Controller"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Bus_More_Controller"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
        cell.textLabel.text = arr[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            Bus_Help_Controller *help = [[Bus_Help_Controller alloc] init];
            [self.navigationController pushViewController:help animated:YES];
        } else if (indexPath.row == 1) {
            Bus_Advice_Controller *advice = [[Bus_Advice_Controller alloc] init];
            [self.navigationController pushViewController:advice animated:YES];
        } else if (indexPath.row == 2) {
            [self itIsBigDream];
        } else if (indexPath.row == 3) {
            Bus_User_Controller *user = [[Bus_User_Controller alloc] init];
            [self.navigationController pushViewController:user animated:YES];
        } else if (indexPath.row == 4) {
            Bus_About_Our_Controller *about = [[Bus_About_Our_Controller alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (void)itIsBigDream {
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = @"现金巴士";
    UIImageView *ii = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatIMG79"]];
//    if (self.bModel.photo.count > 0) {
//        [ii sd_setImageWithURL:self.bModel.photo[0]];
//    }
    UIImage *shareImage = ii.image;
    NSURL *shareUrl = [NSURL URLWithString:@""];
    NSArray *activityItemsArray = [[NSArray alloc] init];
    if (shareImage == nil) {
        activityItemsArray = @[shareText,shareUrl];
    }else{
        activityItemsArray = @[shareText,shareImage,shareUrl];
    }
//
    // 自定义的CustomActivity，继承自UIActivity
    NewShareActivity *customActivity = [[NewShareActivity alloc]initShareWithTitle:@"现金巴士" ActivityWithImage:[UIImage imageNamed:@"WechatIMG79"] ShareURL:[NSURL URLWithString:@"http://blog.csdn.net/flyingkuikui"] ActivityWithType:@"Custom"];
    NSArray *activityArray = @[customActivity];
    
    
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    activityVC.modalInPopover = YES;
    // 3、设置回调
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // ios8.0 之后用此方法回调
        UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
//            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
//                NSLog(@"分享");
            } else {
//                NSLog(@"取消");
            }
        };
        
        activityVC.completionWithItemsHandler = itemsBlock;
    }else{
        // ios8.0 之前用此方法回调
        UIActivityViewControllerCompletionHandler handlerBlock = ^(UIActivityType __nullable activityType, BOOL completed){
//            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
//                NSLog(@"completed");
            }else{
//                NSLog(@"cancel");
            }
        };
        activityVC.completionHandler = handlerBlock;
    }
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityVC animated:YES completion:nil];
    } else {//if iPad
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        popup.delegate = self;
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    }
//    // 4、调用控制器
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        activityVC.popoverPresentationController.sourceView = self.view;
//        [self presentViewController:activityVC animated:YES completion:nil];
//    } else {
//        [self presentViewController:activityVC animated:YES completion:nil];
//    }


}



- (void)viewDidLoad {
    [super viewDidLoad];
    imgArr = @[@"指南",@"问题解答",@"fenxiang",@"xieyi",@"women"];
    arr = @[@"使用指南",@"建议和问题",@"分享给好友",@"用户协议",@"关于我们"];
    
    [self addMyNavigationView];
//    self.myNavigation.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCR_W, 40);
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"我们";
    [self.myNavigation addSubview:lab];
    
    [self.view addSubview:self.table];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

@end
