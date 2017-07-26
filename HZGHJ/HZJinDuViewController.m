//
//  HZJinDuViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/9.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZJinDuViewController.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "HZLoginService.h"
#import "HZJingDuDetailViewController.h"
#import "UIView+Toast.h"
#import "HZLoginViewController.h"

@interface HZJinDuViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    int pageIndex;
    UITableView *tableview;
    UISegmentedControl *segmented;
    UIButton *pos;
    UITextField *textField;
    
}


@end

@implementation HZJinDuViewController
@synthesize dataList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"进度查询";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, Width-110, 40)];
    textField.backgroundColor=[UIColor whiteColor];
    textField.placeholder=@"请输入项目名称进行查询";
    textField.layer.borderWidth=1;
    textField.clearsOnBeginEditing=YES;
    textField.layer.cornerRadius=5;
    textField.delegate=self;
    textField.layer.borderColor=blueCyan.CGColor;
    [self.view addSubview:textField];
    
    UIButton *search=[[UIButton alloc]initWithFrame:CGRectMake(Width-80, 5, 70, 40)];
    search.backgroundColor=[UIColor whiteColor];
    [search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [search setTitle:@"搜索" forState:UIControlStateNormal];
    search.layer.cornerRadius=5;
    search.layer.borderColor=blueCyan.CGColor;
    search.layer.borderWidth=1;
    [search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search];
    
    UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(30, 55, 40, 40)];
    imageTitle.textColor=blueCyan;
    imageTitle.font=[UIFont fontWithName:@"iconfont" size:36];
    imageTitle.text=@"\U0000e615";
    imageTitle.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:imageTitle];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(80, 65, Width-100, 20)];
    title.textColor=[UIColor blackColor];
    title.font=[UIFont systemFontOfSize:16];
    title.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"department"];
    title.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:title];
    
    pageIndex=1;
    dataList=[[NSMutableArray alloc]init];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, Width, Height-44-100)];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableview.rowHeight=130;
    tableview.delegate=self;
    tableview.separatorColor=[UIColor clearColor];
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    [self getDataSource];
    __weak HZJinDuViewController *yuyue=self;
    [tableview addInfiniteScrollingWithActionHandler:^{
        pageIndex=pageIndex+1;
        [yuyue getDataSource];
    }];
    [tableview addPullToRefreshWithActionHandler:^{
        pageIndex=1;
        [yuyue getDataSource];
    }];
    [tableview.pullToRefreshView setTitle:@"下拉以刷新" forState:SVPullToRefreshStateTriggered];
    [tableview.pullToRefreshView setTitle:@"刷新完了哟" forState:SVPullToRefreshStateStopped];
    [tableview.pullToRefreshView setTitle:@"不要命的加载中..." forState:SVPullToRefreshStateLoading];
}
- (void)search:(UIButton *)sender {
    
    if ([textField.text isEqualToString:@""]||textField.text==NULL) {
        pageIndex=1;
        [self getDataSource];
    }else{
           NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=0; i<dataList.count; i++) {
            NSDictionary *dic=[dataList objectAtIndex:i];
            NSString*str=[dic objectForKey:@"projectName"];
            if ([str rangeOfString:textField.text].location !=NSNotFound) {
                [array addObject:dic];
            }
        }
        dataList=[NSMutableArray arrayWithArray:array];
        [tableview reloadData];
    }
   }
-(void)getDataSource{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"数据加载中，请稍候...";
    [tableview.infiniteScrollingView stopAnimating];
    [tableview.pullToRefreshView stopAnimating];
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [HZLoginService JinDuGetWithToken:token pageIndex:pageIndex andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            NSArray *array=[returnDic objectForKey:@"list"];
                dataList=[[NSMutableArray alloc]init];
                dataList=[NSMutableArray                                                                                                                                                                                                                                                                                                                                           arrayWithArray:array];
            if (dataList.count<1||dataList==NULL) {
                [self.view makeToast:@"暂时没有数据" duration:2 position:CSToastPositionBottom];
            }
                [tableview reloadData];
            
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
         
        }else   if ([[returnDic objectForKey:@"code"]integerValue]==1000) {
                [self.view makeToast:@"您的进度暂时还无数据"];
        }else{
            [self.view makeToast:@"请求失败，请重新尝试"];
        }
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, Width, 120)];
    bgView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-40, 40)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.numberOfLines=2;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [bgView addSubview:titleLabel];
    UILabel*subTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, Width-40, 25)];
    subTitle.textColor=[UIColor grayColor];
    subTitle.textAlignment=NSTextAlignmentLeft;
    subTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:subTitle];
    UILabel*nameTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 65, Width-40, 25)];
    nameTitle.textColor=[UIColor grayColor];
    nameTitle.textAlignment=NSTextAlignmentLeft;
    nameTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:nameTitle];
    UILabel* phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, Width-40, 25)];
    phoneLabel.textColor=[UIColor grayColor];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:phoneLabel];
    UILabel*timeTitle=[[UILabel alloc]initWithFrame:CGRectMake(80, 80, 100, 20)];
    timeTitle.textColor=[UIColor blueColor];
    timeTitle.textAlignment=NSTextAlignmentLeft;
    timeTitle.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:timeTitle];
    
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"projectName"]];
    NSDictionary *itemsDic=[[dic objectForKey:@"items"]objectAtIndex:0];
    subTitle.text=[NSString stringWithFormat:@"项目阶段：%@",[itemsDic objectForKey:@"processName"]];
//    NSString*str=[dic objectForKey:@"startDate"];//时间戳
//    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str integerValue]/1000];
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    nameTitle.text=[NSString stringWithFormat:@"联系方式：%@",[itemsDic objectForKey:@"adminPhone"]];
    phoneLabel.text=[NSString stringWithFormat:@"经办人: %@",[itemsDic objectForKey:@"adminName"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HZJingDuDetailViewController *detail=[[HZJingDuDetailViewController alloc]init];
    NSDictionary *dic=[dataList objectAtIndex:indexPath.row];
    detail.projectid=[dic objectForKey:@"projectid"];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [self.view endEditing:YES];
    return true;
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
