//
//  HAYuYueDetailViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/12.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HAYuYueDetailViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"
                                   
@interface HAYuYueDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    NSDictionary *returnData;
    NSArray *labelArray;
}


@end

@implementation HAYuYueDetailViewController
@synthesize dataList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"预约详情";
    
    dataList=[[NSMutableArray alloc]init];
    returnData=[[NSDictionary alloc]init];
    
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44-20)];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=40;
    tableview.delegate=self;
    tableview.separatorColor=littleGray;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    
    labelArray=[[NSArray alloc]initWithObjects:@"预约项目",@"预约事项",@"预约前提条件",@"预约人",@"联系电话",@"单位联系人",@"联系电话",@"设计院联系人",@"联系电话",@"预约时间",@"预约时间",@"预约人",@"预约状态",@"预约时间",@"预约人",@"",@"",@"",@"", nil];
    [self getDataSource];
  
}
-(void)getDataSource{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService YuYueWithToken:token ReservationId:self.reservationId andBlock:^(NSDictionary *returnDic, NSError *error) {
      [hud hideAnimated:YES];
            if ([[returnDic objectForKey:@"code"]integerValue]==0) {
                if (_isMy==YES) {
                    if ([returnDic objectForKey:@"taskid"]!=NULL) {
                         tableview.frame=CGRectMake(0, 0, Width, Height-44-20-60);
                         NSArray *btnLabelArray=@[@"结束预约",@"重新预约"];
                        for (int i=0; i<2; i++) {
                            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 10,Width/2-60, 40)];
                                if (i==1) {
                                    button.frame=CGRectMake(Width-20-(Width/2-40), 10,Width/2-40, 40);
                                }else{
                                    button.frame=CGRectMake(10, 10,Width/2-40, 40);
                                }
                            button.clipsToBounds=YES;
                            button.layer.cornerRadius=5;
                            [button setTitle:[btnLabelArray objectAtIndex:i] forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
                            button.tag=101+i;
                            [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [self.view addSubview:button];
                        }

                    }else{
                        if ([[returnDic objectForKey:@"status"]isEqualToString:@"退回"]||[[returnDic objectForKey:@"status"]isEqualToString:@"已确认"]) {
                            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(20, 10,Width-40, 40)];
                            button.clipsToBounds=YES;
                            button.layer.cornerRadius=5;
                            [button setTitle:@"取消预约" forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            button.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
                            button.tag=100;
                            [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [self.view addSubview:button];
                        }
                    }
                }

            NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                returnData=[returnDic objectForKey:@"list"];
                NSArray *listArray=[returnData objectForKey:@"runTaskResult"];
                for (int i=0; i<listArray.count; i++) {
                    NSDictionary *dic=[listArray objectAtIndex:i];
                    NSArray *array=[dic objectForKey:@"varibles"];
                    if (array.count>0) {
                        [dataList addObject:dic];
                    }
                }
//                NSLog(@"预约列表详情      %@ ",str);
                [tableview reloadData];
                
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
-(void)commit:(UIButton*)sender{
    if (sender.tag==100) {
        [HZLoginService]
    }else  if (sender.tag==101) {
        
    }else  if (sender.tag==102) {
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger height;
    if (indexPath.section==0&&indexPath.row==0) {
        height=60;
    }else{
        height=40;
    }
    return height;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataList.count+2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number;
    switch (section) {
        case 0:
            number=3;
            break;
        case 1:
            number=5;
            break;
        default:
            number=0;
            break;
    }
    if (section>1) {
        NSDictionary *dic=[dataList objectAtIndex:section-2];
        if ([[dic objectForKey:@"whereuser"]integerValue]==1) {
            number=3;
        }else if ([[dic objectForKey:@"whereuser"]integerValue]==2) {
            number=5;
        }

    }
       return number;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, cell.frame.size.height)];
    [cell.contentView addSubview:bgView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 120, 20)];
    label.textAlignment=NSTextAlignmentRight;
    label.textColor=blueCyan;
    label.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:label];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(125, 10, 1, 20)];
    line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    [bgView addSubview:line];
    
    UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(130, 10, Width -140, 20)];
    text.textAlignment=NSTextAlignmentLeft;
    text.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:text];


    if (indexPath.section==0) {
        NSArray *subArray=@[@"预约项目",@"预约事项",@"预约前提条件"];
        NSString *str1=[returnData objectForKey:@"projectName"];
        NSString *str2=[returnData objectForKey:@"nodeName"];
//        NSString *str3=[returnData objectForKey:@"status"];
         NSString *str3=@"全部自主确认";
        if (str1==NULL||str1==nil)  str1=@"";
        if (str2==NULL||str2==nil)  str2=@"";
        if (str3==NULL||str3==nil)  str3=@"";
        NSArray *textArray=@[str1,str2,str3];
        label.text=[subArray objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            text.frame=CGRectMake(130, 0, Width -140, 40);
            text.numberOfLines=2;
        }
        text.text=[textArray objectAtIndex:indexPath.row];
    }else if (indexPath.section==1){
        NSArray *subArray=@[@"预约人",@"联系电话",@"设计院联系人",@"联系电话",@"预约时间"];
//        NSDictionary *unitUserInfo=[[returnData objectForKey:@"unitUserInfo"]objectAtIndex:0];
        NSString *str1=[returnData objectForKey:@"username"];
        NSString *str2=[returnData objectForKey:@"adminPhone"];
//        NSString *str3=[unitUserInfo objectForKey:@"username"];
//        NSString *str4=[unitUserInfo objectForKey:@"phone"];
        NSString *str3=[returnData objectForKey:@"designInstitutename"];
        NSString *str4=[returnData objectForKey:@"designInstitutephone"];
        NSString*str5=[returnData objectForKey:@"timeofappointment"];//时间戳
            if (str1==NULL||str1==nil)  str1=@"";
        if (str2==NULL||str2==nil)  str2=@"";
        if (str3==NULL||str3==nil)  str3=@"";
        if (str4==NULL||str4==nil)  str4=@"";
        if (str5==NULL||str5==nil)  str5=@"";
        
        NSArray *textArray=@[str1,str2,str3,str4,str5];
        label.text=[subArray objectAtIndex:indexPath.row];
        text.text=[textArray objectAtIndex:indexPath.row];
    }else{
        NSDictionary *dic=[dataList objectAtIndex:indexPath.section-2];
        if ([[dic objectForKey:@"whereuser"]integerValue]==1) {
            NSArray *subArray=@[@"预约时间",@"预约人",@"预约状态"];
            NSArray *itemArray=[dic objectForKey:@"varibles"];
            NSDictionary *timeDic=[itemArray objectAtIndex:0];
            NSDictionary *statusDic=[itemArray objectAtIndex:1];
            NSString *str1=[timeDic objectForKey:@"createtime"];
            NSString *str2=[dic objectForKey:@"name"];
            NSString *str3=[statusDic objectForKey:@"varibalevalue"];
            if (str1==NULL||str1==nil)  str1=@"";
            if (str2==NULL||str2==nil)  str2=@"";
            if (str3==NULL||str3==nil)  str3=@"";
            NSArray *textArray=@[str1,str2,str3];
            label.text=[subArray objectAtIndex:indexPath.row];
            text.text=[textArray objectAtIndex:indexPath.row];
        }else if ([[dic objectForKey:@"whereuser"]integerValue]==2) {
            NSArray *subArray=@[@"回复时间",@"办理人",@"回复状态",@"回复内容",@""];
            NSArray *itemArray=[dic objectForKey:@"varibles"];
            NSDictionary *timeDic=[itemArray objectAtIndex:3];
            NSDictionary *statusDic=[itemArray objectAtIndex:2];
            NSDictionary *detailsDic=[itemArray objectAtIndex:1];
            NSString *str1=[timeDic objectForKey:@"varibalevalue"];
            NSString *str2=[dic objectForKey:@"name"];
            NSString *str3=[statusDic objectForKey:@"varibalevalue"];
            NSString *str4=@"";
            NSString *str5=[detailsDic objectForKey:@"varibalevalue"];
            if (str1==NULL||str1==nil)  str1=@"";
            if (str2==NULL||str2==nil)  str2=@"";
            if (str3==NULL||str3==nil)  str3=@"";
            if (str4==NULL||str4==nil)  str4=@"";
             if (str5==NULL||str5==nil)  str5=@"";
            NSArray *textArray=@[str1,str2,str3,str4,str5];
            if (indexPath.row==4) {
                UILabel *details=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, Width -40, Height/20)];
                details.layer.cornerRadius=5;
                details.text=str5;
                details.layer.borderColor=[UIColor grayColor].CGColor;
                details.layer.borderWidth=1;
                details.textAlignment=NSTextAlignmentLeft;
                details.font=[UIFont systemFontOfSize:15];
                [cell.contentView addSubview:details];
            }else{
                label.text=[subArray objectAtIndex:indexPath.row];
                text.text=[textArray objectAtIndex:indexPath.row];
            }
        }
            }
    
    
    return cell;
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
