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
#import "UIView+Toast.h"
#import "HZBanShiService.h"
#import "BSRegexValidate.h"
#import "HZLoginViewController.h"
#import "HZBanShiViewController.h"
#import "HZYuYueWebViewController.h"


@interface HZIYuYueViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate,UIDocumentMenuDelegate,UIDocumentMenuDelegate>{
    UIScrollView *bgScrollView;
    NSMutableArray *projectNameArray;
    NSMutableArray *reservationserviceArray;
    NSMutableArray *_ZhuBanKeShiArray;//主办科室数组
    NSDictionary *returnData;
    UILabel *projectName;
    UILabel *nodeName;
    UIScrollView *bgBigClassView;
    BOOL isBigClass;
    NSInteger projectNum;//当前项目所在顺序
      NSInteger nodeNum;
    UITextView *_detailText;//资讯内容描述
    NSString *savedPath;
    
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
    self.title=@"办理咨询预约";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
     returnData=[[NSDictionary alloc]init];
    projectNum=0;
    nodeNum=0;
    
    //    时间选择器视图
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(20, 200, Width-40, 260)];
    //    时间标签
    timeLabel=[[UILabel alloc]init];
    //    时间选择器
    picker=[[UIDatePicker alloc]init];

    
    projectNameArray=[[NSMutableArray alloc]init];
    
    reservationserviceArray=[[NSMutableArray alloc]init];
    
    [self getZhuBanKeShiArray];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [self getResourceData];
    });

}
//获取科室数组
-(void)getZhuBanKeShiArray{
    [HZBanShiService BanShiWithAndBlock:^(NSDictionary *returnDic, NSError *error) {
        if (returnDic) {
            NSArray *obj=[returnDic objectForKey:@"obj"];
            _ZhuBanKeShiArray=[NSMutableArray arrayWithArray:obj];
        }
    }];

}
-(void)getResourceData{
//    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService WoDeYuYueDataWithToken:token andBlock:^(NSDictionary *returnDic, NSError *error) {
//           [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSArray *list=[returnDic objectForKey:@"list"];
                if (![list isEqual:[NSNull null]]&&list.count>0) {
                    for (int i=0; i<list.count; i++) {
                        NSDictionary *listDic=[list objectAtIndex:i];
                        if ([[listDic objectForKey:@"companyid"]isEqualToString:@"zzabcdef123456"]) {
                           [projectNameArray addObject:listDic];
                        }else{
                        NSArray*nodelist=[listDic objectForKey:@"nodelist"];
                            if (nodelist.count>0) {
                                [projectNameArray addObject:listDic];
                            }
                        }
                    }
                }else{
                    [self.view makeToast:@"您的账户暂时无数据"];
                }
                NSArray *array=[returnDic objectForKey:@"reservationservice"];
                reservationserviceArray=[NSMutableArray arrayWithArray:array];
                [self addSubviews];

//                NSLog(@"预约数据    %@  ",returnDic);

            }else   if ([[returnDic objectForKey:@"code"]integerValue]==900) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号已被其他设备登陆，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    HZLoginViewController *login=[[HZLoginViewController alloc]init];
                    [self.navigationController pushViewController:login animated:YES];
                }];
                [alert addAction:okAlert];
                UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancelAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self.view makeToast:@"请求不成功，请重新尝试"];
            }

             }];

}
-(void)addSubviews{
    for (UIView *view in bgScrollView.subviews) {
        [view removeFromSuperview];
    }
    [bgScrollView removeFromSuperview];
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    bgScrollView.contentSize=CGSizeMake(Width, 360+80*projectNameArray.count+40*2+40*3);
    bgScrollView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    bgScrollView.userInteractionEnabled=YES;
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(10, 220, Width-20, 300)];
    [self.view addSubview:bgScrollView];
    UITapGestureRecognizer *resign=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    resign.delegate=self;
    resign.accessibilityValue=[NSString stringWithFormat:@"resign"];
    [bgScrollView addGestureRecognizer:resign];

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
    label.textAlignment=NSTextAlignmentLeft;
    label.text=@"选择项目名称";
    label.font=[UIFont systemFontOfSize:16];
    [bgScrollView addSubview:label];
    
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, Width, 50)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.userInteractionEnabled=YES;
    [bgScrollView addSubview:bgView];
    if (projectNameArray.count>0) {
        
    }else{
        [self.view makeToast:@"无可报送预约材料"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    projectName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-50, 50)];
    projectName.textAlignment=NSTextAlignmentLeft;
    projectName.numberOfLines=2;
    NSDictionary *projectNameDic=[projectNameArray objectAtIndex:projectNum];
    NSString *projectNameStr=[projectNameDic objectForKey:@"projectname"];
    projectName.text=projectNameStr;
    projectName.font=[UIFont systemFontOfSize:16];
    [bgView addSubview:projectName];
    UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(Width-30, 10, 20, 20)];
    imageTitle.textColor=blueCyan;
    imageTitle.text=@"\U0000e62e";
    imageTitle.font=[UIFont fontWithName:@"iconfont" size:16];
    [bgView addSubview:imageTitle];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate=self;
    tap.accessibilityValue=[NSString stringWithFormat:@"nameList"];
    [bgView addGestureRecognizer:tap];

    if ([[projectNameDic objectForKey:@"companyid"]isEqualToString:@"zzabcdef123456"]) {
        [self addZiXunView];
    }else{
    [self addYuYueView];
    }

}
//MARK:原来预约页面
-(void)addYuYueView{
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
            [nodeName removeFromSuperview];
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
    
    _detailText=[[UITextView alloc]initWithFrame:CGRectMake(0, 240, Width, 150)];
    _detailText.delegate=self;
    [_detailText resignFirstResponder];
    _detailText.clearsOnInsertion=YES;
    _detailText.font=[UIFont systemFontOfSize:15];
    [bgScrollView addSubview:_detailText];
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
    NSLog(@"reservationserviceArray   %@",reservationserviceArray);
    NSMutableArray *checkList=[[NSMutableArray alloc]init];
    for (int j=0; j<reservationserviceArray.count; j++) {
        NSDictionary *dic=[reservationserviceArray objectAtIndex:j];
        if ([[dic objectForKey:@"id"]intValue]==[[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]) {
            NSArray *childList=[dic objectForKey:@"childList"];
            [checkList addObjectsFromArray:childList];
        }
    }
    
    for (int i=0; i<2; i++) {
        UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(20, 400+40*i, Width-40, 100)];
        bgView1.backgroundColor=[UIColor colorWithRed:100/255.0 green:220/255.0 blue:247/255.0 alpha:1];
        //        bgView1.alpha=0.5;
        bgView1.layer.cornerRadius=10;
        bgView1.clipsToBounds=YES;
        bgView1.layer.borderWidth=1;
        bgView1.layer.borderColor=blueCyan.CGColor;
        bgView1.backgroundColor=[UIColor whiteColor];
        bgView1.userInteractionEnabled=YES;
        [bgScrollView addSubview:bgView1];
        if ([[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==1||[[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==2) {
            bgView1.frame=CGRectMake(20, 400+40*i, Width-40, 160);
        }
        if (i==0) {
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, Width-40-80, 20)];
            label1.textAlignment=NSTextAlignmentLeft;
            label1.text=@"方案提示信息：";
            label1.textColor=blueCyan;
            label1.font=[UIFont systemFontOfSize:16];
            [bgView1 addSubview:label1];
            
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(60, 40, Width-40-80, 60)];
            label2.textColor=blueCyan;
            label2.textAlignment=NSTextAlignmentLeft;
            label2.text=@"请在以下条件完备情况下进行预约，并在已完备的条件中选择打钩，否则预约将无法完成：";
            label2.numberOfLines=3;
            label2.font=[UIFont systemFontOfSize:16];
            [bgView1 addSubview:label2];
            UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(60,105, 100, 40)];
            [commit addTarget:self action:@selector(yangbiao) forControlEvents:UIControlEventTouchUpInside];
            commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
            commit.clipsToBounds=YES;
            commit.layer.cornerRadius=10;
            [commit setTitle:@"查看样表" forState:UIControlStateNormal];
            [bgView1 addSubview:commit];
        }else{
            bgView1.frame=CGRectMake(20, 510, Width-40, 70*checkList.count);
            if ([[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==1||[[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==2) {
                bgView1.frame=CGRectMake(20, 570, Width-40, 70*checkList.count);
            }
                if (checkList.count >0){
                for (int j=0; j<checkList.count; j++) {
                    UIButton *image=[[UIButton alloc]initWithFrame:CGRectMake(10, 25+60*j, 60, 60)];
                    [image addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
                    image.tag=20+j;
                    [image setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                    [image setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
                    [bgView1 addSubview:image];
                    
                    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(60, 20+60*j, Width-40-80, 70)];
                    label2.textAlignment=NSTextAlignmentLeft;
                    NSDictionary *dic=[checkList objectAtIndex:j];
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
            UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 540+80*checkList.count+40*i, Width, 40)];
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
    
    //
    if ([[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==1||[[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==2) {
    
    }else{
    NSArray *labelArray3=@[@"设计院联系人",@"设计院联系电话"];
    NSArray *placeholderArray=@[@"请输入设计院联系人",@"请输入设计院联系电话"];
    if (projectNameArray != nil && ![projectNameArray isKindOfClass:[NSNull class]] && projectNameArray.count != 0){
        for (int i=0; i<2; i++) {
            UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 500+80*checkList.count+40*2+40*i, Width, 40)];
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
    }
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 520+80*checkList.count+40*2+40*2+30,Width-80, 40)];
    bgScrollView.contentSize=CGSizeMake(Width, 520+80*checkList.count+40*2+40*3+120);

    if ([[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==1||[[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==2) {
         button.frame=CGRectMake(40, 480+80*checkList.count+40*2+40*2+30,Width-80, 40);
        bgScrollView.contentSize=CGSizeMake(Width, 480+80*checkList.count+40*2+40*3+120);
    }
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.clipsToBounds=YES;
    button.layer.cornerRadius=5;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=1000;
    [bgScrollView addSubview:button];
    

}
//MARK:咨询页面
-(void)addZiXunView{
    if (_ZhuBanKeShiArray.count>0) {
    UIView* bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 100, Width, 40)];
    bgView1.backgroundColor=[UIColor whiteColor];
    bgView1.userInteractionEnabled=YES;
    [bgScrollView addSubview:bgView1];
    //    bgView1.frame=CGRectMake(0, 100, Width, 40);
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 99, 20)];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.text=@"主办科室";
    label1.font=[UIFont systemFontOfSize:15];
    [bgView1 addSubview:label1];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 1, 20)];
    line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    [bgView1 addSubview:line];
    
        [nodeName removeFromSuperview];
        nodeName=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, Width -150, 20)];
        nodeName.textAlignment=NSTextAlignmentLeft;
        NSDictionary *dic=[_ZhuBanKeShiArray objectAtIndex:nodeNum];
        nodeName.text=[dic objectForKey:@"orgName"];
        nodeName.font=[UIFont systemFontOfSize:15];
        [bgView1 addSubview:nodeName];
        
        UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(Width-30, 5, 20, 20)];
        imageTitle.textColor=blueCyan;
        imageTitle.text=@"\U0000e62e";
        imageTitle.font=[UIFont fontWithName:@"iconfont" size:16];
        [bgView1 addSubview:imageTitle];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.delegate=self;
        tap.accessibilityValue=[NSString stringWithFormat:@"zhubankeshi"];
        [bgView1 addGestureRecognizer:tap];
    }
    UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(10,  150, Width-20, 100)];
    label2.textAlignment=NSTextAlignmentLeft;
    label2.numberOfLines=10;
    label2.textColor=[UIColor grayColor];
    label2.font=[UIFont systemFontOfSize:16];
    NSDictionary *projectNameDic=[projectNameArray objectAtIndex:projectNum];
    label2.text=[NSString stringWithFormat:@"      您选择的是咨询%@事项，如您需要了解具体办事流程，以及需要提交的材料信息，可通过办事指南查看，如需要与杭州规划局工作人员进行沟通，可继续填写咨询的问题。",[projectNameDic objectForKey:@"projectname"]];
    [bgScrollView  addSubview:label2];
    
    UIButton *mapBtn=[[UIButton alloc]initWithFrame:CGRectMake(20,250, 100, 30)];
    [mapBtn addTarget:self action:@selector(banshizhinan) forControlEvents:UIControlEventTouchUpInside];
    mapBtn.backgroundColor=blueCyan;
    mapBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [mapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mapBtn setTitle:@"转办事指南" forState:UIControlStateNormal];
    [bgScrollView addSubview:mapBtn];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 300, 140, 20)];
    label.textAlignment=NSTextAlignmentLeft;
    label.text=@"咨询内容描述：";
    label.font=[UIFont systemFontOfSize:16];
    [bgScrollView addSubview:label];
    
    _detailText=[[UITextView alloc]initWithFrame:CGRectMake(0, 330, Width, 150)];
    _detailText.delegate=self;
    [_detailText resignFirstResponder];
    _detailText.clearsOnInsertion=YES;
    _detailText.font=[UIFont systemFontOfSize:15];
    [bgScrollView addSubview:_detailText];
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
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(10, 480, Width-20, 60)];
    label3.textAlignment=NSTextAlignmentLeft;
    label3.numberOfLines=4;
    label3.textColor=[UIColor grayColor];
    label3.text=@"提示：您咨询的事项，会指派专人进行回复，提交咨询后，感谢您的耐心等待，谢谢！";
    label3.font=[UIFont systemFontOfSize:16];
    [bgScrollView addSubview:label3];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 580,Width-80, 40)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.tag=1001;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds=YES;
    button.layer.cornerRadius=8;
    [bgScrollView addSubview:button];
    
    bgScrollView.contentSize=CGSizeMake(Width, 620);
}
//MARK:提交数据
-(void)commit:(UIButton *)sender{
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
     NSString *phone=[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    if (sender.tag==1000) {
        UITextField *text1=[self.view viewWithTag:10];
        UITextField *text2=[self.view viewWithTag:11];
        UILabel *time=[self.view viewWithTag:30];
        
        if ([time.text isEqualToString:@""]||[time.text isEqualToString:@"请选择时间"]) {
//            [self.view makeToast:@"请选择时间" duration:2 position:CSToastPositionCenter];
//            return;
            time.text=@"";
        }
        if (text1&&[text1.text length]<3&&[text1.text length]>16) {
            [self.view makeToast:@"设计院联系人输入不合法,请重新输入" duration:2 position:CSToastPositionCenter];
            return;
        }
        if (text2&&![BSRegexValidate validateTelephone:text2.text]) {
            [self.view makeToast:@"联系电话输入不合法,请重新输入" duration:2 position:CSToastPositionCenter];
            return;
        }
        if ([BSRegexValidate stringContainsEmoji:text1.text]) {
            [self.view makeToast:@"请不要输入表情" duration:2 position:CSToastPositionCenter];
            return;
        }
        if (_detailText.text ==NULL||[_detailText.text isEqualToString:@""]) {
            [self.view makeToast:@"请输入咨询内容" duration:2 position:CSToastPositionCenter];
            return;
        }
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
        hud.label.text=@"数据提交中，请稍候...";
        [HZLoginService YuYueWithToken:token unitcontact:username unitcontactphone:phone timeofappointment:time.text designInstitutename:text1.text designInstitutephone:text2.text hostdepartment:str3 companymisstionid:str2 projectid:str nodeId:str1 detail:_detailText.text andBlock:^(NSDictionary *returnDic, NSError *error) {
            [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:cancelAlert];
                [self presentViewController:alert animated:YES completion:nil];
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
    }else{
        NSLog(@"_detailText.text  %@",_detailText.text);
        if (_detailText.text ==NULL||[_detailText.text isEqualToString:@""]) {
            [self.view makeToast:@"请输入咨询内容" duration:2 position:CSToastPositionCenter];
            return;
        }
        MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text=@"数据提交中，请稍候...";
        NSDictionary *dic=[_ZhuBanKeShiArray objectAtIndex:nodeNum];
        NSDictionary *messageDic=[projectNameArray objectAtIndex:projectNum];
        NSString *companymissionid=[messageDic objectForKey:@"id"];
        [HZLoginService ZiXunCommitToken:token orgid:[dic objectForKey:@"orgId"] details:_detailText.text companymissionid:companymissionid andBlock:^(NSDictionary *returnDic, NSError *error) {
             [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:[returnDic objectForKey:@"desc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:cancelAlert];
                [self presentViewController:alert animated:YES completion:nil];
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
}
-(void)tap:(UITapGestureRecognizer*)tap{
    if ([tap.accessibilityValue isEqualToString:@"resign"]) {
//        [bgBigClassView removeFromSuperview];
        [self.view endEditing:YES];
    }else if ([tap.accessibilityValue isEqualToString:@"nameList"]) {
        isBigClass=!isBigClass;
        if (isBigClass==YES) {
            bgBigClassView=[[UIScrollView alloc]init];
            bgBigClassView.layer.borderColor=blueCyan.CGColor;
            bgBigClassView.layer.borderWidth=1;
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
            for (UIView *view in bgBigClassView.subviews) {
                [view removeFromSuperview];
            }
            [bgBigClassView removeFromSuperview];
        }
        
    }else if ([tap.accessibilityValue isEqualToString:@"nodelist"]) {
        isBigClass=!isBigClass;
        if (isBigClass==YES) {
            bgBigClassView=[[UIScrollView alloc]init];
            NSDictionary *dic=[projectNameArray objectAtIndex:projectNum];
            NSArray *nodelist=[dic objectForKey:@"nodelist"];
                bgBigClassView.frame=CGRectMake(150, 140, Width-180, 50*nodelist.count);
            bgBigClassView.layer.borderColor=blueCyan.CGColor;
            bgBigClassView.layer.borderWidth=1;
            bgBigClassView.userInteractionEnabled=YES;
            bgBigClassView.backgroundColor=[UIColor whiteColor];
            [bgScrollView addSubview:bgBigClassView];
                     for (int i=0; i<nodelist.count; i++) {
                NSDictionary *dic=[nodelist objectAtIndex:i];
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(0,50*i, Width-180, 50);
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
            for (UIView *view in bgBigClassView.subviews) {
                [view removeFromSuperview];
            }
            [bgBigClassView removeFromSuperview];
        }
        
    }//MARK:咨询主办科室页面
    else if ([tap.accessibilityValue isEqualToString:@"zhubankeshi"]) {
        isBigClass=!isBigClass;
        if (isBigClass==YES) {
            bgBigClassView=[[UIScrollView alloc]init];
            bgBigClassView.frame=CGRectMake(150, 140, Width-180, 50*_ZhuBanKeShiArray.count);
            bgBigClassView.layer.borderColor=blueCyan.CGColor;
            bgBigClassView.layer.borderWidth=1;
            bgBigClassView.userInteractionEnabled=YES;
            bgBigClassView.backgroundColor=[UIColor whiteColor];
            [bgScrollView addSubview:bgBigClassView];
            for (int i=0; i<_ZhuBanKeShiArray.count; i++) {
                NSDictionary *dic=[_ZhuBanKeShiArray objectAtIndex:i];
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(0,50*i, Width-180, 50);
                button.tag=50+i;
                button.titleLabel.textAlignment=NSTextAlignmentCenter;
                button.titleLabel.font=[UIFont systemFontOfSize:16];
                [button setTitle:[dic objectForKey:@"orgName"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.adjustsImageWhenHighlighted=YES;
                [button addTarget:self action:@selector(listBtn:) forControlEvents:UIControlEventTouchUpInside];
                [bgBigClassView addSubview:button];
                
                UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,49*i, Width, 1)];
                lineLabel.backgroundColor=[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
                [bgBigClassView addSubview:lineLabel];
            }
        } else{
            for (UIView *view in bgBigClassView.subviews) {
                [view removeFromSuperview];
            }
            [bgBigClassView removeFromSuperview];
        }
        
    }
    else if ([tap.accessibilityValue isEqualToString:@"timePicker"]){
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
        nodeNum=0;
        [self addSubviews];
    }else if(button.tag>49&&button.tag<60){
        [bgBigClassView removeFromSuperview];
        NSDictionary *projectNameDic=[projectNameArray objectAtIndex:projectNum];
        if ([[projectNameDic objectForKey:@"companyid"]isEqualToString:@"zzabcdef123456"]) {
            nodeNum=button.tag-50;
            NSDictionary *dic=[_ZhuBanKeShiArray objectAtIndex:button.tag-50];
            nodeName.backgroundColor=[UIColor whiteColor];
            nodeName.text=[dic objectForKey:@"orgName"];
        }else{
            nodeNum=button.tag-50;
            NSDictionary *dic=[projectNameArray objectAtIndex:projectNum];
            NSArray *nodelist=[dic objectForKey:@"nodelist"];
            NSDictionary *nodelistdic=[nodelist objectAtIndex:button.tag-50];
            nodeName.backgroundColor=[UIColor whiteColor];
            nodeName.text=[nodelistdic objectForKey:@"value"];
        }
        [self addSubviews];
    }
   
}
-(void)check:(UIButton*)sender{
    sender.selected=!sender.selected;

}
-(void)timeSelect:(UIDatePicker*)datePicker{
    NSDateFormatter *formatter = [[ NSDateFormatter alloc ] init ];
    
    // 格式化日期格式123
    
    
    formatter. dateFormat = @"YYYY-MM-dd HH:mm:ss" ;
    
    timeLabel.text=[formatter stringFromDate:datePicker.date];
    
    // 显示时间
    UILabel *time=[self.view viewWithTag:30];
    time.text=timeLabel.text;
//    self . birthdayField . text = date;
}
//MARK:转办事指南
-(void)banshizhinan{
    HZBanShiViewController *banshizhinan=[[HZBanShiViewController alloc]init];
    [self.navigationController pushViewController:banshizhinan animated:YES];
}
//MARK:转查看样表
-(void)yangbiao{
    NSDictionary *messageDic=[projectNameArray objectAtIndex:projectNum];
    NSString *downloadybghyx;
    if ([[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==1) {
        downloadybghyx=@"http://220.191.210.76/ghyx.docx";
    }else  if ([[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==2) {
        downloadybghyx=@"http://220.191.210.76/jgghhs.docx";
    }
    HZYuYueWebViewController *web=[[HZYuYueWebViewController alloc]init];
    web.url=downloadybghyx;
    [self.navigationController pushViewController:web animated:YES];
//    NSURL *url=[NSURL URLWithString:downloadybghyx];
//    if([[UIApplication sharedApplication]canOpenURL:url])
//        
//    {
//        //缓存到本地沙盒的地址
//        
//        savedPath = [NSHomeDirectory() stringByAppendingString:@"/jgghhs.docx"];
//        if ([[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==1) {
//            savedPath=[[NSBundle mainBundle]pathForResource:@"ghyx" ofType:@"docx"];
//        }else  if ([[[[messageDic objectForKey:@"nodelist"]objectAtIndex:nodeNum]objectForKey:@"name"]intValue]==2) {
//            savedPath=[[NSBundle mainBundle]pathForResource:@"jgghhs" ofType:@"docx"];
//        }
//        NSLog(@"url==%@",savedPath);
//        
//    }
//    _docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savedPath]];//为该对象初始化一个加载路径
//    _docController.UTI = @"com.microsoft.word201.doc.docx";
//    _docController.delegate =self;//设置代理
//    
//    //直接显示预览
//    //    [_docController presentPreviewAnimated:YES];
//    
//    CGRect navRect =self.navigationController.navigationBar.frame;
//    navRect.size =CGSizeMake(1500.0f,40.0f);
//    
//    //显示包含预览的菜单项
//    [_docController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
//    
//    //显示不包含预览菜单项
//    [_docController presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
//       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadybghyx]];
}
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bgScrollView.contentOffset=CGPointMake(0, 700);
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    bgScrollView.contentOffset=CGPointMake(0, 0);
    [self.view endEditing:YES];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //   限制苹果系统输入法  禁止输入表情
       return YES;
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
