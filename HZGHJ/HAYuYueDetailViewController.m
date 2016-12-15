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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"预约详情";
    
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44-0)];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=160;
    tableview.backgroundColor=[UIColor whiteColor];
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
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
//                NSArray *array=[returnDic objectForKey:@"reservationlist"];
            NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                [tableview reloadData];
                NSLog(@"预约列表    %@  %@",str,returnDic);
                
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger height;
    if (indexPath.section==5&&indexPath.row==4) {
        height= 60;
    }else if (indexPath.section==0&&indexPath.row==0) {
        height= 40;
    }else{
       height= Height/16;
    }
    return height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     NSInteger number;
    if (section==0) {
        number=3;
    }else if (section==1){
        number=7;
    }else if (section==1){
        number=3;
    }
    else if (section==1){
        number=3;
    }
    else if (section==1){
        number=4;
    }

    return number;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.backgroundColor=[UIColor whiteColor];
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, Width-20, 150)];
    bgView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    bgView.layer.borderWidth=1;
    bgView.layer.cornerRadius=5;
    bgView.layer.borderColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1].CGColor;
    [cell.contentView addSubview:bgView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-40, 45)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.numberOfLines=2;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:17];
    [bgView addSubview:titleLabel];
    UILabel*subTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, Width-40, 20)];
    subTitle.textColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    subTitle.textAlignment=NSTextAlignmentLeft;
    subTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:subTitle];
    UILabel*nameTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 65, Width-40, 17)];
    titleLabel.textColor=[UIColor blackColor];
    nameTitle.textAlignment=NSTextAlignmentLeft;
    nameTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:nameTitle];
    UILabel* phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 82, Width-40, 17)];
    titleLabel.textColor=[UIColor blackColor];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:phoneLabel];
    UILabel*timeTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 99, Width-40, 17)];
    timeTitle.textColor=[UIColor blackColor];
    timeTitle.textAlignment=NSTextAlignmentLeft;
    timeTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:timeTitle];
    UILabel*statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 116, 80, 20)];
    statusLabel.textAlignment=NSTextAlignmentLeft;
    statusLabel.font=[UIFont systemFontOfSize:15];
    statusLabel.textColor=[UIColor blueColor];
    [bgView addSubview:statusLabel];
    UILabel*subLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 116, 100, 20)];
    subLabel.text=@"预约状态";
    subLabel.textAlignment=NSTextAlignmentLeft;
    subLabel.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:subLabel];
    
//    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
//    titleLabel.text=[NSString stringWithFormat:@"预约项目  %@",[dic objectForKey:@"projectName"]];
//    subTitle.text=[NSString stringWithFormat:@"办理事项  %@",[dic objectForKey:@"nodeName"]];
//    nameTitle.text=[NSString stringWithFormat:@"预约人  %@",[dic objectForKey:@"username"]];
//    phoneLabel.text=[NSString stringWithFormat:@"电话  %@",[dic objectForKey:@"userphone"]];
//    timeTitle.text=[NSString stringWithFormat:@"预约时间  %@",[dic objectForKey:@"timeofappointment"]];
//    statusLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    
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
