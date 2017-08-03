//
//  HZRegisterViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/7/25.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZRegisterViewController.h"
#import "MBProgressHUD.h"
#import "HZURL.h"
#import "HZLoginService.h"
#import "HZHomeViewController.h"
#import "UIView+Toast.h"
#import "UITextView+PlaceHolder.h"
#import "HZRegistCell.h"
#import "BSRegexValidate.h"
#import "HZLoginViewController.h"

@interface HZRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    NSDictionary *responseData;
    UITableView *_tableview;
    NSArray *_titleArray;
    NSArray *_placeArray;
}


@end

@implementation HZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController                                                                                                                                                                                                                                                                                                                                                                                         .navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bgg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
     self.title=@"注册";
    
    _titleArray=[[NSArray alloc]initWithObjects:@"账号",@"用户名",@"密码",@"联系手机",@"职位",@"建设单位",@"建设单位地址",@"建设单位联系人",@"建设单位联系电话", nil] ;
    _placeArray=[[NSArray alloc]initWithObjects:@"请输入账号(6-12位字母或者数字)",@"请输入用户名(不超过10位数)",@"请输入密码(6-12位字母或者数字)",@"请输入联系方式(11位)",@"请输入职位(不超过10位)",@"请输入建设单位名称(不超过100)",@"请输入建设单位地址(不超过100)",@"请输入建设单位联系人(不超过10)",@"请输入建设单位联系电话(11位)", nil] ;
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 10, Width, Height-64-100)];
    _tableview.backgroundColor=[UIColor whiteColor];
    _tableview.opaque=YES;
    _tableview.tableFooterView=[[UIView alloc]init];
    _tableview.rowHeight=50;
//    _tableview.estimatedRowHeight=44;
//    _tableview.rowHeight=UITableViewAutomaticDimension;
    [_tableview registerClass:[HZRegistCell class] forCellReuseIdentifier:@"cell"];
    _tableview.showsVerticalScrollIndicator=NO;
    _tableview.showsHorizontalScrollIndicator=NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableview.dataSource=self;
    _tableview.delegate=self;
    [self.view addSubview:_tableview];
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(20,Height-64-80, Width-40, 45)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=10;
    [commit setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:commit];
}
//MARK:注册
-(void)commit{
    UITextView *textfield1=[self.view viewWithTag:10];
    UITextView *textfield2=[self.view viewWithTag:11];
    UITextView *textfield3=[self.view viewWithTag:12];
    UITextView *textfield4=[self.view viewWithTag:13];
    UITextView *textfield5=[self.view viewWithTag:14];
    UITextView *textfield6=[self.view viewWithTag:15];
     UITextView *textfield7=[self.view viewWithTag:16];
     UITextView *textfield8=[self.view viewWithTag:17];
    UITextView *textfield9=[self.view viewWithTag:18];
    NSLog(@"textfield1.text  %@  %d   textfield2.text  %@ textfield3.text  %@  textfield4.text  %@   textfield5.text  %@   textfield6.text  %@  textfield7.text  %@  textfield8.text  %@ ",textfield1.text,[textfield1.text length],textfield2.text,textfield3.text,textfield4.text,textfield5.text,textfield6.text,textfield7.text,textfield8.text);
    if (textfield1.text==NULL||textfield2.text==NULL||textfield3.text==NULL||textfield4.text==NULL||textfield5.text==NULL||textfield6.text==NULL||textfield7.text==NULL||textfield8.text==NULL||textfield9.text==NULL) {
        [self.view makeToast:@"请填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }
    if ([BSRegexValidate validatePassWord:textfield1.text]==NO) {
        [self.view makeToast:@"账号请按要求填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }else if ([textfield2.text length]<1||[textfield2.text length]>11) {
        [self.view makeToast:@"用户名请按要求填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }else if ([BSRegexValidate validatePassWord:textfield3.text]==NO) {
        [self.view makeToast:@"密码请按要求填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }else if ([BSRegexValidate validateTelephone:textfield4.text]==NO) {
        [self.view makeToast:@"联系方式请按要求填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }
   
    if ([textfield9.text length]<3||[textfield9.text length]>15) {
        [self.view makeToast:@"建设单位联系电话请按要求填写完整" duration:2 position:CSToastPositionCenter];
        return;
    }
        MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text=@"加载中，请稍候...";
    [HZLoginService RegistWithUserName:textfield2.text userid:textfield1.text passwd:textfield3.text phone:textfield4.text position:textfield5.text companyname:textfield6.text companyaddress:textfield7.text companyperson:textfield8.text companyphone:textfield9.text andBlock:^(NSDictionary *returnDic, NSError *error) {
        [hud hideAnimated:YES];
        if ([[returnDic objectForKey:@"code"]integerValue]==0) {
            [self.view makeToast:[returnDic objectForKey:@"desc"] duration:2 position:CSToastPositionCenter];
            HZLoginViewController *login=[[HZLoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }else{
            [self.view makeToast:[returnDic objectForKey:@"desc"] duration:2 position:CSToastPositionCenter];
        }
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfRows;
   
    switch (section) {
        case 0:
            numOfRows= 5;
            break;
        case 1:
            numOfRows= 4;
            break;
        default:
            numOfRows=0;
            break;
    }
    return numOfRows;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    HZRegistCell *cell=[tableView cellForRowAtIndexPath:indexPath];
//    return cell.textview.frame.size.height+20;
//}
-(HZRegistCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HZRegistCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[HZRegistCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.titleLabel.text=[_titleArray objectAtIndex:indexPath.section*5+indexPath.row];
    cell.textview.delegate=self;
    cell.textview.placeholder=[_placeArray objectAtIndex:indexPath.section*5+indexPath.row];
    cell.textview.tag=10+indexPath.section*5+indexPath.row;
//    [self tableView:_tableview heightForRowAtIndexPath:indexPath];
       return cell;
}
#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    UITextView *textfield1=[self.view viewWithTag:10];
    UITextView *textfield2=[self.view viewWithTag:11];
    UITextView *textfield3=[self.view viewWithTag:12];
    UITextView *textfield4=[self.view viewWithTag:13];
    UITextView *textfield5=[self.view viewWithTag:14];
    UITextView *textfield6=[self.view viewWithTag:15];
    UITextView *textfield7=[self.view viewWithTag:16];
    UITextView *textfield8=[self.view viewWithTag:17];
    UITextView *textfield9=[self.view viewWithTag:18];
    if ([textView isEqual:textfield7]) {
        _tableview.contentOffset=CGPointMake(0, 60);
    }else if ([textView isEqual:textfield8]||[textView isEqual:textfield9]){
        _tableview.contentOffset=CGPointMake(0, 160);
    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    _tableview.contentOffset=CGPointMake(0, 0);
     [self.view endEditing:YES];
}
-(void)textViewDidChange:(UITextView *)textView {
    //获得textView的初始尺寸
    CGFloat width = CGRectGetWidth(textView.frame);
    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    textView.frame= newFrame;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
