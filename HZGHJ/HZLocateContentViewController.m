//
//  HZLocateContentViewController.m
//  HZGHJ
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZLocateContentViewController.h"
#import "HZIllustrateViewController.h"
#import "HZZaiXianTianXieViewController.h"
#import "HZYangBiaoViewController.h"
#import "HZPictureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HZMapServiceViewController.h"

@interface HZLocateContentViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UITextFieldDelegate>{
    UIButton *_rightBarBtn;
     UIScrollView *_mainBgView;//整个scrollview
    UIScrollView *_mainListView;//网格scrollview
    NSMutableArray * _imageAllArray;//所有图片数组
    UITextField *_textfield;

}

@end

@implementation HZLocateContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title=@"申报材料";
    
    _rightBarBtn = [[UIButton alloc] initWithFrame                                                                      :CGRectMake(15, 5, 80, 20)];
    [_rightBarBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBarBtn addTarget:self action:@selector(illustrate) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarBtn setTitle:@"填表说明" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    _imageAllArray=[[NSMutableArray alloc]init];
    for (int i=0; i<8; i++) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [_imageAllArray addObject:array];
    }
    _mainBgView=[[UIScrollView alloc]init];
    _mainBgView.frame=CGRectMake(0, 0, Width, Height-44);
    _mainBgView.contentSize=CGSizeMake(Width, 1360);
    _mainBgView.userInteractionEnabled=YES;
    [self.view addSubview:_mainBgView];
    _mainListView=[[UIScrollView alloc]init];
    _mainListView.frame=CGRectMake(5, 10, Width-10,1280);
