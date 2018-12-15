//
//  Bus_Report_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/12/14.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_Report_Controller.h"
#import "Bus_BikeViewController.h"

@interface Bus_Report_Controller ()<UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *qrButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTf;
@property (weak, nonatomic) IBOutlet UIImageView *weizhangImage;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation Bus_Report_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addMyNavigationView];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"举报不文明行为";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
}
- (IBAction)headerImage:(id)sender {
    [self presentViewControllerWithHeaderImage];
}

- (void)presentViewControllerWithHeaderImage {
    //弹出系统提示框
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    //添加控制按钮
    [alertC addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调出摄像头
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] && ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            return;
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.showsCameraControls = YES;
        imagePickerController.allowsEditing= NO;
        
        imagePickerController.delegate=self;
        [self presentViewController:imagePickerController animated:NO completion:nil];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调出系统的相片库
        // 点中相册控制按钮回调的代码块
        UIImagePickerController *albunmPicker=[[UIImagePickerController alloc]init];
        albunmPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        albunmPicker.delegate = self;
        [self presentViewController:albunmPicker animated:YES completion:nil];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@" 取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

//切换头像
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *imag = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    self.weizhangImage.image = imag;
    
//    NSData *data =  UIImageJPEGRepresentation(imag, 0.3f);
//    NSString *str = [data base64EncodedStringWithOptions:0];
//    [self requstDataUserImageBase:str];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    if ([toBeString length] > 140) { //如果输入框内容大于20则弹出警告
        textView.text = [toBeString substringToIndex:140];
        return NO;
    }
    
    return YES;
}

- (IBAction)qrButtonDidPress:(id)sender {
    Bus_BikeViewController *bike = [[Bus_BikeViewController alloc] init];
    bike.bikeStr = @"sss";
    bike.backBikeNumber = ^(NSString *str) {
        self.numberTf.text = str;
    };
    [self.navigationController pushViewController:bike animated:YES];
}

- (IBAction)senderButton:(id)sender {
    if ([self.numberTf.text isEqualToString:@"9089432"]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.tag = 999;
        [self.view addSubview:hud];
        hud.removeFromSuperViewOnHide = YES;
        [hud showAnimated:YES];
        int x = arc4random() % 9;
        int y = (arc4random() % 10);
        NSString *str=[NSString stringWithFormat:@"%d.%d",y,x];
        CGFloat f = [str floatValue];
        [self performSelector:@selector(showTextToView) withObject:hud afterDelay:f];
        return;
    }
    [self.view showHUDWithMessage:@"请输入正确小单车编号"];
}

- (void)showTextToView {
    MBProgressHUD *lasdHud = (MBProgressHUD *)[self.view viewWithTag:999];
    [lasdHud hideAnimated:YES];
    lasdHud = nil;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"反馈成功!";
    hud.detailsLabel.text = @"我们会尽快核实!";
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2.0];
    [self performSelector:@selector(back:) withObject:hud afterDelay:2.1];
}

@end
