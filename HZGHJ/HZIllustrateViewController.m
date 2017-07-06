
//
//  HZIllustrateViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/6/2.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZIllustrateViewController.h"

@interface HZIllustrateViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableview;
    NSMutableArray *_dataList;
}

@end

@implementation HZIllustrateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"填表说明 ";
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    _dataList=[[NSMutableArray alloc]initWithObjects:@"1、建设项目选址意见书申请表必须填写，且必须拍照上传纸质文件。",@"2、拟建位置1/1000带规划控制线地形图1份(用铅笔标明拟用地位置)，可通过三选一的方式提供。",@"3、非必要的材料可拍照上传，也可不拍照上传。如遇到光盘的存储介质的材料无法上传的，可拍照证明材料有。",@"4、所有必要材料拍照上传最少一张。", nil];
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-44)];
    _tableview.estimatedRowHeight=60;
    // 设置行高自动计算
    _tableview.rowHeight = UITableViewAutomaticDimension;
    _tableview.delegate=self;
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableview.tableFooterView = [[UIView alloc] init];
        _tableview.separatorColor=[UIColor clearColor];
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSString *text=[_dataList objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",text];
    cell.textLabel.numberOfLines=0;
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
