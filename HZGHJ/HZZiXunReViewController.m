//
//  HZZiXunReViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/7/26.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZZiXunReViewController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"


@interface HZZiXunReViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate>{
    UITextView *_detailText;
}

@end

@implementation HZZiXunReViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"再次咨询";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    _detailText=[[UITextView alloc]initWithFrame:CGRectMake(0, 20, Width, 150)];
    _detailText.delegate=self;
    [_detailText resignFirstResponder];
    _detailText.clearsOnInsertion=YES;
    _detailText.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_detailText];
    self.placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _detailText.frame.size.width-40, 30)];
    
    self.placehoderLabel.backgroundColor = [UIColor whiteColor];
    
    self.placehoderLabel.text = @"请输入咨询内容(不得超过200字)";
    self.placehoderLabel.textColor=[UIColor grayColor];
    
    self.placehoderLabel.font = [UIFont systemFontOfSize:15.0];
    
    [_detailText addSubview:self.placehoderLabel];
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_detailText.frame.size.width-90, _detailText.frame.size.height-30, 60, 20)];
    
    self.numLabel.backgroundColor = [UIColor whiteColor];
    self.numLabel.textColor=[UIColor grayColor];
    
    self.numLabel.text = @"0/200";
    
    self.numLabel.font = [UIFont systemFontOfSize:15.0];
    
    [_detailText addSubview:self.numLabel];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 200,Width-80, 40)];
    [button setTitle:@"确认提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    [button addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)commit{
      if (_detailText.text ==NULL||[_detailText.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入咨询内容" duration:2 position:CSToastPositionCenter];
        return;
    }
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"加载中，请稍候...";
    [HZLoginService ZiXunRefreshWithTaskId:self.taskid details:_detailText.text andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            [self.view makeToast:[returnDic objectForKey:@"desc"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self.view makeToast:@"请求失败，请重新尝试"];
        }

    }];
    
    
}
#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    self.placehoderLabel.hidden=YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    self.numLabel.text =[NSString stringWithFormat:@"%d/200",(int)[textView.text length]];
    if (textView.text==NULL||[textView.text isEqualToString:@""]) {
        self.placehoderLabel.hidden=NO;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text length]>=200)
    {
        textView.text = [textView.text substringToIndex:199];
    }
    else
    {
        self.numLabel.text =[NSString stringWithFormat:@"%d/200",(int)[textView.text length]];
        return YES;
    }
    
    return YES;
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
