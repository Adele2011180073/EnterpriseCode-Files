//
//  HZYuYueReViewController.m
//  HZGHJ
//
//  Created by zhang on 17/1/7.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZYuYueReViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"
#import "HZYuYueViewController.h"
#import "UIView+Toast.h"
@interface HZYuYueReViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    UIScrollView *bgScrollView;
//    NSMutableArray *projectNameArray;
    NSMutableArray *reservationserviceArray;
//    NSDictionary *returnData;
    UILabel *projectName;
    UIScrollView *bgBigClassView;
    BOOL isBigClass;
    NSInteger projectNum;
    NSInteger nodeNum;
    
    UIView *pickerView;
    UILabel *timeLabel;
    UIDatePicker *picker;
}


@end

@implementation HZYuYueReViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"重新预约";
//    returnData=[[NSDictionary alloc]init];
    projectNum=0;
    nodeNum=0;
    
    //    时间选择器视图
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(20, 200, Width-40, 260)];
    //    时间标签
    timeLabel=[[UILabel alloc]init];
    //    时间选择器
    picker=[[UIDatePicker alloc]init];
    
    
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
//    bgScrollView.contentSize=CGSizeMake(Width, 360+80*projectNameArray.count+40*2+40*3);
    bgScrollView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    bgScrollView.userInteractionEnabled=YES;
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(10, 220, Width-20, 300)];
    [self.view addSubview:bgScrollView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate=self;
    tap.accessibilityValue=[NSString stringWithFormat:@"resign"];
    [bgScrollView addGestureRecognizer:tap];
//    projectNameArray=[[NSMutableArray alloc]init];
    
    reservationserviceArray=[[NSMutableArray alloc]init];
    [self getResourceData];

}
-(void)getResourceData{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *nodeid=[self.returnData objectForKey:@"nodeid"];
    [HZLoginService YuYueRefreshDataWithNodeId:nodeid andBlock:^(NSDictionary *returnDic, NSError *error) {
          [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
//            projectNameArray=[returnDic objectForKey:@"list"];
//            NSArray *array=[returnDic objectForKey:@"reservationservice"];
//            NSDictionary *dic=[array objectAtIndex:0];
            reservationserviceArray=[NSMutableArray arrayWithArray:[returnDic objectForKey:@"list"]];
            
            [self addSubviews];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==1000) {
            [self.view makeToast:[returnDic objectForKey:@"desc"]];
        }else{
             [self.view makeToast:@"请求不成功，请重新尝试" duration:2 position:CSToastPositionCenter];
        }
        
    }];
    
}
-(void)addSubviews{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
    label.textAlignment=NSTextAlignmentLeft;
    label.text=@"选择项目名称";
    label.font=[UIFont systemFontOfSize:16];
    [bgScrollView addSubview:label];
    
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, Width, 40)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.userInteractionEnabled=YES;
    [bgScrollView addSubview:bgView];
    projectName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-50, 40)];
    projectName.textAlignment=NSTextAlignmentLeft;
    NSString *projectNameStr=[self.returnData objectForKey:@"projectName"];
    projectName.text=projectNameStr;
    projectName.font=[UIFont systemFontOfSize:16];
    [bgView addSubview:projectName];
    UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(Width-30, 5, 20, 20)];
    imageTitle.textColor=blueCyan;
    imageTitle.text=@"\U0000e62e";
    imageTitle.font=[UIFont fontWithName:@"iconfont" size:16];
    [bgView addSubview:imageTitle];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate=self;
    tap.accessibilityValue=[NSString stringWithFormat:@"nameList"];
    [bgView addGestureRecognizer:tap];
    
    NSArray *labelArray1=@[@"申请内容",@"预约时间",@"主办科室"];
    NSString *str1;
    str1=[self.returnData objectForKey:@"nodeName"];
    NSString *str2=@"请选择时间";
    NSString *str3=[self.returnData objectForKey:@"hostdepartment"];
    NSArray *textArray=@[str1,str2,str3];
    for (int i=0; i<3; i++) {
        UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 100+40*i, Width, 40)];
        bgView1.backgroundColor=[UIColor whiteColor];
        bgView1.userInteractionEnabled=YES;
        [bgScrollView addSubview:bgView1];
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 99, 20)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.text=[labelArray1 objectAtIndex:i];
        label1.font=[UIFont systemFontOfSize:15];
        [bgView1 addSubview:label1];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 1, 20)];
        line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        [bgView1 addSubview:line];
        
        UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, Width -120, 20)];
        text.textAlignment=NSTextAlignmentLeft;
        text.text=[textArray objectAtIndex:i];
        text.font=[UIFont systemFontOfSize:15];
        [bgView1 addSubview:text];
        
        if (i==1) {
            text.textColor=[UIColor grayColor];
            text.tag=30;
            text.userInteractionEnabled=YES;
            text.text=self.time;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            tap.delegate=self;
            tap.accessibilityValue=[NSString stringWithFormat:@"timePicker"];
            [text addGestureRecognizer:tap];
        }
    }
    
    for (int i=0; i<2; i++) {
        UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(20, 240+40*i, Width-40, 100)];
        bgView1.backgroundColor=[UIColor colorWithRed:100/255.0 green:220/255.0 blue:247/255.0 alpha:1];
        //        bgView1.alpha=0.5;
        bgView1.layer.cornerRadius=10;
        bgView1.clipsToBounds=YES;
        bgView1.layer.borderWidth=1;
        bgView1.layer.borderColor=blueCyan.CGColor;
        bgView1.backgroundColor=[UIColor whiteColor];
        bgView1.userInteractionEnabled=YES;
        [bgScrollView addSubview:bgView1];
        
        if (i==0) {
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, Width-40-80, 20)];
            label1.textAlignment=NSTextAlignmentLeft;
            label1.text=@"方案提示信息：";
            label1.textColor=blueCyan;
            label1.font=[UIFont systemFontOfSize:15];
            [bgView1 addSubview:label1];
            
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(60, 40, Width-40-80, 60)];
            label2.textColor=blueCyan;
            label2.textAlignment=NSTextAlignmentLeft;
            label2.text=@"请在以下条件完备情况下进行预约，并在已完备的条件中选择打钩，否则预约将无法完成：";
            label2.numberOfLines=3;
            label2.font=[UIFont systemFontOfSize:15];
            [bgView1 addSubview:label2];
        }else{
            bgView1.frame=CGRectMake(20, 350, Width-40, 70*reservationserviceArray.count);
            if (reservationserviceArray != nil && ![reservationserviceArray isKindOfClass:[NSNull class]] && reservationserviceArray.count != 0){
                for (int j=0; j<reservationserviceArray.count; j++) {
                    UIButton *image=[[UIButton alloc]initWithFrame:CGRectMake(10, 25+60*j, 60, 60)];
                    [image setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateNormal];
                    [bgView1 addSubview:image];
                    
                    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(60, 20+60*j, Width-40-80, 70)];
                    label2.textAlignment=NSTextAlignmentLeft;
                    NSDictionary *dic=[reservationserviceArray objectAtIndex:j];
                    label2.text=[dic objectForKey:@"name"];
                    label2.numberOfLines=3;
                    label2.font=[UIFont systemFontOfSize:15];
                    [bgView1 addSubview:label2];
                }
            }
        }
    }
    
    NSArray *labelArray2=@[@"经办人",@"联系电话"];
        NSString *adminName=[self.returnData objectForKey:@"adminName"];
        NSString *adminPhone=[self.returnData objectForKey:@"adminPhone"];
        NSArray *textArray1=@[adminName,adminPhone];
        for (int i=0; i<2; i++) {
            
            UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 360+80*reservationserviceArray.count+40*i, Width, 40)];
            bgView1.backgroundColor=[UIColor whiteColor];
            bgView1.userInteractionEnabled=YES;
            [bgScrollView addSubview:bgView1];
            //    bgView1.frame=CGRectMake(0, 100, Width, 40);
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 99, 20)];
            label1.textAlignment=NSTextAlignmentCenter;
            label1.text=[labelArray2 objectAtIndex:i];
            label1.font=[UIFont systemFontOfSize:15];
            [bgView1 addSubview:label1];
            
            UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 1, 20)];
            line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
            [bgView1 addSubview:line];
            
            UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, Width -120, 20)];
            text.textAlignment=NSTextAlignmentLeft;
            text.text=[textArray1 objectAtIndex:i];
            text.font=[UIFont systemFontOfSize:15];
            [bgView1 addSubview:text];
        }
    
    NSArray *labelArray3=@[@"设计院联系人",@"设计院联系电话"];
    NSArray *placeholderArray=@[@"请输入设计院联系人",@"请输入设计院联系电话"];
        for (int i=0; i<2; i++) {
            UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 380+80*reservationserviceArray.count+40*2+40*i, Width, 40)];
            bgView1.backgroundColor=[UIColor whiteColor];
            bgView1.userInteractionEnabled=YES;
            [bgScrollView addSubview:bgView1];
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 119, 20)];
            label1.textAlignment=NSTextAlignmentCenter;
            label1.text=[labelArray3 objectAtIndex:i];
            label1.font=[UIFont systemFontOfSize:15];
            [bgView1 addSubview:label1];
            
            UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(120, 10, 1, 20)];
            line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
            [bgView1 addSubview:line];
            
            UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(130, 10, Width -150, 20)];
            text.tag=10+i;
            text.text=self.name;
            if (i==1) {
                text.keyboardType = UIKeyboardTypeNumberPad;
                text.text=self.phone;
            }
            text.delegate=self;
            text.placeholder=[placeholderArray objectAtIndex:i];
            text.font=[UIFont systemFontOfSize:15];
            [bgView1 addSubview:text];
        }
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 380+80*reservationserviceArray.count+40*2+40*2+30,Width-80, 40)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    [button addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    
    [bgScrollView addSubview:button];
    
    bgScrollView.contentSize=CGSizeMake(Width, 360+80*reservationserviceArray.count+40*2+40*3+120);
}
-(void)commit{
    NSString *str3=[self.returnData objectForKey:@"timeofappointment"];
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [HZLoginService YuYueRefreshWithTaskId:self.taskid Status:@"0" timeofappointment:str3 andBlock:^(NSDictionary *returnDic, NSError *error) {
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            for (UIViewController* controller in self.navigationController.viewControllers)
            {
                //Check your view controller is exist / not in navigation controller stack.
                if ([controller isKindOfClass:[HZYuYueViewController class]])
                {
                    // If it is exist then popToViewController
                    [self.navigationController popToViewController:controller animated:YES];
                    return;
                }
            }
//            HZYuYueViewController *yuyue=[[HZYuYueViewController alloc]init];
//            [self.navigationController popToViewController:yuyue animated:YES];
        }else{
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
-(void)tap:(UITapGestureRecognizer*)tap{
    if ([tap.accessibilityValue isEqualToString:@"resign"]) {
        //        [bgBigClassView removeFromSuperview];
        [self.view endEditing:YES];
    }else
        if ([tap.accessibilityValue isEqualToString:@"nameList"]) {
            
        }else if ([tap.accessibilityValue isEqualToString:@"timePicker"]){
            picker.frame=CGRectMake(0, 40, Width-40, 180);
            picker.datePickerMode=UIDatePickerModeDate;
            [picker addTarget:self action:@selector(timeSelect:) forControlEvents:UIControlEventValueChanged];
            pickerView.backgroundColor=[UIColor whiteColor];
            pickerView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            pickerView.layer.borderWidth=1;
            pickerView.layer.cornerRadius=5;
            NSDate *now = [[NSDate alloc] init];
            [picker setDate:now animated:YES];
            [pickerView addSubview:picker];
            [self.view addSubview:pickerView];
            timeLabel.frame=CGRectMake(0, 5, Width-40, 30);
            timeLabel.textColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
            NSDateFormatter *dateFomatter=[[NSDateFormatter alloc]init];
            [dateFomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            timeLabel.text=[dateFomatter stringFromDate:[NSDate date]];
            timeLabel.textAlignment=NSTextAlignmentCenter;
            timeLabel.font=[UIFont systemFontOfSize:17];
            [pickerView addSubview:timeLabel];
            
            UIButton *achieve=[UIButton buttonWithType:UIButtonTypeCustom];
            achieve.frame=CGRectMake(100,230  , Width-40-200, 35);
            [achieve setTitle:@"完成" forState:UIControlStateNormal];
            achieve.tag=100;
            [achieve setBackgroundColor:[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1]];
            achieve.layer.cornerRadius=5;
            achieve.clipsToBounds=YES;
            [achieve addTarget:self action:@selector(listBtn:) forControlEvents:UIControlEventTouchUpInside];
            [pickerView addSubview:achieve];
            
            //            NSArray *btnLabelArray=@[@"取消",@"确定"];
            //            for (int i=0; i<2; i++) {
            //                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            //                button.frame=CGRectMake((Width-20)/2*i,260, (Width-20)/2, 40);
            //                button.tag=100+i;
            //                button.layer.cornerRadius=8;
            //                button.clipsToBounds=YES;
            //                button.layer.borderWidth=1;
            //                button.layer.borderColor=[UIColor grayColor].CGColor;
            //                button.titleLabel.textAlignment=NSTextAlignmentCenter;
            //                button.titleLabel.font=[UIFont systemFontOfSize:17];
            //                [button setTitle:[btnLabelArray objectAtIndex:i] forState:UIControlStateNormal];
            //                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //                button.adjustsImageWhenHighlighted=YES;
            //                [button addTarget:self action:@selector(listBtn:) forControlEvents:UIControlEventTouchUpInside];
            //                [pickerView addSubview:button];
            //            }
            
        }
    
}
-(void)listBtn:(UIButton *)button{
    if (button.tag>99) {
        for (UIView *v in pickerView.subviews) {
            [v removeFromSuperview];
        }
        [pickerView removeFromSuperview];
        // 显示时间
        UILabel *time=[self.view viewWithTag:30];
        time.text=timeLabel.text;
    }else{
          }
    
}
-(void)check:(UIButton*)sender{
    sender.selected=!sender.selected;
    
}
-(void)timeSelect:(UIDatePicker*)datePicker{
    NSDateFormatter *formatter = [[ NSDateFormatter alloc ] init ];
    
    // 格式化日期格式
    
    formatter. dateFormat = @"YYYY-MM-dd HH:mm:ss" ;
    
    timeLabel.text=[formatter stringFromDate:datePicker.date];
    
    // 显示时间
    UILabel *time=[self.view viewWithTag:30];
    time.text=timeLabel.text;
    //    self . birthdayField . text = date;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bgScrollView.contentOffset=CGPointMake(0, 900);
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    bgScrollView.contentOffset=CGPointMake(0, 0);
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
