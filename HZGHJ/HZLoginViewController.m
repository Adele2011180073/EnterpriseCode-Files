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
    self.view.backgroundColor=[UIColor colorWithRed:223/255.0 green:241/255.0 blue:255/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
     self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    UIImageView *topImageView=[[UIImageView alloc]init];
    topImageView.frame=CGRectMake(0, 0, Width, Height/4.2);
    topImageView.image=[UIImage imageNamed:@"logo2.png"];
    [self.view addSubview:topImageView];
    
    NSArray *labelArray=@[@"\U0000e69e",@"\U0000e681"];
    NSArray *placeArray=@[@"请输入您的用户名",@"请输入您的密码"];
    UIView *inputView=[[UIView alloc]initWithFrame:CGRectMake(0,Height/4.2+30, Width, 120)];
    inputView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:inputView];
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 60*i+10, 30, 40)];
        label.font=[UIFont fontWithName:@"iconfont" size:32];
        label.textColor=mainColor;
        label.text=[labelArray objectAtIndex:i];
        [inputView addSubview:label];
        
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 59+60*i, Width-20, 1)];
        //        [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0]
        lineLabel.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
        [inputView addSubview:lineLabel];
        
        UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(70, 60*i, Width-70, 60)];
        textfield.tag=10+i;
        textfield.font=[UIFont systemFontOfSize:15];
        textfield.borderStyle=UITextBorderStyleNone;
        textfield.placeholder=[placeArray objectAtIndex:i];
        [inputView addSubview:textfield];
        if (i==1) {
            textfield.secureTextEntry=YES;
        }
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        if ([def boolForKey:@"remember"]==YES) {
            isRemember=YES;
             textfield.userInteractionEnabled=NO;
            textfield.textColor=[UIColor grayColor];
            NSString *username=[def objectForKey:@"username"];
            NSString *passwd=[def objectForKey:@"passwd"];
            if (i==0) {
                textfield.text=[NSString stringWithFormat:@"%@",username];
            }else{
                textfield.text=[NSString stringWithFormat:@"%@",passwd];
            }
        }
        
    }
    UIButton *boxbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    boxbutton.frame=CGRectMake(30, Height/4.2+182, 25, 25);
    boxbutton.selected=isRemember;    
    [boxbutton setTintColor:[UIColor whiteColor]];
    [boxbutton addTarget:self action:@selector(remember:) forControlEvents:UIControlEventTouchUpInside];
    [boxbutton setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    [boxbutton setBackgroundImage:[UIImage imageNamed:@"checkbox_fill.png"] forState:UIControlStateSelected];
     [self.view addSubview:boxbutton];
    
    UILabel *  messgeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, Height/4.2+180, 80, 30)];
    messgeLabel.font=[UIFont systemFontOfSize:15];
    messgeLabel.textColor=[UIColor darkGrayColor];
    messgeLabel.text=@"记住密码";
    [self.view addSubview:messgeLabel];
    
    
    UIButton *registerbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    registerbutton.frame=CGRectMake(Width-100, Height/4.2+180, 60, 30);
    [registerbutton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    registerbutton.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [registerbutton setTitle:@"注册" forState:UIControlStateNormal];
      [registerbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:registerbutton];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(20, Height/4.2+240, Width-40, 45);
    button.layer.cornerRadius=8;
    button.clipsToBounds=YES;
    button.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [button setBackgroundColor:mainColor];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:button];

}

- (IBAction)remember:(UIButton*)sender {
    sender.selected=!sender.selected;
    isRemember = sender.selected;
    UITextField *usertextfield=(UITextField*)[self.view viewWithTag:10];
    UITextField *passwdtextfield=(UITextField*)[self.view viewWithTag:11];
    if (isRemember==YES) {
        usertextfield.userInteractionEnabled=NO;
        passwdtextfield.userInteractionEnabled=NO;
        usertextfield.textColor=[UIColor grayColor];
        passwdtextfield.textColor=[UIColor grayColor];
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remember"];
    }else{
        usertextfield.userInteractionEnabled=YES;
        passwdtextfield.userInteractionEnabled=YES;
        usertextfield.textColor=[UIColor blackColor];
        passwdtextfield.textColor=[UIColor blackColor];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"remember"];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)login:(id)sender {
    UITextField *usertextfield=(UITextField*)[self.view viewWithTag:10];
    UITextField *passwdtextfield=(UITextField*)[self.view viewWithTag:11];
    if (usertextfield.text==NULL||[usertextfield.text isEqualToString:@""]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"用户名输入框不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (passwdtextfield.text==NULL||[passwdtextfield.text isEqualToString:@""]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"密码输入框不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"登录中...";
    [HZLoginService LoginWithUserName:usertextfield.text passwd:passwdtextfield.text andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if (!error){
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            HZHomeViewController *home=[[HZHomeViewController alloc]init];
            home.dic=returnDic;
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            [def setObject:[returnDic objectForKey:@"token"] forKey:@"token"];
            [ def setObject:usertextfield.text forKey:@"username"];
            [ def setObject:passwdtextfield.text forKey:@"passwd"];
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
