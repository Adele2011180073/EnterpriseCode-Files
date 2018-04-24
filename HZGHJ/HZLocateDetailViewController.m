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
    NSString * qlsxcode=[self.qlsxcodeDic objectForKey:@"qlsxcode"];
    if ([qlsxcode isEqualToString:@"EAF31D8225045AE8CFA4E04C961F5D86"]||[qlsxcode isEqualToString:@"1FE087B8241745F16C0133ABB4832B8C"]||[qlsxcode isEqualToString:@"06C6B52BF5142FB69BA0113DFD08C77B"]||[qlsxcode isEqualToString:@"0496B51F3AB9B5135F85F31B8F255857"]) {
        NSArray *array=[[NSArray alloc]initWithObjects:@"一、符合经批准的控制性详细规划；",@"二、符合规划管理技术规范和标准的要求；",@"三、建设项目需要批准、核准的证明文件。", nil];
        [titleArray addObjectsFromArray:array];
    }else if ([qlsxcode isEqualToString:@"716c0ebb-d774-42f5-84da-54b0b143bc06"]||[qlsxcode isEqualToString:@"c0865333-0cbd-4440-86da-3386defefdba"]) {
         NSArray *array=[[NSArray alloc]initWithObjects:@"一、符合经批准的控制性详细规划或专项规划；",@"二、符合规划管理技术规范和标准的要求；",@"三、建设项目批准、核准、备案文件；",@"四、出让土地项目取得土地出让合同；",@"五、因建设项目施工或地质勘查需要临时使用土地的情形；",@"六、申请材料齐全且符合法定形式。", nil];
        [titleArray addObjectsFromArray:array];
    }else if ([qlsxcode isEqualToString:@"0ef7e0ce-bb77-4979-8cc3-166d08712b96"]||[qlsxcode isEqualToString:@"b8e6c1ea-6f89-4a2d-af17-78183b3e8a9f"]) {
         NSArray *array=[[NSArray alloc]initWithObjects:@"一、符合经批准的控制性详细规划或专项规划；",@"二、符合规划管理技术规范和标准的要求；",@"三、出具项目服务联系单、项目备案等文件；",@"四、申请材料齐全且符合法定形式。", nil];
        [titleArray addObjectsFromArray:array];
    }else if ([qlsxcode isEqualToString:@"31104F35575B4CB91AA7D5C014E730B1"]||[qlsxcode isEqualToString:@"F16BFFA466D5374C9D991F026936438F"]||[qlsxcode isEqualToString:@"42CBF39D427712000C357F3E7494007B"]||[qlsxcode isEqualToString:@"51760F1375EB1CF64A180319B743C392"]) {
        NSArray *array=[[NSArray alloc]initWithObjects:@"一、按照国家规定需要批准、核准的建设项目，以划拨方式提供国有土地使用权的建设项目；",@"二、符合城市市总体规划、专项规划和控制性详细规划等相关规划。", nil];
        [titleArray addObjectsFromArray:array];
    }else if ([qlsxcode isEqualToString:@"598ea023-d3cc-4168-b3fb-529ffff53d8d"]||[qlsxcode isEqualToString:@"6241e908-79a4-4782-b5de-204178602601"]) {
        NSArray *array=[[NSArray alloc]initWithObjects:@"一、取得土地使用权；",@"二、符合城市控制性详细规划、规划设计条件、城市规划管理等技术规范。", nil];
        [titleArray addObjectsFromArray:array];
    }else if ([qlsxcode isEqualToString:@"87ed0a9d-856b-45d3-8e4a-2fa4e32715f5"]) {
        NSArray *array=[[NSArray alloc]initWithObjects:@"一、建设工程已竣工；",@"二、具备竣工规划核实的条件。", nil];
        [titleArray addObjectsFromArray:array];
    }else if ([qlsxcode isEqualToString:@"3e9b0641-3a76-4cfe-9666-72350d2385d8"]) {
        NSArray *array=[[NSArray alloc]initWithObjects:@"一、取得土地使用权；",@"二、符合控制性详细规划、规划条件、城市规划管理技术规定等；",@"三、建筑设计成果、内容及深度应符合《建筑工程设计文件编制深度规定》（建质[2008]216号）要求及相关技术标准和规范。", nil];
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
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 80+60*i, Width-100, 60)];
        label.font=[UIFont systemFontOfSize:15];
        label.numberOfLines=3;
        label.textColor=[UIColor darkGrayColor];
        label.text=[titleArray objectAtIndex:i];
        label.textAlignment=NSTextAlignmentLeft;
        [self.view addSubview:label];
        
        UIButton *image=[[UIButton alloc]initWithFrame:CGRectMake(Width-50,85+60*i, 30, 30)];
        [image addTarget:self action:@selector(checkBox:) forControlEvents:UIControlEventTouchUpInside];
        image.tag=20+i;
        [image setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [image setImage:[UIImage imageNamed:@"checkbox_fill"] forState:UIControlStateSelected];
        [self.view addSubview:image];
        [btnArray addObject:image];
    }
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 120+60*titleArray.count, Width-40, 40)];
    label.font=[UIFont systemFontOfSize:15];
    label.numberOfLines=2;
    label.textColor=[UIColor grayColor];
    label.text=@"提示：必须全部勾选受理条件才能在线办理事项！";
    label.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:label];
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(30,200+60*titleArray.count, Width-60, 40)];
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
    for (int i=0; i<btnArray.count; i++) {
        UIButton *button=[btnArray objectAtIndex:i];
        if (sender.selected==YES) {
            button.selected=YES;
        }else{
            button.selected=NO;
        }

    }

}
-(void)commit{
    for (int i=0; i<btnArray.count; i++) {
        UIButton *button=[btnArray objectAtIndex:i];
        if (button.selected==NO) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"必须全部勾选受理条件才能在线办理事项" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
        HZLocateContentViewController *content=[[HZLocateContentViewController alloc]init];
        content.orgId=self.orgId;
        content.type=self.type;
        content.qlsxcodeDic=self.qlsxcodeDic;
        [self.navigationController pushViewController:content animated:YES];
    
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
