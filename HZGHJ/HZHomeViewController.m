//
//  HZHomeViewController.m
//  HZGHJ
//
//  Created by zhang on 16/12/6.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZHomeViewController.h"
#import "HZURL.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"


@interface HZHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *collectionview;
    NSMutableArray *dataSourceArray;
    
}


@end 

@implementation HZHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationController                                                                                                                                                                                                                                                                                                                                                                                         .navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bgg.png"] forBarMetrics:UIBarMetricsDefault];

    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.userName.text=[NSString stringWithFormat:@"欢迎您，%@",[[self.dic objectForKey:@"obj"]objectForKey:@"name"]];
     [self getDataSource];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0,self.noticeView.frame.origin.y+self.noticeView.frame.size.height+30, Width, Height-(self.noticeView.frame.origin.y+self.noticeView.frame.size.height+30)) collectionViewLayout:layout];
    [collectionview registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    collectionview.backgroundColor=[UIColor whiteColor];
    collectionview.dataSource=self;
    collectionview.delegate=self;
    collectionview.showsVerticalScrollIndicator=NO;
    collectionview.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:collectionview];
}
-(void)getDataSource{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BottomMenuItems1" ofType:@"plist"];
     NSArray* dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    dataSourceArray=[NSMutableArray arrayWithArray:dataArray];
    
//    NSLog(@"datasourcearray   %@",dataSourceArray);
    
    [collectionview reloadData];

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSourceArray.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionview registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    CollectionViewCell*cell=(CollectionViewCell *)[collectionview dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic=[dataSourceArray objectAtIndex:indexPath.row];
        cell.titleLabel.text=[dic objectForKey:@"title"];
    cell.image.image=[UIImage imageNamed:[dic objectForKey:@"image"]];
//    NSLog(@"cell  %@   %@",[dic objectForKey:@"image"],[dic objectForKey:@"title"]);
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    return CGSizeMake(Width/3.5, Height/8+60);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, Width/6-Width/7, 0,Width/6-Width/7);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=[dataSourceArray objectAtIndex:indexPath.row];
//    NSLog(@"smalldic    %@",dic);
    if ([[dic objectForKey:@"controller"]isEqualToString:@""]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }];
        [alert addAction:okAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    Class clazz = NSClassFromString([dic objectForKey:@"controller"]);
    if (!clazz) clazz = NSClassFromString([dic objectForKey:@"controller"]);
    UIViewController *controller = nil;
    controller = [[clazz alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
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
