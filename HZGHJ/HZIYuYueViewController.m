//
//  HZIYuYueViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/12.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZIYuYueViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"
@interface HZIYuYueViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    UIScrollView *bgScrollView;
    NSMutableArray *projectNameArray;
    NSMutableArray *reservationserviceArray;
    NSDictionary *returnData;
    UILabel *projectName;
    UILabel *nodeName;
    UIScrollView *bgBigClassView;
    BOOL isBigClass;
    NSInteger projectNum;
      NSInteger nodeNum;
    
    UIView *pickerView;
    UILabel *timeLabel;
    UIDatePicker *picker;
}

@end

@implementation HZIYuYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"材料报送预约";
     returnData=[[NSDictionary alloc]init];
    projectNum=0;
    nodeNum=0;
    
    //    时间选择器视图
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(20, 200, Width-40, 260)];
    //    时间标签
    timeLabel=[[UILabel alloc]init];
    //    时间选择器
    picker=[[UIDatePicker alloc]init];

    
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    bgScrollView.contentSize=CGSizeMake(Width, 360+80*projectNameArray.count+40*2+40*3);
    bgScrollView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    bgScrollView.userInteractionEnabled=YES;
     pickerView=[[UIView alloc]initWithFrame:CGRectMake(10, 220, Width-20, 300)];
    [self.view addSubview:bgScrollView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate=self;
    tap.accessibilityValue=[NSString stringWithFormat:@"resign"];
    [bgScrollView addGestureRecognizer:tap];
    projectNameArray=[[NSMutableArray alloc]init];
    
    reservationserviceArray=[[NSMutableArray alloc]init];
    [self getResourceData];
//    [self addSubviews];
}
-(void)getResourceData{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService WoDeYuYueDataWithToken:token andBlock:^(NSDictionary *returnDic, NSError *error) {
           [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSArray *list=[returnDic objectForKey:@"list"];
                if (![list isEqual:[NSNull null]]&&list.count>0) {
                    for (int i=0; i<list.count; i++) {
                        NSDictionary *listDic=[list objectAtIndex:i];
                        NSArray*nodelist=[listDic objectForKey:@"nodelist"];
                        if (![nodelist isEqual:[NSNull null]]&&nodelist!=NULL&&nodelist.count>0) {
                            [projectNameArray addObject:listDic];
                        }
                    }
                }
                NSArray *array=[returnDic objectForKey:@"reservationservice"];
                NSDictionary *dic=[array objectAtIndex:0];
                reservationserviceArray=[NSMutableArray arrayWithArray:[dic objectForKey:@"childList"]];
                NSLog(@"预约数据    %@  ",str);

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
    projectName.numberOfLines=2;
    NSDictionary *projectNameDic=[projectNameArray objectAtIndex:projectNum];
    NSString *projectNameStr=[projectNameDic objectForKey:@"projectname"];
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
    NSDictionary *messageDic=[projectNameArray objectAtIndex:projectNum];
    NSString *str1;
    NSArray*nodelistArray=[messageDic objectForKey:@"nodelist"];
    if (nodelistArray!=NULL&&![nodelistArray isEqual:[NSNull null]]&&nodelistArray!=nil&&nodelistArray.count>0) {
        str1=[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"value"];
    }else{
       str1=@"方案咨询";
    }
    NSString *str2=@"请选择时间";
    NSString *str3=[messageDic objectForKey:@"hostdepartment"];
    NSArray *textArray=@[str1,str2,str3];
     for (int i=0; i<3; i++) {
    UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 100+40*i, Width, 40)];
    bgView1.backgroundColor=[UIColor whiteColor];
    bgView1.userInteractionEnabled=YES;
    [bgScrollView addSubview:bgView1];
//    bgView1.frame=CGRectMake(0, 100, Width, 40);
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
             UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
             tap.delegate=self;
             tap.accessibilityValue=[NSString stringWithFormat:@"timePicker"];
             [text addGestureRecognizer:tap];
         }else if (i==0){
             nodeName=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, Width -150, 20)];
             nodeName.textAlignment=NSTextAlignmentLeft;
             nodeName.text=[textArray objectAtIndex:i];
             nodeName.font=[UIFont systemFontOfSize:15];
             [bgView1 addSubview:nodeName];
             
             UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(Width-30, 5, 20, 20)];
             imageTitle.textColor=blueCyan;
             imageTitle.text=@"\U0000e62e";
             imageTitle.font=[UIFont fontWithName:@"iconfont" size:16];
             [bgView1 addSubview:imageTitle];
             UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
             tap.delegate=self;
             tap.accessibilityValue=[NSString stringWithFormat:@"nodelist"];
             [bgView1 addGestureRecognizer:tap];
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
                [image addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
                image.tag=20+j;
                [image setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                 [image setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
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
     if (projectNameArray != nil && ![projectNameArray isKindOfClass:[NSNull class]] && projectNameArray.count != 0){
         NSDictionary *dic=[projectNameArray objectAtIndex:projectNum];
         NSString *adminName=[dic objectForKey:@"adminName"];
         NSString *adminPhone=[dic objectForKey:@"adminPhone"];
         NSArray *textArray=@[adminName,adminPhone];
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
        text.text=[textArray objectAtIndex:i];
        text.font=[UIFont systemFontOfSize:15];
        [bgView1 addSubview:text];
    }
     }
    NSArray *labelArray3=@[@"设计院联系人",@"设计院联系电话"];
    NSArray *placeholderArray=@[@"请输入设计院联系人",@"请输入设计院联系电话"];
      if (projectNameArray != nil && ![projectNameArray isKindOfClass:[NSNull class]] && projectNameArray.count != 0){
    for (int i=0; i<2; i++) {
        UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 380+80*reservationserviceArray.count+40*2+40*i, Width, 40)];
        bgView1.backgroundColor=[UIColor whiteColor];
        bgView1.userInteractionEnabled=YES;
        [bgScrollView addSubview:bgView1];
        //    bgView1.frame=CGRectMake(0, 100, Width, 40);
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
        if (i==1) {
            text.keyboardType = UIKeyboardTypeNumberPad;
        }
        text.delegate=self;
        text.placeholder=[placeholderArray objectAtIndex:i];
        text.font=[UIFont systemFontOfSize:15];
        [bgView1 addSubview:text];
    }
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
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
     NSString *phone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    UITextField *text1=[self.view viewWithTag:10];
     UITextField *text2=[self.view viewWithTag:11];
    UILabel *time=[self.view viewWithTag:30];
    NSDictionary *messageDic=[projectNameArray objectAtIndex:projectNum];
    NSString *str3=[messageDic objectForKey:@"hostdepartment"];
    NSString *str2=[messageDic objectForKey:@"id"];
    NSString *str1;
    NSArray *nodelist=[messageDic objectForKey:@"nodelist"];
    if (![nodelist isEqual:[NSNull null]]&&nodelist.count>0) {
        str1=[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"];
    }else{
        str1=@"100";
    }
    if (reservationserviceArray != nil && ![reservationserviceArray isKindOfClass:[NSNull class]] && reservationserviceArray.count != 0){
        for (int j=0; j<reservationserviceArray.count; j++) {
            UIButton *button=[self.view viewWithTag:20+j];
            if (button.selected==NO) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"请把方案提示信息全部选中" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancelAlert];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
        }
    }
   NSString *str=[messageDic objectForKey:@"projectid"];
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [HZLoginService YuYueWithToken:token unitcontact:username unitcontactphone:phone timeofappointment:time.text designInstitutename:text1.text designInstitutephone:text2.text hostdepartment:str3 companymisstionid:str2 projectid:str nodeId:str1 andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==900||[[returnDic objectForKey:@"code"]integerValue]==1000) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancelAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
        }

    }];
}
-(void)tap:(UITapGestureRecognizer*)tap{
    if ([tap.accessibilityValue isEqualToString:@"resign"]) {
//        [bgBigClassView removeFromSuperview];
        [self.view endEditing:YES];
    }else if ([tap.accessibilityValue isEqualToString:@"nameList"]) {
        isBigClass=!isBigClass;
        if (isBigClass==YES) {
            bgBigClassView=[[UIScrollView alloc]init];
            if (50*projectNameArray.count>Height-160) {
                bgBigClassView.frame=CGRectMake(0, 90, Width, Height-160);
            }else{
                bgBigClassView.frame=CGRectMake(0, 90, Width, 50*projectNameArray.count);
            }
            bgBigClassView.userInteractionEnabled=YES;
            bgBigClassView.backgroundColor=[UIColor whiteColor];
            [bgScrollView addSubview:bgBigClassView];
            
            for (int i=0; i<projectNameArray.count; i++) {
                NSDictionary *dic=[projectNameArray objectAtIndex:i];
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(0,50*i, Width, 50);
                button.tag=60+i;
                button.titleLabel.textAlignment=NSTextAlignmentCenter;
                button.titleLabel.font=[UIFont systemFontOfSize:16];
                [button setTitle:[dic objectForKey:@"projectname"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.adjustsImageWhenHighlighted=YES;
                [button addTarget:self action:@selector(listBtn:) forControlEvents:UIControlEventTouchUpInside];
                [bgBigClassView addSubview:button];
                
                UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,49*i, Width, 1)];
                lineLabel.backgroundColor=[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
                [bgBigClassView addSubview:lineLabel];
            }
        } else{
            [bgBigClassView removeFromSuperview];
        }
        
    }else if ([tap.accessibilityValue isEqualToString:@"nodelist"]) {
        isBigClass=!isBigClass;
        if (isBigClass==YES) {
            bgBigClassView=[[UIScrollView alloc]init];
            NSDictionary *dic=[projectNameArray objectAtIndex:projectNum];
            NSArray *nodelist=[dic objectForKey:@"nodelist"];
                bgBigClassView.frame=CGRectMake(150, 140, Width-180, 50*nodelist.count);
            bgBigClassView.userInteractionEnabled=YES;
            bgBigClassView.backgroundColor=[UIColor whiteColor];
            [bgScrollView addSubview:bgBigClassView];
                     for (int i=0; i<nodelist.count; i++) {
                NSDictionary *dic=[nodelist objectAtIndex:i];
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(0,50*i, Width, 50);
                button.tag=50+i;
                button.titleLabel.textAlignment=NSTextAlignmentCenter;
                button.titleLabel.font=[UIFont systemFontOfSize:16];
                [button setTitle:[dic objectForKey:@"value"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.adjustsImageWhenHighlighted=YES;
                [button addTarget:self action:@selector(listBtn:) forControlEvents:UIControlEventTouchUpInside];
                [bgBigClassView addSubview:button];
                
                UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,49*i, Width, 1)];
                lineLabel.backgroundColor=[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
                [bgBigClassView addSubview:lineLabel];
            }
        } else{
            [bgBigClassView removeFromSuperview];
        }
        
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
    }else if(button.tag>59&&button.tag<100){
        [bgBigClassView removeFromSuperview];
        projectNum=button.tag-60;
        NSDictionary *dic=[projectNameArray objectAtIndex:button.tag-60];
        projectName.text=[dic objectForKey:@"projectname"];
    }else if(button.tag>49&&button.tag<60){
        [bgBigClassView removeFromSuperview];
        nodeNum=button.tag-50;
        NSDictionary *dic=[projectNameArray objectAtIndex:projectNum];
        NSArray *nodelist=[dic objectForKey:@"nodelist"];
        NSDictionary *nodelistdic=[nodelist objectAtIndex:button.tag-50];
        nodeName.text=[nodelistdic objectForKey:@"value"];
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
