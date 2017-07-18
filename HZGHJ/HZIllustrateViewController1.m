//
//  HZIllustrateViewController1.m
//  HZGHJ
//
//  Created by zhang on 2017/7/4.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZIllustrateViewController1.h"

@interface HZIllustrateViewController1 ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableview;
    NSMutableArray *_dataList;
}


@end

@implementation HZIllustrateViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"说明事项";
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    _dataList=[[NSMutableArray alloc]initWithObjects:@"1.本表格适用于一般划拔供地方式建设项目（注：划拔存量土地上对现有建筑物、构筑物进行改建、翻建适用于规划条件申请表格），以及私房修缮、排危翻建、风景名胜区建设项目、集体土地建设项目的选址意见书的申请。",@"2.申请人为单位的，须加盖单位公章（公章加盖在表格下方承诺栏内）。",@"3.申请人需提供拟建设位置1/1000地形图一份（需划定规划控制线），用铅笔标明拟用地位置。地形图由申请人向杭州市规划局驻市行政服务中心综合服务窗口申请。",@"4.提供土地证的请检查验证日期，逾期未验证的视作无效。", @"5.如有选址论证报告审查意见（涉及控规调整同步提供简复单）及报告文本（成果稿)、电子光盘（要求编制选址论证报告的项目提供）要求提供。",@"6.属于原址改建项目，需附送土地权属证件（复印件）一份。",@"7.修缮、排危翻建项目申请报告需由当地街道或相关部门盖章认可；报审前需委托相关部门做危房鉴定报告。（私房翻建类需提供户主户口本复印件）",@"8.西湖风景名胜区建设项目须先行报市“三委四局”(牵头部门：市旅委)审查，选址意见书按规定由省建设厅核发的，我局负责建设项目选址批准书(建设项目申报书)的规划审查。",@"9. 本表及相关文件、图纸向规划局办证窗口递交后，请向项目办证窗口索取收件回执一份，申请人并按要求办理有关事项。办理结果将以手机短信方式通知申请单位联系人。",@"10. 为确保报建资料的真实性，各类实质性审查文件、协议等证明材料的复印件均需提供原件核对。",@"11. 本表应由申请人如实填写，如由于填写不实而发生的一切矛盾、纠纷，均由申请人负责。",@"12. 该申请表格可从规划局网站下载，规划局网址：http://www.hzplanning.gov.cn。",@"13. 受理地点：杭州解放东路18号，市行政服务中心规划窗口   咨询电话：85085216",@"上城区受理点：上城区秋涛路242-2号秋涛发展大厦A座上城区行政服务中心   咨询电话：87925918",@"下城区受理点：下城区白石巷256号下城区行政区服务中心   咨询电话：87939789",@"拱墅区受理点：杭州市北城街55号（湖州街与杭行路交叉口向南约500米）   咨询电话：58237045",@"西湖区受理点：西湖区竞舟路228号西湖区行政服务中心      咨询电话：87006923",@"江干区受理点：江干区运河东路200号江干区行政服务中心    咨询电话：87654137",@"之江受理点：五云中路1号，之江管委会B楼                咨询电话86653020",@"开发区受理点：杭州经济技术开发区幸福南路1116号经济技术开发区行政服务中心      咨询电话：89898543",nil];
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64)];
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
    cell.textLabel.textColor=[UIColor darkGrayColor];
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
