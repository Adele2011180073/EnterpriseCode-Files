//
//  HZProjectViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/13.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZProjectViewController.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "HZLoginService.h"

@interface HZProjectViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    UIScrollView *bgScrollView;
}

@end

@implementation HZProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"项目过程上报";
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, 700)];
    bgScrollView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    bgScrollView.userInteractionEnabled=YES;
    [self.view addSubview:bgScrollView];
    
    [self addSubviews];
}
-(void)addSubviews{
    NSArray *subArray=@[@"选择项目名称",@"添加照片",@"添加文字"];
//    NSDictionary *messageDic=[returnData objectForKey:@"message"];
//    NSString *str1=[messageDic objectForKey:@"title"];
//    NSString *str2=[messageDic objectForKey:@"detail"];
//    if (str1==NULL||str1==nil)  str1=@"";
//    if (str2==NULL||str2==nil)  str2=@"";
//    NSArray *textArray=@[str1,str2];
    for (int i=0; i<3; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 80*i, 140, 40)];
        if (i==1) {
            label.frame=CGRectMake(30, 230, 140, 40);
        }else   if (i==2) {
            label.frame=CGRectMake(30, 320, 140, 40);
        }

        label.textAlignment=NSTextAlignmentLeft;
        label.text=[subArray objectAtIndex:i];
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:16];
        [self.view addSubview:label];
    }
       for (int i=0; i<5; i++) {
           UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 40)];
           bgView.backgroundColor=[UIColor whiteColor];
           bgView.userInteractionEnabled=YES;
           [bgScrollView addSubview:bgView];
           
           if (i==0) {
               
           }
       }
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 0,Width-80, 40)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    [button addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    
    [bgScrollView addSubview:button];
    
}
-(void)commit{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