//     _mainBgView.contentSize=CGSizeMake(520-6, 1350);
    _mainListView.userInteractionEnabled=YES;
    [_mainBgView addSubview:_mainListView];
    [self addMainListView];
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(20,1200, Width-40, 45)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=10;
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [_mainBgView addSubview:commit];

}
//MARK:绘制主表格视图
-(void)addMainListView{
    NSArray *nameLabelaArray=@[@"材料名称",@"《建设项目选址意见书申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对",@"委托身份证明（须提供原件核对",@"项目建议书批复（启用审批新流程项目可用发改项目收件单及项目建议书文本、电子文件）或项目备案文件（须提供原件核对）",@"拟建位置1/1000带规划控制线地形图1份",@"有效土地权属证明（须提供原件核对",@"选址论证报告批复文件及报告文本（成果稿）、电子光盘"];
     NSArray *statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要"];
    for (int i=0; i<9; i++) {
        UIView *nameLabelView1=[[UIView alloc]initWithFrame:CGRectMake(0, 60+120*(i-1),160, 120)];
        nameLabelView1.userInteractionEnabled=YES;
        nameLabelView1.layer.borderColor=blueCyan.CGColor;
        nameLabelView1.layer.borderWidth=1;
        [_mainListView addSubview:nameLabelView1];
        UIView *statusLabelView2=[[UIView alloc]initWithFrame:CGRectMake(160, 60+120*(i-1), 50, 120)];
        statusLabelView2.userInteractionEnabled=YES;
        statusLabelView2.layer.borderColor=blueCyan.CGColor;
        statusLabelView2.layer.borderWidth=1;
        [_mainListView addSubview:statusLabelView2];
        UIScrollView *contentView3=[[UIScrollView alloc]initWithFrame:CGRectMake(210, 60+120*(i-1), Width-10-210, 120)];
        contentView3.tag=1+i;
        contentView3.userInteractionEnabled=YES;
        contentView3.layer.borderColor=blueCyan.CGColor;
        contentView3.layer.borderWidth=1;
        [_mainListView addSubview:contentView3];
       
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, 160, 90)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.numberOfLines=10;
        label1.font=[UIFont systemFontOfSize:15];
        label1.text=[nameLabelaArray objectAtIndex:i];
        [nameLabelView1  addSubview:label1];
        UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, 50, 80)];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.numberOfLines=2;
        label2.font=[UIFont systemFontOfSize:15];
        label2.text=[statusLabelArray objectAtIndex:i];
        [statusLabelView2  addSubview:label2];
        
        if (i==0) {
            nameLabelView1.frame=CGRectMake(0, 0,160, 60);
            statusLabelView2.frame=CGRectMake(160, 0,50, 60);
            contentView3.frame=CGRectMake(210, 0,Width-220, 60);
            label1.frame=CGRectMake(0,  0, 160, 60);
            label2.frame=CGRectMake(0,  0, 50, 60);
            UILabel  *label3=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, Width-220, 60)];
            label3.textAlignment=NSTextAlignmentCenter;
            label3.font=[UIFont systemFontOfSize:15];
            label3.text=@"操作";
            [contentView3  addSubview:label3];
        }
        if (i==5||i==6) {
            nameLabelView1.frame=CGRectMake(0, 540+150*(i-5),160, 150);
            statusLabelView2.frame=CGRectMake(160, 540+150*(i-5),50, 150);
            contentView3.frame=CGRectMake(210, 540+150*(i-5),Width-220, 150);
            label1.frame=CGRectMake(0,  0, 160, 120);
            label2.frame=CGRectMake(0,  0, 50, 150);
            if (i==5) {
                _textfield=[[UITextField alloc]initWithFrame:CGRectMake(5, 5, Width-230, 30)];
                _textfield.layer.borderColor=blueCyan.CGColor;
                _textfield.layer.borderWidth=1;
                _textfield.placeholder=@"受理号或控规地块";
                _textfield.delegate=self;
                _textfield.font=[UIFont systemFontOfSize:15];
                [contentView3 addSubview:_textfield];
                UILabel  *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,  40, Width-230, 30)];
                contentLabel.textAlignment=NSTextAlignmentLeft;
                contentLabel.font=[UIFont systemFontOfSize:15];
                contentLabel.text=@"控规地块拍照：";
                [contentView3  addSubview:contentLabel];
                
                UIButton *mapBtn=[[UIButton alloc]initWithFrame:CGRectMake(10,115, 30, 30)];
                [mapBtn addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
                mapBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:32];
                [mapBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [mapBtn setTitle:@"\U0000e620" forState:UIControlStateNormal];
                [contentView3 addSubview:mapBtn];
            }
        }else if (i==7||i==8){
            nameLabelView1.frame=CGRectMake(0, 120+120*(i-1),160, 120);
            statusLabelView2.frame=CGRectMake(160, 120+120*(i-1),50, 120);
            contentView3.frame=CGRectMake(210, 120+120*(i-1),Width-220, 120);
            label1.frame=CGRectMake(0,  0, 160, 90);
            label2.frame=CGRectMake(0,  0, 50, 120);
        }
        if (i>0&&i<7) {
            UIButton *yangbiao=[[UIButton alloc]initWithFrame:CGRectMake(160-60,90, 60, 30)];
            [yangbiao addTarget:self action:@selector(yangbiao:) forControlEvents:UIControlEventTouchUpInside];
            yangbiao.backgroundColor=[UIColor whiteColor];
            yangbiao.layer.borderColor=blueCyan.CGColor;
            yangbiao.layer.borderWidth=1;
            yangbiao.tag=100+i;
            if (i==5||i==6) {
                yangbiao.frame=CGRectMake(160-60,120, 60, 30);
            }
            yangbiao.titleLabel.font=[UIFont systemFontOfSize:15];
            [yangbiao setTitleColor:blueCyan forState:UIControlStateNormal];
            [yangbiao setTitle:@"样表" forState:UIControlStateNormal];
            [nameLabelView1 addSubview:yangbiao];
        }
        if (i==1) {
            UIButton *zaixiantianxie=[[UIButton alloc]initWithFrame:CGRectMake(0,90, 80, 30)];
            [zaixiantianxie addTarget:self action:@selector(zaixiantianxie:) forControlEvents:UIControlEventTouchUpInside];
            zaixiantianxie.backgroundColor=[UIColor whiteColor];
            zaixiantianxie.layer.borderColor=blueCyan.CGColor;
            zaixiantianxie.layer.borderWidth=1;
            zaixiantianxie.titleLabel.font=[UIFont systemFontOfSize:15];
            [zaixiantianxie setTitleColor:blueCyan forState:UIControlStateNormal];
            [zaixiantianxie setTitle:@"在线填写" forState:UIControlStateNormal];
            [nameLabelView1 addSubview:zaixiantianxie];
        }
        if (i>0) {
            UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,40, 40, 40)];
            if (i==5) {
                imageBtn.frame=CGRectMake(0,70, 40, 40);
            }
            imageBtn.tag=200+i;
            [imageBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
            imageBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:42];
            [imageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [imageBtn setTitle:@"\U0000e652" forState:UIControlStateNormal];
            [contentView3 addSubview:imageBtn];
        }
        
    }
    
    
}
//MARK:样表
-(void)yangbiao:(UIButton*)sender{
    HZYangBiaoViewController *yangbiao=[[HZYangBiaoViewController alloc]init];
    [self.navigationController pushViewController:yangbiao animated:YES];
}
//MARK:在线填写
-(void)zaixiantianxie:(UIButton*)sender{
    HZZaiXianTianXieViewController *tianxie=[[HZZaiXianTianXieViewController alloc]init];
    [self.navigationController pushViewController:tianxie animated:YES];
}
//MARK:调取相机
-(void)takePhoto:(UIButton *)sender{
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请到设置-通用中允许使用相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"添加照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAlert];
    UIAlertAction *cameraAlert=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.accessibilityValue=[NSString stringWithFormat:@"%d",sender.tag];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
        //        picker.videoQuality=UIImagePickerControllerQualityTypeLow;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:Nil];
    }];
    [alert addAction:cameraAlert];
    UIAlertAction *pictureAlert=[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController*picker = [[UIImagePickerController alloc] init];
        //         picker.videoQuality=UIImagePickerControllerQualityTypeLow;
        picker.delegate = self;
        picker.accessibilityValue=[NSString stringWithFormat:@"%d",sender.tag];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:Nil];
    }];
    [alert addAction:pictureAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Get Photoes Module
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData=UIImageJPEGRepresentation(originImage, 1);
//    float length=[imageData length]/1024;
//    NSLog(@"图片大小   %f  M",length);
    UIImage *scaleImage = [self imageWithImage:originImage scaledToSize:CGSizeMake(320*1.5, 480*1.5)];
    NSData *scaleImageData=UIImagePNGRepresentation(scaleImage);
    
//    float length1=[scaleImageData length]/1024;
//    NSLog(@"图片大小1   %f  M",length1);
//    [self.imageArray addObject:scaleImage]
    int imageBtnNum=[picker.accessibilityValue intValue];
    //限制只能拍三张
    if (imageBtnNum==201) {
        UIScrollView *bgview=[self.view viewWithTag:2];
        bgview.contentSize=CGSizeMake(220, 120);
        NSMutableArray *imageArray=[_imageAllArray objectAtIndex:0];
        [imageArray addObject:scaleImage];
        UIButton *imageButton=[self.view viewWithTag:201];
            imageButton.frame=CGRectMake(10+70*imageArray.count, imageButton.frame.origin.y, 60, 60);
            for (int i=0; i<imageArray.count; i++) {
                UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(10+70*i,30, 60, 60)];
                imageBtn.tag=10+i;
                [imageBtn addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
                [imageBtn setBackgroundImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
                [bgview addSubview:imageBtn];
            }
        if (imageArray.count==3) {
            [imageButton removeFromSuperview];
        }

    }else if (imageBtnNum==206){
        NSMutableArray *imageArray=[_imageAllArray objectAtIndex:5];
        [imageArray addObject:scaleImage];
        UIScrollView *bgview=[self.view viewWithTag:7];
        bgview.contentSize=CGSizeMake(50*imageArray.count+80, 150);
        UIButton *imageButton=[self.view viewWithTag:206];
        imageButton.frame=CGRectMake(10+50*imageArray.count, imageButton.frame.origin.y, 40, 40);
        for (int i=0; i<imageArray.count; i++) {
            UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(10+50*i, imageButton.frame.origin.y, 40, 40)];
            imageBtn.tag=60+i;
            [imageBtn addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [imageBtn setBackgroundImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
            [bgview addSubview:imageBtn];
        }
        if (imageArray.count==10) {
            [imageButton removeFromSuperview];
        }

        
    }else{
        NSMutableArray *imageArray=[_imageAllArray objectAtIndex:imageBtnNum-201];
        [imageArray addObject:scaleImage];
        UIScrollView *bgview=[self.view viewWithTag:imageBtnNum-199];
        bgview.contentSize=CGSizeMake(60*5+20, 150);
        UIButton *imageButton=[self.view viewWithTag:imageBtnNum];
        imageButton.frame=CGRectMake(10+60*(imageArray.count%5), 5+55*(imageArray.count/5), 50, 50);
        for (int i=0; i<imageArray.count; i++) {
            UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(10+60*(i%5), 5+i/5, 50, 50)];
            imageBtn.tag=(imageBtnNum-200)*10+i;
            [imageBtn addTarget:self action:@selector(bigPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [imageBtn setBackgroundImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
            [bgview addSubview:imageBtn];
        }
        if (imageArray.count==10) {
            [imageButton removeFromSuperview];
        }

    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [self addSubviews];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//MARK:扩大图片
-(void)bigPhoto:(UIButton*)bigImage{
    HZPictureViewController *picture=[[HZPictureViewController alloc]init];
    picture.isWeb=YES;
    NSMutableArray *imageArray=[_imageAllArray objectAtIndex:bigImage.tag/10-1];
    picture.imageArray=imageArray;
    picture.image=bigImage.currentBackgroundImage;
    NSInteger index=[imageArray indexOfObject:picture.image];
    picture.indexOfImage=index;
    [self.navigationController pushViewController:picture animated:YES];
}

-(void)map:(UIButton*)sender{
    HZMapServiceViewController *illustrate=[[HZMapServiceViewController alloc]init];
    [self.navigationController pushViewController:illustrate animated:YES];
}
//MARK:提交
-(void)commit{
  
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self.view endEditing:YES];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)illustrate{
    HZIllustrateViewController *illustrate=[[HZIllustrateViewController alloc]init];
    [self.navigationController pushViewController:illustrate animated:YES];
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
