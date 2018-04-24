//
//  HZOptionViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/6/28.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZOptionViewController.h"
#import "MBProgressHUD.h"
#import "UIViewController+BackButtonHandler.h"
#import "HZLocateDetailViewController.h"
#import "HZBanShiService.h"

@interface HZOptionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    UIView *_searchView;//查询页面
    UISegmentedControl *segmented;
    NSMutableArray *_dataList;
    UIScrollView *_scrollCheckView;
    NSMutableArray *_checkBoxArray;
    NSInteger checkNum;
}


@end

@implementation HZOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title=@"请选择办理的窗口";
    
    _dataList=[[NSMutableArray alloc]init];
    _checkBoxArray=[[NSMutableArray alloc]init];
    [self getResourceData];
    _scrollCheckView=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 40, Width-20, 180)];
    _scrollCheckView.userInteractionEnabled=YES;
    _scrollCheckView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    _scrollCheckView.layer.cornerRadius=8;
    _scrollCheckView.clipsToBounds=YES;
//    _scrollCheckView.layer.borderColor=blueCyan.CGColor;
//    _scrollCheckView.layer.borderWidth=1;
    [self.view addSubview:_scrollCheckView];

    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 240, Width-60, 30)];
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.text=@"提示：必须选择一个窗口才能办理";
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:titleLabel];
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(20,320, Width-40, 40)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=5;
    [commit setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:commit];
    
    NSString *qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    if ([qlsxcode isEqualToString:@"598ea023-d3cc-4168-b3fb-529ffff53d8d"]) {
        commit.frame=CGRectMake(20, 460, Width-40, 40);
        UIScrollView *radioCheckView=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 300, Width-20, 80)];
        radioCheckView.userInteractionEnabled=YES;
        radioCheckView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        radioCheckView.layer.cornerRadius=8;
        radioCheckView.clipsToBounds=YES;
        [self.view addSubview:radioCheckView];
        NSArray *typeArray=@[@"建筑类",@"市政类"];
        for (int i=0; i<typeArray.count; i++) {
            UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5+40*i, Width-80, 30)];
            titleLabel.textColor=[UIColor blackColor];
            titleLabel.textAlignment=NSTextAlignmentLeft;
            titleLabel.font=[UIFont systemFontOfSize:16];
            [radioCheckView addSubview:titleLabel];
            UIButton *image=[[UIButton alloc]initWithFrame:CGRectMake(20,5+40*i, 30, 30)];
            [image addTarget:self action:@selector(selectBox:) forControlEvents:UIControlEventTouchUpInside];
            [image setImage:[UIImage imageNamed:@"select_1"] forState:UIControlStateNormal];
            image.tag=20+i;
            [image setImage:[UIImage imageNamed:@"select_4"] forState:UIControlStateSelected];
            [radioCheckView addSubview:image];
            NSString *text=[typeArray objectAtIndex:i];
            titleLabel.text=[NSString stringWithFormat:@"%@",text];
        }
        UILabel*titleLabel2=[[UILabel alloc]initWithFrame:CGRectMake(50, 400, Width-60, 30)];
        titleLabel2.textColor=[UIColor grayColor];
        titleLabel2.text=@"提示：必须选择一种类别才能办理";
        titleLabel2.textAlignment=NSTextAlignmentLeft;
        titleLabel2.font=[UIFont systemFontOfSize:15];
        [self.view addSubview:titleLabel2];
    }
}
-(void)getResourceData{
    [HZBanShiService BanShiWithAndBlock:^(NSDictionary *returnDic, NSError *error) {
        if (returnDic) {
            NSArray *obj=[returnDic objectForKey:@"obj"];
            _dataList=[NSMutableArray arrayWithArray:obj];
            [self addCheckBoxView];
        }
    }];
}
-(void)addCheckBoxView{
    _scrollCheckView.contentSize=CGSizeMake(Width-20, 30*_dataList.count);
    for (int i=0; i<_dataList.count; i++) {
        NSDictionary *smallDic=[_dataList objectAtIndex:i];
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5+30*i, Width-80, 20)];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.font=[UIFont systemFontOfSize:15];
        [_scrollCheckView addSubview:titleLabel];
        UIButton *image=[[UIButton alloc]initWithFrame:CGRectMake(20,30*i, 30, 30)];
        [image addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
        [image setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        image.tag=10+i;
        [image setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
        [_scrollCheckView addSubview:image];
        [_checkBoxArray addObject:image];
        NSString *text=[smallDic objectForKey:@"orgName"];
        titleLabel.text=[NSString stringWithFormat:@"%@",text];
    }
}
-(void)checkBox:(UIButton *)sender{
    for (int i=0; i<_checkBoxArray.count; i++) {
        UIButton *button=[_checkBoxArray objectAtIndex:i];
        button.selected=NO;
    }
    checkNum=sender.tag;
    sender.selected=YES;
}
-(void)selectBox:(UIButton *)sender{
    UIButton *button1=(UIButton*)[self.view viewWithTag:20];
    UIButton *button2=(UIButton*)[self.view viewWithTag:21];
    if (sender.tag==20) {
        button1.selected=YES;
         button2.selected=NO;
    }else if (sender.tag==21) {
        button1.selected=NO;
        button2.selected=YES;
    }
}
-(void)commit{
    BOOL ischeck=NO;
    for (int i=0; i<_checkBoxArray.count; i++) {
         UIButton *button=(UIButton*)[_checkBoxArray objectAtIndex:i];
        if (button.selected==YES) {
            ischeck=YES;
        }
    }
    if (ischeck==NO) {
          UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"必须选择一个窗口才能办理" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSString *qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    if ([qlsxcode isEqualToString:@"598ea023-d3cc-4168-b3fb-529ffff53d8d"]) {
        UIButton *button1=(UIButton*)[self.view viewWithTag:20];
        UIButton *button2=(UIButton*)[self.view viewWithTag:21];
        if (button1.selected==NO&&button2.selected==NO) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"必须选择一种类别才能办理" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
  
    
    NSDictionary *orgDic=[_dataList objectAtIndex:checkNum-10];
    HZLocateDetailViewController *details=[[HZLocateDetailViewController alloc]init];
    details.qlsxcodeDic=self.qlsxcodeDic;
     if ([qlsxcode isEqualToString:@"598ea023-d3cc-4168-b3fb-529ffff53d8d"]) {
         UIButton *button1=(UIButton*)[self.view viewWithTag:20];
         UIButton *button2=(UIButton*)[self.view viewWithTag:21];
         if (button1.selected==YES) {
             details.type=@"建筑类";
         }else if (button2.selected==YES) {
             details.type=@"市政类";
         }
     }
    details.orgId=[orgDic objectForKey:@"orgId"];
    NSLog(@"orgDic   %@",orgDic);
    [self.navigationController pushViewController:details animated:YES];
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
