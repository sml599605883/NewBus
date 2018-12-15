//
//  Bus_BikeViewController.m
//  NewsBus
//
//  Created by WithLove on 2018/12/11.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_BikeViewController.h"
#import "QRCode.h"
#import "TZImagePickerController.h"
#import "QRScanBottomView.h"
#import <CoreImage/CoreImage.h>
#import "Bus_Put_Coding.h"
#import "Bus_MainTian_Controller.h"
#import "Bus_Report_Controller.h"

/**自己调整位置 */
#define Device_Width  [[UIScreen mainScreen] bounds].size.width//获取屏幕宽高
#define Device_Height [[UIScreen mainScreen] bounds].size.height
#define NAVH (MAX(Device_Width, Device_Height)  == 812 ? 88 : 64)
/** 扫描内容的 W 值 */
#define scanBorderW 0.7 * [UIScreen mainScreen].bounds.size.width
/** 扫描内容的 x 值 */
#define scanBorderX 0.5 * (1 - 0.7) * [UIScreen mainScreen].bounds.size.width
/** 扫描内容的 Y 值 */
#define scanBorderY 0.32 * (self.view.frame.size.height - scanBorderW)

@interface Bus_BikeViewController ()<TZImagePickerControllerDelegate>
{
    NSString *str;
}
@property (nonatomic, strong) QRCodeScanManager *scanManager;
@property (nonatomic, strong) QRCodeScanView *scanView;
@property(nonatomic,strong)UIView *topContainer;//包一层是防止push动画的的问题（不能为纯透明）
@property (nonatomic, strong) UILabel *promptLabel;//提示文字
@property (nonatomic, strong) QRScanBottomView *bottomBtnView;/** 底部按钮view*/
@property (nonatomic, strong) UIButton *reportButton;   //举报按钮
@property (nonatomic, strong) UIButton *serviceButton;  //客服按钮
@property (nonatomic, strong) UIButton *maintianButton; //维修按钮
@property (atomic, assign) BOOL canceled;

@end

@implementation Bus_BikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addMyNavigationView];
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.text = @"附近小单车";
    
    self.myNavigation.backgroundColor = [UIColor clearColor];
    UIImageView *img = [self.myNavigation viewWithTag:10090];
    [self hideNavigationUnderLine];
    [img removeFromSuperview];
//    [self.myNavigation addSubview:lab];
    
    self.view.backgroundColor =[UIColor clearColor];
    [self setUp];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self beginScanManager];
    
    if (self.bikeStr.length == 0 || self.bikeStr == nil) {
        [self.view addSubview:self.reportButton];
        [self.view addSubview:self.serviceButton];
        [self.view addSubview:self.maintianButton];
        [self.view addSubview:self.bottomBtnView];
    }
    
}

- (void)beginScanManager {
    [self.scanView addTimer];
    [_scanManager startRunning];
    [_scanManager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScan];
}

- (void)setUp {
    [self.view addSubview:self.topContainer];
    [self.topContainer addSubview:self.scanView];
    [self.topContainer addSubview:self.promptLabel];
    [self setupScanManager];
    
}

- (void)setupScanManager {
    self.scanManager = [QRCodeScanManager sharedManager];
    
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    [_scanManager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    
    __weak __typeof(self)weakSelf = self;
    //光扫描结果回调
    [_scanManager scanResult:^(NSArray *metadataObjects) {
        if (metadataObjects != nil && metadataObjects.count > 0) {
            [weakSelf.scanManager playSoundName:@"sound.caf"];
            //obj 为扫描结果
            [self stopScan];//为防止 重复识别二维码 多次跳转界面
            AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
            NSString *str = obj.stringValue;
            if ([str isEqualToString:@"我是小单车"]) {
                if (self.bikeStr.length != 0 || self.bikeStr != nil) {
                    self.backBikeNumber(@"9089432");
                    [self back:nil];
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.tag = 1090;
                    // Set the determinate mode to show task progress.
                    hud.mode = MBProgressHUDModeDeterminate;
                    //    NSString *str = [NSString stringWithFormat:@"%.1f%%",Float*100];
                    hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                        // Do something useful in the background and update the HUD periodically.
                        [self doSomeWorkWithProgress];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [NSThread sleepForTimeInterval:3];
                            [hud hideAnimated:YES];
                            MBProgressHUD *hudd = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            // Set the custom view mode to show any view.
                            hudd.mode = MBProgressHUDModeCustomView;
                            // Set an image view with a checkmark.
                            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                            hudd.customView = [[UIImageView alloc] initWithImage:image];
                            // Looks a bit nicer if we make it square.
                            hudd.square = YES;
                            // Optional label text.
                            hudd.label.text = NSLocalizedString(@"开锁失败", @"HUD done title");
                            hudd.detailsLabel.text = NSLocalizedString(@"请靠近小单车在进行开锁", @"HUD title");
                            [hudd hideAnimated:YES afterDelay:3.f];
                            [self beginScanManager];
                        });
                    });
                });
                
                
                return;
            }
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"这不是小单车的二维码哦";
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:2.0];
            [self performSelector:@selector(beginScanManager) withObject:hud afterDelay:2.1];
        } else {
//            [self.view showHUDWithMessage:@"暂未识别出扫描的二维码"];
//            NSLog(@"暂未识别出扫描的二维码");
        }
    }];
    
    //光纤变化回调
    [_scanManager brightnessChange:^(CGFloat brightness) {
        [weakSelf.scanView lightBtnChangeWithBrightnessValue:brightness];
    }];
    
}

