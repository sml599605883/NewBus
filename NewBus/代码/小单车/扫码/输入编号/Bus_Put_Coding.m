//
//  Bus_Put_Coding.m
//  NewsBus
//
//  Created by WithLove on 2018/12/12.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_Put_Coding.h"
#import <AVFoundation/AVFoundation.h>

@interface Bus_Put_Coding ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberTf;

@end

@implementation Bus_Put_Coding

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMyNavigationView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"输入编号骑单车";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
//    if ([string isEqualToString:@"\n"]) {
//        //按会车可以改变
//        return YES;
//    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 7) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:7];
        return NO;
        
    }
    
    return YES;
    
}

- (IBAction)openLightButton:(UIButton *)sender {
    
    if (sender.selected == NO) {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    } else {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
    sender.selected = !sender.selected;
}

- (IBAction)openLockButton:(id)sender {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag = 999;
    [self.view addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    srand48(time(0));
    double r = drand48();
    [self performSelector:@selector(hiddenHud) withObject:hud afterDelay:r];
}

- (void)hiddenHud {
    
    MBProgressHUD *hudd = (MBProgressHUD *)[self.view viewWithTag:999];
    [hudd hideAnimated:YES];
    hudd = nil;
    
    if ([self.numberTf.text isEqualToString:@"9089432"]) {
        [self.view showHUDWithMessage:@"小单车离您太远了..."];
        return;
    }
    
    [self.view showHUDWithMessage:@"在您附近并未找到这辆小单车"];
    
}

@end
