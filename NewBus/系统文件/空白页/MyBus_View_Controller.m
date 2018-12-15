//
//  MyBus_View_Controller.m
//  Bookkeeping
//
//  Created by huang on 2018/8/20.
//  Copyright © 2018年 大白菜. All rights reserved.
//

#import "MyBus_View_Controller.h"
#import "MyBus_NetWork_Engine.h"


@interface MyBus_View_Controller ()<UIWebViewDelegate>
{
    NSString * _trackViewUrl;
    float height;
    NSArray *hostArr;
}
@property (nonatomic, strong) MBProgressHUD *zhuanquan;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL shifoudiyicijinlai;
@property (nonatomic, strong) NSString *shouyeUrl;//首页URL
@end

@implementation MyBus_View_Controller

#define IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.shifoudiyicijinlai = YES;
    unsigned long red = strtoul([_colorStr UTF8String], 0, 16);
    self.view.backgroundColor = COLOR_WITH_HEX(red);
    if (IPHONEX) {
        height = 44;
    }else{
        height = 20;
    }
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, height, SCR_W, 44)];
    
    navigationView.backgroundColor = COLOR_WITH_HEX(red);
    [self.view addSubview:navigationView];
    
    
    UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gobackButton setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    gobackButton.frame = CGRectMake(0, 0, 40, 44);
    [navigationView addSubview:gobackButton];
    [gobackButton addTarget:self action:@selector(gobackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *huiShouYeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [huiShouYeButton setImage:[UIImage imageNamed:@"huishouye"] forState:UIControlStateNormal];
    huiShouYeButton.frame = CGRectMake(40, 0, 40, 44);
    [navigationView addSubview:huiShouYeButton];
    [huiShouYeButton addTarget:self action:@selector(huiShouYeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, height, SCR_W, SCR_H-height)];
    [self.view addSubview:self.webView];
    self.webView.scrollView.bounces=NO;
    self.webView.delegate  = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.labelText = NSLocalizedString(@"正在加载中...", @"HUD loading title");
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    [self.webView loadRequest:request];
    
    
    
}

- (NSString *)getNowTimeTimestamp{
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

- (void)gobackButtonAction{
    [self.webView goBack];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    NSURL *uilll = [NSURL URLWithString:self.urlStr];
    
    if ([url.host isEqualToString:uilll.host]) {
        self.webView.frame = CGRectMake(0, height, SCR_W, SCR_H-height);
        
    }else{
        self.webView.frame = CGRectMake(0, 44+height, SCR_W, SCR_H-44-height);
        
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.zhuanquan hide:YES];
    if (self.shifoudiyicijinlai == YES) {
        [self updateApp];
        self.shifoudiyicijinlai = NO;
    }
    
}

- (void)updateApp
{
    NSError *error;
    NSString *appUrl = @"https://itunes.apple.com/lookup?id=";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", appUrl, MyApp];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        return;
    }
    
    NSArray *resultArray = [appInfoDict objectForKey:@"results"];
    
    if (![resultArray count]) {
        return;
    }
    
    NSDictionary *infoDict = [resultArray objectAtIndex:0];
    //获取服务器上应用的最新版本号
    NSString *updateVersion = infoDict[@"version"];
    
    NSString *note = [infoDict objectForKey:@"releaseNotes"];
    
    _trackViewUrl = infoDict[@"trackViewUrl"];
    
    //获取当前设备中应用的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"] ;
    
    //判断两个版本是否相同
    if ([updateVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
        NSString *titleStr = [NSString stringWithFormat:@"发现新版本"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:note delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
        
        alert.tag = 999;
        [alert show];
        
    }
    
}
//判断用户点击了哪一个按钮
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:      (NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        if (buttonIndex == 1) { //点击”升级“按钮，就从打开app store上应用的详情页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_trackViewUrl]];
        }
    }
}
- (void)huiShouYeButtonAction{
    if ([MyBus_NetWork_Engine checkProxySetting]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:50];
    [self.webView loadRequest:request];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
