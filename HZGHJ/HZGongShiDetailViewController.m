//
//  HZGongShiDetailViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/14.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZGongShiDetailViewController.h"
#import "MBProgressHUD.h"
#import "HZLoginService.h"
@interface HZGongShiDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    NSDictionary *returnData;
    NSArray *labelArray;
}


@end

@implementation HZGongShiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"公示详情(起始日)";
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.backgroundColor=[UIColor whiteColor];
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    [self.view addSubview:tableview];
      [self getDataSource];
}
-(void)getDataSource{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
//    [HZLoginService YuYueWithToken:token ReservationId:self.reservationId andBlock:^(NSDictionary *returnDic, NSError *error) {
//        [hud hideAnimated:YES];
//        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
//            //                NSArray *array=[returnDic objectForKey:@"reservationlist"];
//            NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            //                [tableview reloadData];
//            NSLog(@"预约列表    %@  %@",str,returnDic);
//            
//        }
//    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger number;
    switch (self.type) {
        case 1:
            number=5;
            break;
        case 2:
            number=5;
            break;
        case 3:
            number=5;
            break;
        case 4:
            number=5;
            break;
        default:
            break;
    }
    return number;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger height;
    if (indexPath.section==0) {
         height= 90;
    }else{
         height= 70;
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      NSInteger height;
    if (section==0) {
        height=0;
    }else{
        height=40;
    }
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, Width, 20)];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:15];
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
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
