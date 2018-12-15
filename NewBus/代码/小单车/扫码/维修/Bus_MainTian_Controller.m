//
//  Bus_MainTian_Controller.m
//  NewsBus
//
//  Created by WithLove on 2018/12/14.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_MainTian_Controller.h"
#import "ljhCheckbox.h"
#import "Bus_BikeViewController.h"

@interface Bus_MainTian_Controller ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *selectLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (nonatomic, strong)ljhCheckbox *btn;

@end

@implementation Bus_MainTian_Controller

- (ljhCheckbox *)btn {
    if (!_btn) {
        _btn = [[ljhCheckbox alloc]initWithFrame:self.selectLab.frame];
        _btn.titleLabel.font=[UIFont systemFontOfSize:14];
//        [_btn setTitle:@"多选按钮" forState:UIControlStateNormal];
//        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _btn.backgroundColor=[UIColor groupTableViewBackgroundColor];
        _btn.layer.cornerRadius=10;
        _btn.clipsToBounds=YES;
    }
    return _btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *myarr= [NSArray arrayWithObjects:@"车把损坏",@"车筐损坏",@"瓦盖损坏",@"车座损坏",@"踏板损坏",@"车轮损坏",@"刹车损坏",@"铃铛损坏",@"车链脱离",@"车胎损坏",@"关锁失败",@"开锁失败",@"车锁损坏",@"被上私锁",@"其他问题", nil];
    [self.btn mybuttonwithArr:myarr andTitle:@"故障原因"andMessage:@""];
    
    [self addMyNavigationView];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCR_W, FitX(20))];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"故障报修";
    [self.myNavigation addSubview:lab];
    [self addBackButton];
    
    MJWeakSelf
    
    [self.btn setFinishBlock:^(NSString *choice) {
        
        weakSelf.selectLab.text = choice;
        
    }];
    
    [self.view addSubview:self.btn];
}

- (IBAction)scanButton:(id)sender {
    Bus_BikeViewController *bike = [[Bus_BikeViewController alloc] init];
    bike.bikeStr = @"sss";
    bike.backBikeNumber = ^(NSString * str) {
        self.textField.text = str;
    };
    [self.navigationController pushViewController:bike animated:YES];
}

- (IBAction)senderButtonDidPress:(id)sender {
    if ([self.textField.text isEqualToString:@"9089432"]) {
        if ([self.selectLab.text isEqualToString:@"损坏类型"]) {
            [self.view showHUDWithMessage:@"请选择损坏类型"];
            return;
        }
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
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2.0];
    [self performSelector:@selector(back:) withObject:hud afterDelay:2.1];
}

- (IBAction)touchUpInside:(id)sender {
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
    self.selectImage.image = imag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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

@end
