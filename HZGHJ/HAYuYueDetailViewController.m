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
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44-0)];
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
            NSData *data =    [NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"预约列表详情      %@",str);
                returnData=[returnDic objectForKey:@"list"];
                NSArray *array=[[returnDic objectForKey:@"list"]objectForKey:@"runTaskResult"];
                [dataList arrayByAddingObjectsFromArray:array];
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
    return dataList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number;
    switch (section) {
        case 0:
            number=3;
            break;
        case 1:
            number=7;
            break;
        default:
            number=0;
            break;
    }
    NSDictionary *dic=[dataList objectAtIndex:section];
    if ([[dic objectForKey:@"whereuser"]integerValue]==1) {
        number=3;
    }else if ([[dic objectForKey:@"whereuser"]integerValue]==2) {
        number=5;
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
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, cell.frame.size.height)];
    [cell.contentView addSubview:bgView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 120, 20)];
    label.textAlignment=NSTextAlignmentRight;
    label.numberOfLines=2;
    label.textColor=blueCyan;
    label.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:label];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(125, 10, 1, 20)];
    line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    [bgView addSubview:line];
    
    UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(130, 10, Width -140, Height/20)];
    text.textAlignment=NSTextAlignmentLeft;
    text.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:text];


    if (indexPath.section==0) {
        NSArray *subArray=@[@"预约项目",@"预约事项",@"预约前提条件"];
        NSString *str1=[returnData objectForKey:@"projectName"];
        NSString *str2=[returnData objectForKey:@"nodeName"];
        NSString *str3=[returnData objectForKey:@"status"];
        if (str1==NULL||str1==nil)  str1=@"";
        if (str2==NULL||str2==nil)  str2=@"";
        if (str3==NULL||str3==nil)  str3=@"";
        NSArray *textArray=@[str1,str2,str3];
        label.text=[labelArray objectAtIndex:indexPath.row];
        text.text=[textArray objectAtIndex:indexPath.row];
    }else if (indexPath.section==1){
        NSArray *subArray=@[@"预约人",@"联系电话",@"单位联系人",@"联系电话",@"设计院联系人",@"联系电话",@"预约时间"];
        NSDictionary *unitUserInfo=[returnData objectForKey:@"unitUserInfo"];
        NSString *str1=[returnData objectForKey:@"username"];
        NSString *str2=[returnData objectForKey:@"adminPhone"];
        NSString *str3=[unitUserInfo objectForKey:@"username"];
        NSString *str4=[unitUserInfo objectForKey:@"phone"];
        NSString *str5=[returnData objectForKey:@"designInstitutename"];
        NSString *str6=[returnData objectForKey:@"designInstitutephone"];
        NSString*str=[returnData objectForKey:@"designInstitutephone"];//时间戳
        NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str integerValue]/1000];
        //实例化一个NSDateFormatter对象
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];

        NSString *str7=currentDateStr;
        if (str1==NULL||str1==nil)  str1=@"";
        if (str2==NULL||str2==nil)  str2=@"";
        if (str3==NULL||str3==nil)  str3=@"";
        if (str4==NULL||str4==nil)  str4=@"";
        if (str5==NULL||str5==nil)  str5=@"";
        if (str6==NULL||str6==nil)  str6=@"";
         if (str7==NULL||str7==nil)  str7=@"";
        
        NSArray *textArray=@[str1,str2,str3,str4,str5,str6,str7];
        label.text=[labelArray objectAtIndex:indexPath.row];
        text.text=[textArray objectAtIndex:indexPath.row];
    }else{
        NSDictionary *dic=[dataList objectAtIndex:indexPath.section];
        if ([[dic objectForKey:@"whereuser"]integerValue]==1) {
            NSArray *subArray=@[@"预约时间",@"预约人",@"预约状态"];
            NSString *str1=[returnData objectForKey:@"projectName"];
            NSString *str2=[returnData objectForKey:@"nodeName"];
            NSString *str3=[returnData objectForKey:@"status"];
            if (str1==NULL||str1==nil)  str1=@"";
            if (str2==NULL||str2==nil)  str2=@"";
            if (str3==NULL||str3==nil)  str3=@"";
            NSArray *textArray=@[str1,str2,str3];
            label.text=[labelArray objectAtIndex:indexPath.row];
            text.text=[textArray objectAtIndex:indexPath.row];
        }else if ([[dic objectForKey:@"whereuser"]integerValue]==2) {
            
        }
        NSArray *subArray=@[@"预约人",@"联系电话",@"单位联系人",@"联系电话",@"设计院联系人",@"联系电话",@"预约时间"];
        NSString *str1=[[returnData objectForKey:@"message"]objectForKey:@"title"];
        NSString *str2=[returnData objectForKey:@"projectid"];
        NSString *str3=[[returnData objectForKey:@"project"]objectForKey:@"projectName"];
        NSString *str4=[[returnData objectForKey:@"constructionunit"]objectForKey:@"name"];
        NSString *str5=[[returnData objectForKey:@"process"]objectForKey:@"name"];
        NSString *str6=[returnData objectForKey:@"hostdepartment"];
        if (str1==NULL||str1==nil)  str1=@"";
        if (str2==NULL||str2==nil)  str2=@"";
        if (str3==NULL||str3==nil)  str3=@"";
        if (str4==NULL||str4==nil)  str4=@"";
        if (str5==NULL||str5==nil)  str5=@"";
        if (str6==NULL||str6==nil)  str6=@"";
        
        NSArray *textArray=@[str1,str2,str3,str4,str5,str6];
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
