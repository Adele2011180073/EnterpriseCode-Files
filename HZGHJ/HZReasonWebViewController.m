//
//  HZReasonWebViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/7/30.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZReasonWebViewController.h"
#import "MBProgressHUD.h"
#import "HZURL.h"
#import "HZBanShiService.h"
#import "UIView+Toast.h"

@interface HZReasonWebViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>{
    UIWebView *_webview;
}

@end

@implementation HZReasonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"查看原因";
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self getid];
    
}
-(void)getid{
    [HZBanShiService BanShiWithId:self.resuuid AddBlock:^(NSDictionary *returnDic, NSError *error) {
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            NSArray *obj=[returnDic objectForKey:@"obj"];
            NSDictionary *dic=[obj objectAtIndex:0];
            _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64)];
            NSString *serviceURL=[NSString stringWithFormat:@"%@%@?fileId=%@",kDemoBaseURL,kGetFileURL,[dic objectForKey:@"id"]];
            serviceURL = [serviceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *urlRequest=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:serviceURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
            _webview.delegate=self;
            [_webview loadRequest:urlRequest];
            [self.view addSubview:_webview];
                   }else{
            [self.view makeToast:[returnDic objectForKey:@"desc"] duration:2 position:CSToastPositionCenter];
        }

    }];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"请求超时" message:@"请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    NSLog(@"error   %@",[error localizedDescription]);
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.labelText = @"数据请求中，请稍后...";
    });
   
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (BOOL)navigationShouldPopOnBackButton{
    if (_webview.canGoBack) {
        [_webview goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    return NO;
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
