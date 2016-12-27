//
//  HZBanShiViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/9.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZBanShiViewController.h"
#import "MBProgressHUD.h"
#import "HZURL.h"
#import "UIViewController+BackButtonHandler.h"

@interface HZBanShiViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>{
    UIWebView *webview;
}


@end

@implementation HZBanShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"办事指南";
    
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44-20)];
    NSString *serviceURL=[NSString stringWithFormat:@"%@",kBsznListURL];
    NSMutableURLRequest *urlRequest=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:serviceURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    webview.delegate=self;
    [webview loadRequest:urlRequest];
    [self.view addSubview:webview];
}
- (BOOL)navigationShouldPopOnBackButton{
    if (webview.canGoBack) {
        [webview goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    return NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"请求超时" message:@"请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    NSLog(@"error   %@",[error localizedDescription]);
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.label.text = @"数据请求中，请稍后...";
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
