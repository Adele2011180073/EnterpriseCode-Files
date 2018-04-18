//
//  HZBiaoGeContentWebViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/8/24.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZBiaoGeContentWebViewController.h"
#import "MBProgressHUD.h"
#import "HZURL.h"
#import <WebKit/WebKit.h>

@interface HZBiaoGeContentWebViewController ()<WKNavigationDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>{
    WKWebView *webview;
}


@end

@implementation HZBiaoGeContentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"常用表格";
    webview=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64)];
    NSString *serviceURL=[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[self.sourceData objectForKey:@"fileid"]];
    serviceURL = [serviceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:serviceURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    webview.navigationDelegate=self;
    [webview loadRequest:urlRequest];
    [self.view addSubview:webview];
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.labelText = @"数据请求中，请稍后...";
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"请求超时" message:@"请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    NSLog(@"error   %@",[error localizedDescription]);
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
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