- (void)doSomeWorkWithProgress {
//    self.canceled = NO;
//    This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 0.8f) {
        //        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
            MBProgressHUD *hud = [self.navigationController.view viewWithTag:1090];
            NSString *str = [NSString stringWithFormat:@"%.1f%%",progress*100];
            hud.label.text = NSLocalizedString(str, @"HUD loading title");
        });
        usleep(50000);
    }
}

- (UIView *)topContainer {
    if (!_topContainer) {
        _topContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, SCR_H)];
        _topContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _topContainer;
}
-(QRCodeScanView *)scanView{
    if (!_scanView) {
        _scanView =[[QRCodeScanView alloc]initWithFrame:CGRectMake(scanBorderX, scanBorderY, scanBorderW, scanBorderW)];
    }
    return _scanView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanView.frame) +50, Device_Width, 20)];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text = @"将小单车二维码对准，即可自动扫描";
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.backgroundColor = [UIColor clearColor];
    }
    return _promptLabel;
}

- (QRScanBottomView *)bottomBtnView {
    if (!_bottomBtnView) {
        _bottomBtnView = [[QRScanBottomView alloc] initWithFrame:CGRectMake((SCR_W - 240)/2, Device_Height - 140, 240, 40) showType:ShowTypeInputCode];
        _bottomBtnView.layer.cornerRadius = 20;
        _bottomBtnView.layer.masksToBounds = YES;
        _bottomBtnView.backgroundColor = RGBA(0, 99, 255, 0.6);
        [_bottomBtnView.inputCodeBtn addTarget:self action:@selector(inputBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomBtnView.albumBtn addTarget:self action:@selector(albumBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _bottomBtnView;
}
/**
 举报按钮
 */
- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] initWithFrame:CGRectMake((SCR_W - 240) /2, self.bottomBtnView.frame.origin.y + 50, 50, 50)];
        [_reportButton setImage:[UIImage imageNamed:@"举报"] forState:UIControlStateNormal];
        _reportButton.backgroundColor = [UIColor orangeColor];
        _reportButton.layer.cornerRadius = 25;
        _reportButton.tag = 10907;
        _reportButton.alpha = 0.4;
        _reportButton.layer.masksToBounds = YES;
        [_reportButton addTarget:self action:@selector(reportButtonDidPressWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}
/**
 客服按钮
 */
- (UIButton *)serviceButton {
    if (!_serviceButton) {
        _serviceButton = [[UIButton alloc] initWithFrame:CGRectMake(((SCR_W - 240) /2) + 95, self.reportButton.frame.origin.y, 50, 50)];
        [_serviceButton setImage:[UIImage imageNamed:@"客服"] forState:UIControlStateNormal];
        _serviceButton.backgroundColor = [UIColor orangeColor];
        _serviceButton.layer.cornerRadius = 25;
        _serviceButton.tag = 10908;
        _serviceButton.alpha = 0.4;
        _serviceButton.layer.masksToBounds = YES;
        [_serviceButton addTarget:self action:@selector(reportButtonDidPressWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceButton;
}
/**
 维修按钮
 */
- (UIButton *)maintianButton {
    if (!_maintianButton) {
        _maintianButton = [[UIButton alloc] initWithFrame:CGRectMake(((SCR_W - 240) /2) + 190, self.reportButton.frame.origin.y, 50, 50)];
        [_maintianButton setImage:[UIImage imageNamed:@"维修"] forState:UIControlStateNormal];
        _maintianButton.backgroundColor = [UIColor orangeColor];
        _maintianButton.layer.cornerRadius = 25;
        _maintianButton.tag = 10909;
        _maintianButton.alpha = 0.4;
        _maintianButton.layer.masksToBounds = YES;
        [_maintianButton addTarget:self action:@selector(reportButtonDidPressWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maintianButton;
}

#pragma mark 底部按钮点击事件
- (void)inputBtnClick {
    Bus_Put_Coding *put = [[Bus_Put_Coding alloc] init];
    [self.navigationController pushViewController:put animated:YES];
    NSLog(@"点击手动输入");
}

- (void)reportButtonDidPressWithButton:(UIButton *)sender {
    if (sender.tag == 10907) {
        Bus_Report_Controller *report = [[Bus_Report_Controller alloc] init];
        [self.navigationController pushViewController:report animated:YES];
    } else if (sender.tag == 10908) {
        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"4000091717"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认电话呼叫客服?" message:@"400 009 1717" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        Bus_MainTian_Controller *mainTian = [[Bus_MainTian_Controller alloc] init];
        [self.navigationController pushViewController:mainTian animated:YES];
    }
    
}

#pragma mark 停止扫描
- (void)stopScan {
    [self.scanView removeTimer];
    [_scanManager stopRunning];
    [_scanManager cancelSampleBufferDelegate];
}


@end
