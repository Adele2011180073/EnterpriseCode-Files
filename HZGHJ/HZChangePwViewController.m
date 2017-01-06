//
//  HZChangePwViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/12.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZChangePwViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"

@interface HZChangePwViewController (){
    UITextField *textfield;
}


@end

@implementation HZChangePwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"修改密码";
    
    NSArray *labelArray=@[@"旧密码",@"新密码",@"确认密码"];
    for (int i=0; i<3; i++) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 40+50*i, Width, 49)];
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.userInteractionEnabled=YES;
        [self.view addSubview:bgView];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 49)];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor blackColor];
        label.text=[labelArray objectAtIndex:i];
        [bgView addSubview:label];
        textfield=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, Width-130, 49)];
        textfield.tag=30+i;
        textfield.font=[UIFont systemFontOfSize:15];
        textfield.borderStyle=UITextBorderStyleNone;
        textfield.clearsOnBeginEditing=YES;
        textfield.placeholder=@"请输入6-12位数字或字母";
        [bgView addSubview:textfield];
        
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(20, 100+50*3, Width-40, 40);
    button.tag=10;
    button.layer.cornerRadius=5;
    button.clipsToBounds=YES;
    [button setBackgroundColor:blueCyan];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
    [self.view addSubview:button];

}
-(void)commit:(UIButton *)sender{
    UITextField *opw=[self.view viewWithTag:30];
    UITextField *npw=[self.view viewWithTag:31];
    UITextField *qpw=[self.view viewWithTag:32];
    NSString *oldpw=[[NSUserDefaults standardUserDefaults]objectForKey:@"passwd"];
    if ([textfield.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您的用户名或密码填写不合法"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (![oldpw isEqualToString:opw.text]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您输入的旧密码不正确"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (![npw.text isEqualToString:qpw.text]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您俩次输入的密码不一样"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text=@"数据上传中...";
        [HZLoginService PWWithNSw:opw.text NSW:npw.text andBlock:^(NSDictionary *returnDic, NSError *error) {
            [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
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
