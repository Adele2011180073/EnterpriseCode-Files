//
//  HZLocateContentViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZLocateContentViewController.h"
#import "HZLocateContentCellTableViewCell.h"


@interface HZLocateContentViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_subTitleArray;
}

@end

@implementation HZLocateContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"基本信息填写";
    
    _subTitleArray=[[NSArray alloc]initWithObjects:@"申请人",@"项目名称",@"法定代表人、自然人（受托人）",@"手机",@"电话",@"申请建设规模",@"申请用地面积",@"用地目前用途", @"建设地址",nil];
    self.bgtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Width-44)];
    self.bgtableview.delegate=self;
    self.bgtableview.dataSource=self;
    self.bgtableview.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.bgtableview.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.bgtableview];
//    [self addSubView];
}
//-(void)addSubView{
//    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
//    titleLabel.backgroundColor=[UIColor whiteColor];
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.text=@"审批事项名称：建设项目选址审批";
//    titleLabel.textAlignment=NSTextAlignmentLeft;
//    [self.bgScrollview addSubview:titleLabel];
//    
//    
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _subTitleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //通过xib构建cell
    HZLocateContentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HZLocateContentCellTableViewCell" owner:nil options:nil];
        cell = [nibs firstObject];
    }
    cell.subLabel.numberOfLines = 0;
    cell.subLabel.text = [_subTitleArray objectAtIndex:indexPath.row];
    cell.textview.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈";
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
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
