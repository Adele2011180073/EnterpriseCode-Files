
//
//  HZPersonalViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/9.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZPersonalViewController.h"
#import "HZChangePwViewController.h"
#import "UIView+Toast.h"
#import "HZLoginViewController.h"

@interface HZPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSDictionary *responseData;
    UITableView *tableview;
}
@end

@implementation HZPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title=@"个人中心";
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height/5)];
    topView.backgroundColor=[UIColor colorWithRed:24/255.0 green:180/255.0 blue:237/255.0 alpha:1];
    [self.view addSubview:topView];
    
    UIImageView *userPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(Width/2-30, Height/10-40, 60, 60)];
    userPhotoView.image=[UIImage imageNamed:@"icon"];
    [topView addSubview:userPhotoView];
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"info"];
    NSDictionary *info=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(0, Height/5-40, Width, 20)];
    NSDictionary *obj=[info objectForKey:@"obj"];
    responseData=obj;
    username.text =[NSString stringWithFormat:@"欢迎您，%@",[obj objectForKey:@"name"]];
    username.textColor=[UIColor whiteColor];
    username.textAlignment=NSTextAlignmentCenter;
    username.font=[UIFont systemFontOfSize:16];
    [topView addSubview:username];
    
   
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, Height/5+10, Width, Height-54-Height/5)];
    tableview.opaque=YES;
    tableview.rowHeight=45;
    tableview.tableFooterView=[[UIView alloc]init];
    tableview.showsVerticalScrollIndicator=NO;
    tableview.showsHorizontalScrollIndicator=NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
   }
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfRows;
    switch (section) {
        case 0:
            numOfRows= 1;
            break;
        case 1:
            numOfRows= 2;
            break;
        case 2:
            numOfRows= 4;
            break;
            
               default:
            break;
    }
    return numOfRows;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor=[UIColor colorWithRed:251/255. green:251/255. blue:254/255. alpha:1.];
    NSArray *imageArray=@[@"\U0000e627",@"\U0000e656",@"\U0000e641",@"\U0000e63f",@"\U0000e683",@"\U0000e664",@"\U0000e653"];
    NSArray *titleArray=@[@"部门",@"职位",@"密码修改",@"缓存清理",@"系统版本",@"注销"];
    UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    imageTitle.textColor=blueCyan;
    imageTitle.font=[UIFont fontWithName:@"iconfont" size:28];
    if (indexPath.section==2) {
        imageTitle.text=[imageArray objectAtIndex:indexPath.section+ indexPath.row+1];
    }else{
        imageTitle.text=[imageArray objectAtIndex:indexPath.section+ indexPath.row];
    }
    imageTitle.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:imageTitle];
    if (indexPath.section==0) {
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(50, 13, Width-80, 20)];
        title.textColor=[UIColor blackColor];
        title.font=[UIFont systemFontOfSize:16];
        title.text=[[responseData objectForKey:@"dbAConstructionunit"]objectForKey:@"name"];
        title.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:title];
    }else{
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(50, 13, 100, 20)];
        title.textColor=[UIColor blackColor];
        title.font=[UIFont systemFontOfSize:16];
        if (indexPath.section==2) {
            title.text=[titleArray objectAtIndex:indexPath.row+2];
        }else{
             title.text=[titleArray objectAtIndex:indexPath.row];
        }
        title.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:title];
    }
   
    UILabel *subTitle=[[UILabel alloc]initWithFrame:CGRectMake(Width-80, 13, 80, 20)];
    subTitle.textColor=[UIColor grayColor];
    if (indexPath.section==1&&indexPath.row==0) {
         subTitle.text=[[responseData objectForKey:@"dbADepartment"]objectForKey:@"name"];
    }else if (indexPath.section==1&&indexPath.row==1){
        subTitle.text=[responseData objectForKey:@"position"];
    }else if (indexPath.section==2&&indexPath.row==1){
       subTitle.text=[NSString stringWithFormat:@"%.1fM",[self filePath]];
    }else if (indexPath.section==2&&indexPath.row==2){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用软件版本  比如：1.0.1
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        subTitle.text=[NSString stringWithFormat:@"%@",appCurVersion];
    }
    subTitle.font=[UIFont systemFontOfSize:15];
    subTitle.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:subTitle];
    return cell;
}
// 显示缓存大小
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.section==2&&indexPath.row==0){
       HZChangePwViewController *pw=[[HZChangePwViewController alloc]init];
       [self.navigationController pushViewController:pw animated:YES];
    }else if (indexPath.section==2&&indexPath.row==1){
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您确定要清除数据吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [self clearCachePressed:nil];
        }];
        [alert addAction:okAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
      
    }
    else if (indexPath.section==2&&indexPath.row==3){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passwd"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"remember"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您确定要注销用户吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            HZLoginViewController *pw=[[HZLoginViewController alloc]init];
            [self.navigationController pushViewController:pw animated:YES];
        }];
        [alert addAction:okAlert];
//        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)clearCachePressed:(id)sender
{
    NSString *str = [NSString stringWithFormat:@"缓存已清除%.1fM", [self filePath]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除完成！"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
}
-(void)clearCachSuccess
{
    NSLog ( @" 清理成功 " );
    NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:2];//刷新
    [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
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
