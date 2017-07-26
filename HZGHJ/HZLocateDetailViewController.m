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
//#import "HZMapServiceViewController.h"


@interface HZLocateDetailViewController (){
    NSMutableArray *btnArray;
}

@end

@implementation HZLocateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"受理条件";
    
    NSMutableArray *titleArray=[[NSMutableArray alloc]init];
    if (self.PCODE==0||self.PCODE==1||self.PCODE==2||self.PCODE==3) {
        NSArray *array=[[NSArray alloc]initWithObjects:@"一、符合经批准的控制性详细规划；",@"二、符合规划管理技术规范和标准的要求；",@"三、建设项目需要批准、核准的证明文件；", nil];
        [titleArray addObjectsFromArray:array];
    }else if (self.PCODE==4||self.PCODE==5) {
        NSArray *array=[[NSArray alloc]initWithObjects:@"一、符合经批准的控制性详细规划或专项规划；",@"二、符合规划管理技术规范和标准的要求；",@"三、建设项目批准、核准、备案文件；",@"四、出让土地项目取得土地出让合同；",@"五、因建设项目施工或地质勘查需要临时使用土地的情形；",@"六、申请材料齐全且符合法定形式。", nil];
        [titleArray addObjectsFromArray:array];
    }else if (self.PCODE==6||self.PCODE==7) {
         NSArray *array=[[NSArray alloc]initWithObjects:@"一、符合经批准的控制性详细规划或专项规划；",@"二、符合规划管理技术规范和标准的要求；",@"三、出具项目服务联系单、项目备案等文件；",@"四、申请材料齐全且符合法定形式。", nil];
        [titleArray addObjectsFromArray:array];
    }
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(Width-100, 30, 50, 30)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.text=@"全选";
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:titleLabel];
    UIButton *selectAllImage=[[UIButton alloc]initWithFrame:CGRectMake(Width-50,30, 30, 30)];
    [selectAllImage addTarget:self action:@selector(checkAllBox:) forControlEvents:UIControlEventTouchUpInside];
    [selectAllImage setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [selectAllImage setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
    [self.view addSubview:selectAllImage];
    
    btnArray=[[NSMutableArray alloc]init];
    for (int i=0; i<titleArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 70+50*i, Width-100, 40)];
        label.font=[UIFont systemFontOfSize:16];
        label.numberOfLines=2;
        label.text=[titleArray objectAtIndex:i];
        label.textAlignment=NSTextAlignmentLeft;
        [self.view addSubview:label];
        
        UIButton *image=[[UIButton alloc]initWithFrame:CGRectMake(Width-50,80+50*i, 30, 30)];
        [image addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
        image.tag=20+i;
        [image setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [image setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
        [self.view addSubview:image];
        [btnArray addObject:image];
    }
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 80+50*titleArray.count, Width-40, 40)];
    label.font=[UIFont systemFontOfSize:16];
    label.numberOfLines=2;
    label.textColor=[UIColor grayColor];
    label.text=@"提示：必须全部勾选受理条件才能在线办理事项！";
    label.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:label];
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(Width/2-80,140+50*titleArray.count, 160, 40)];
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
-(void)checkAllBox:(UIButton *)sender{
    sender.selected=!sender.selected;
    UIButton *button1=[self.view viewWithTag:20];
    UIButton *button2=[self.view viewWithTag:21];
    UIButton *button3=[self.view viewWithTag:22];
    for (int i=0; i<btnArray.count; i++) {
        UIButton *button=[btnArray objectAtIndex:i];
        if (sender.selected==YES) {
            button.selected=YES;
//            button2.selected=YES;
//            button3.selected=YES;
        }else{
            button.selected=NO;
//            button2.selected=NO;
//            button3.selected=NO;
        }

    }
//    if (sender.selected==YES) {
//        button1.selected=YES;
//        button2.selected=YES;
//        button3.selected=YES;
//    }else{
//        button1.selected=NO;
//        button2.selected=NO;
//        button3.selected=NO;
//    }
}
-(void)commit{
    UIButton *button1=[self.view viewWithTag:20];
    UIButton *button2=[self.view viewWithTag:21];
    UIButton *button3=[self.view viewWithTag:22];
    if (button1.selected==YES&&button2.selected==YES&&button3.selected==YES) {
        HZLocateContentViewController *content=[[HZLocateContentViewController alloc]init];
        content.qlsxcode=self.qlsxcode;
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
