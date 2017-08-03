//
//  HZLoginViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/7.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZLoginViewController.h"
#import  "MBProgressHUD.h"
#import "HZURL.h"
#import "HZLoginService.h"
#import "HZHomeViewController.h"
#import "UIView+Toast.h"
#import "HZRegisterViewController.h"

@interface HZLoginViewController ()
{
    BOOL isRemember;
}

@end

@implementation HZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
     self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];

}

- (IBAction)remember:(id)sender {
    isRemember =!isRemember;
    if (isRemember==YES) {
        self.userText.userInteractionEnabled=NO;
        self.passwdText.userInteractionEnabled=NO;
        self.userText.textColor=[UIColor grayColor];
        self.passwdText.textColor=[UIColor grayColor];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:self.userText.text forKey:@"username"];
        [def setObject:self.passwdText.text forKey:@"passwd"];
        NSLog(@"self.userText   %@  self.passwdText  %@",self.userText .text,self.passwdText.text);
         [def setBool:YES forKey:@"remember"];
        [def synchronize];
        [self.rememberBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateNormal];
    }else{
        self.userText.userInteractionEnabled=YES;
        self.passwdText.userInteractionEnabled=YES;
        self.userText.textColor=[UIColor blackColor];
        self.passwdText.textColor=[UIColor blackColor];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"remember"];
        [self.rememberBtn setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([def boolForKey:@"remember"]==YES) {
        isRemember=YES;
        NSString *username=[def objectForKey:@"username"];
        NSString *passwd=[def objectForKey:@"passwd"];
        self.userText.userInteractionEnabled=NO;
        self.passwdText.userInteractionEnabled=NO;
        self.userText.textColor=[UIColor grayColor];
        self.passwdText.textColor=[UIColor grayColor];
        self.userText.text=[NSString stringWithFormat:@"%@",username];
        self.passwdText.text=[NSString stringWithFormat:@"%@",passwd];
        [self.rememberBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateNormal];
    }else{
        [self.rememberBtn setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)login:(id)sender {
    if (self.userText.text==NULL||[self.userText.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入正确的用户名"];
        return;
    }
    if (self.passwdText.text==NULL||[self.passwdText.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入正确的密码"];
        return;
    }
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"登录中...";
    [HZLoginService LoginWithUserName:self.userText.text passwd:self.passwdText.text andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if (!error){
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            HZHomeViewController *home=[[HZHomeViewController alloc]init];
            home.dic=returnDic;
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            [def setObject:[returnDic objectForKey:@"token"] forKey:@"token"];
            [ def setObject:self.userText.text forKey:@"username"];
            [ def setObject:self.passwdText.text forKey:@"passwd"];
            [ def setObject:[[returnDic objectForKey:@"obj"]objectForKey:@"userid"] forKey:@"userid"];
            [ def setObject:[[returnDic objectForKey:@"obj"]objectForKey:@"userid"] forKey:@"phone"];
           [def setObject:[[[returnDic objectForKey:@"obj"]objectForKey:@"dbAConstructionunit"]objectForKey:@"name"]  forKey:@"department"];
                 [def setObject:[[[returnDic objectForKey:@"obj"]objectForKey:@"dbAConstructionunit"]objectForKey:@"id"]  forKey:@"companyid"];
                NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
                [def setObject:data forKey:@"info"];
                [def synchronize];
            [self.navigationController pushViewController:home animated:YES];
            }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancelAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else   if ([[returnDic objectForKey:@"code"]integerValue]==1000) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancelAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self.view makeToast:@"登录失败"];
            }

        }else{
            [self.view makeToast:@"登录超时"];
        }
    }];
}
- (IBAction)regist:(id)sender {
    HZRegisterViewController  *regist=[[HZRegisterViewController alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
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
