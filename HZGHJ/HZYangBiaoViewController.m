//
//  HZYangBiaoViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/7/4.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZYangBiaoViewController.h"

@interface HZYangBiaoViewController ()<UIGestureRecognizerDelegate>{
    //定义一个缩放手势，用来对视图可以进行放大或者缩小
    //Pinch:捏合手势
    UIPinchGestureRecognizer * _pinchGes;
    
    //定义一个旋转手势，主要用来旋转图像视图
    UIRotationGestureRecognizer * _rotGes;
    
}

@end

@implementation HZYangBiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title=@"样表";
    self.view.backgroundColor=[UIColor blackColor];

    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30,40, Width-60, Height-44-140)];
    //开启交互功能
    imageView.userInteractionEnabled=YES;
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.image=[UIImage imageNamed:@"slh_yb.jpg"];
    [self.view addSubview:imageView];
    //创建一个捏合手势
    //p1:事件对象的拥有者
    //p2:事件响应函数
    _pinchGes =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAct:)];
    
    //将捏合手势添加到视图中
    [imageView addGestureRecognizer:_pinchGes];
    
    
    //创建旋转手势
    _rotGes =[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotAct:)];
    
    [imageView addGestureRecognizer:_rotGes];
    
    //设置手势的代理
    _rotGes.delegate=self;
    _pinchGes.delegate=self;
}

//是否可以同时相应两个手势
//如果返回值为YES:可以同时相应
//如果返回值为NO:不可以同时相应
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//旋转手势函数
-(void)rotAct:(UIRotationGestureRecognizer*)rot{
    UIImageView* iView = (UIImageView*)rot.view;
    //计算旋转的变换矩阵并且赋值
    iView.transform = CGAffineTransformRotate(iView.transform,rot.rotation);
    //选择角度清零
    rot.rotation=0;
}

//捏合手势事件函数实现
-(void)pinchAct:(UIPinchGestureRecognizer*)pinch{
    //获取监控图像视图
    UIImageView * iView =(UIImageView*)pinch.view;
    //对图像视图对象进行矩阵变换计算并赋值
    //transform：表示图形学中的变换矩阵
    //CGAffineTransformScale：通过缩放的方式产生一个新矩阵
    //参数一：原来的矩阵
    //参数二：x方向的缩放比例
    //参数三：y方向的缩放比例
    //返回值是新的缩放后的矩阵变换
    iView.transform = CGAffineTransformScale(iView.transform, pinch.scale, pinch.scale);
    
    //将缩放值归位为单位值
    //scale=1:原来的大小
    //scale<1:缩小效果
    //scale>1:放大效果
    pinch.scale=1;
    
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
