//
//  HZNewsDetailViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/15.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZNewsDetailViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"
#import "HZURL.h"
@interface HZNewsDetailViewController ()<UIGestureRecognizerDelegate>{
    NSDictionary *returnData;
    NSDictionary *totalDic;
    UIScrollView* bgView;
}


@end

@implementation HZNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"公告详情";
    returnData=[[NSDictionary alloc]init];
    [self getResourceData];
    bgView=[[UIScrollView alloc]init];

}
-(void)getResourceData{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [HZLoginService NewsWithRecordId:self.recordid andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            returnData=[returnDic objectForKey:@"obj"];
            [self addSubviews];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900||[[returnDic objectForKey:@"code"]integerValue]==1000) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
        }
    }];
}
-(void)addSubviews{
//    UIView *topBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height/17*6)];
//    topBgView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:topBgView];
    NSArray *subArray=@[@"消息标题",@"公告内容"];
    NSDictionary *messageDic=[returnData objectForKey:@"message"];
    NSString *str1=[messageDic objectForKey:@"title"];
    NSString *str2=[messageDic objectForKey:@"detail"];
    if (str1==NULL||str1==nil)  str1=@"";
    if (str2==NULL||str2==nil)  str2=@"";
     NSArray *textArray=@[str1,str2];
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 80*i, 100, 40)];
        label.textAlignment=NSTextAlignmentLeft;
        label.text=[subArray objectAtIndex:i];
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:16];
        [self.view addSubview:label];
        
        UIView *topBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 40+80*i, Width, 40)];
        topBgView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:topBgView];
        
        UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width -20, 20)];
        text.textAlignment=NSTextAlignmentLeft;
        text.text=[textArray objectAtIndex:i];
        text.font=[UIFont systemFontOfSize:16];
        [topBgView addSubview:text];
        if (i==1) {
            text.numberOfLines=0;
            text.lineBreakMode = NSLineBreakByTruncatingTail;
            
            CGSize maximumLabelSize = CGSizeMake(Width-20, 9999);//labelsize的最大值
            
            //关键语句
            
            CGSize expectSize = [text sizeThatFits:maximumLabelSize];
            
            //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
            
            text.frame = CGRectMake(20, 0, expectSize.width, expectSize.height+20);
            topBgView.frame=CGRectMake(0, 40+80*i, Width, expectSize.height+20);
        }
        
        
    }

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
