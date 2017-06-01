//
//  HZLocateDetailViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZLocateDetailViewController.h"
#import "HZLocateContentViewController.h"
#import "UIView+Toast.h"
#import "HZMapServiceViewController.h"


@interface HZLocateDetailViewController ()

@end

@implementation HZLocateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"受理条件";
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"一、符合经批准的控制性详细规划；",@"二、符合规划管理技术规范和标准的要求；",@"三、建设项目需要批准、核准的证明文件；", nil];
    for (int i=0; i<3; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 40+50*i, Width-100, 20)];
        label.font=[UIFont systemFontOfSize:16];
        label.text=[titleArray objectAtIndex:i];
        label.textAlignment=NSTextAlignmentLeft;
        [self.view addSubview:label];
        
        UIButton *image=[[UIButton alloc]initWithFrame:CGRectMake(Width-40,40+50*i, 30, 30)];
        [image addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
        image.tag=20+i;
        [image setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [image setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
        [self.view addSubview:image];
    }
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 200, Width-20, 40)];
    label.font=[UIFont systemFontOfSize:16];
    label.numberOfLines=2;
    label.textColor=[UIColor grayColor];
    label.text=@"受理条件必须全部勾选！";
    label.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:label];
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-60,280, 120, 40)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=5;
    [commit setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:commit];
}
-(void)checkBox:(UIButton *)sender{
    sender.selected=!sender.selected;
}
-(void)commit{
    UIButton *button1=[self.view viewWithTag:20];
    UIButton *button2=[self.view viewWithTag:21];
    UIButton *button3=[self.view viewWithTag:22];
    if (button1.selected==YES&&button2.selected==YES&&button3.selected==YES) {
        HZMapServiceViewController *content=[[HZMapServiceViewController alloc]init];
        [self.navigationController pushViewController:content animated:YES];
    }else{
        [self.view makeToast:@"必须全部勾选受理条件才能在线办理事项"];
    }
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
