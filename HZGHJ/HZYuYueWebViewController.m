//
//  HZYuYueWebViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/8/25.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZYuYueWebViewController.h"
#import "MBProgressHUD.h"
#import "HZURL.h"
#import <WebKit/WebKit.h>
@interface HZYuYueWebViewController ()<WKNavigationDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIWebViewDelegate>{
    UIWebView *webview;
}


@end

@implementation HZYuYueWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"样表";
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64)];
    NSString *serviceURL=[NSString stringWithFormat:@"%@",self.url];
    NSLog(@"serviceURL   %@",serviceURL);
    serviceURL = [serviceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:serviceURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
//    webview.navigationDelegate=self;
    webview.scalesPageToFit = YES;
    [webview loadRequest:urlRequest];
    [self.view addSubview:webview];

}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.labelText = @"数据请求中，请稍后...";
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"请求超时" message:@"请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

}



//-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    progressHUD.labelText = @"数据请求中，请稍后...";
//}
//-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"请求超时" message:@"请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
//    NSLog(@"error   %@",[error localizedDescription]);
//}
//-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];  
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
