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
#import "MBProgressHUD.h"
#import "HZBanShiService.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIView+Toast.h"

@interface HZLocateContentViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate,UITextFieldDelegate>{
    UIButton *_rightBarBtn;
     UIScrollView *_mainBgView;//整个scrollview
    UIScrollView *_mainListView;//网格scrollview
    NSMutableArray * _imageAllArray;//所有图片数组
    UITextField *_textfield;
    NSMutableArray*_imageNameArray;
    NSMutableArray*_imageCommitArray;//提交上传图片数组
    NSMutableArray *_MATERArray;
    UIImagePickerController* _picker;
}

@end

@implementation HZLocateContentViewController
@synthesize PCODE;
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
    
    _mainBgView=[[UIScrollView alloc]init];
    _mainBgView.frame=CGRectMake(0, 0, Width, Height-44);
    _mainBgView.contentSize=CGSizeMake(Width, 1280);
    _mainBgView.userInteractionEnabled=YES;
    [self.view addSubview:_mainBgView];
    _mainListView=[[UIScrollView alloc]init];
    _mainListView.frame=CGRectMake(5, 10, Width-10,1260);
//     _mainBgView.contentSize=CGSizeMake(520-6, 1350);
    _mainListView.userInteractionEnabled=YES;
    [_mainBgView addSubview:_mainListView];
    
    [self getImageNameArray];
    
    UIButton *commit=[[UIButton alloc]initWithFrame:CGRectMake(20,1120, Width-40, 45)];
    [commit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commit.backgroundColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1];
    commit.clipsToBounds=YES;
    commit.layer.cornerRadius=10;
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [_mainBgView addSubview:commit];
    NSInteger num;
     num=8;
    if (PCODE==4){
        _mainBgView.contentSize=CGSizeMake(Width, 1500);
        _mainListView.frame=CGRectMake(5, 10, Width-10,1490);
        commit.frame=CGRectMake(20,1350, Width-40, 45);
        num=9;
    }else if (PCODE==5){
        _mainBgView.contentSize=CGSizeMake(Width, 1650);
        _mainListView.frame=CGRectMake(5, 10, Width-10,1570);
        commit.frame=CGRectMake(20,1490, Width-40, 45);
        num=10;
    }else if (PCODE==6||PCODE==7){
        _mainBgView.contentSize=CGSizeMake(Width, 1520);
        _mainListView.frame=CGRectMake(5, 10, Width-10,1480);
        commit.frame=CGRectMake(20,1360, Width-40, 45);
        num=9;
    }
    
    _imageCommitArray=[[NSMutableArray alloc]init];
    _imageNameArray=[[NSMutableArray alloc]init];
    _imageAllArray=[[NSMutableArray alloc]init];
    for (int i=0; i<num; i++) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [_imageAllArray addObject:array];
        
    }

    
    [self addMainListView];

}
//获取图片名
-(void)getImageNameArray{
    NSArray *array1=[[NSArray alloc]initWithObjects:@"CC23D9E6DF1F431588CB61FC2C46A808",@"EABB51B0F6BC4E549F8A16F2565E3F02",@"EABB51B0F6BC4E549F8A16F2565E3F02",@"EABB51B0F6BC4E549F8A16F2565E3F02",@"994491EC29784BD0AA0C5FBDBB5A91FC",@"11F995DF0DDA47EA82E76E75C6D5423D",@"62D10DD3F5F1493BA39F80AF272A5C19",@"A126BD364D77479DB4C5C4DE11683078", nil];
        NSArray *array2=[[NSArray alloc]initWithObjects:@"171A82814CC34B6AA2125303A9BAE81C",@"DC5AB54D37D847208AD4E7652A26DEC6",@"DC5AB54D37D847208AD4E7652A26DEC6",@"DC5AB54D37D847208AD4E7652A26DEC6",@"AF0FFA6881CA416DB4FA36735C0E8BE0",@"3A762AA2B9B644A7BDECE2F0EEA1B2DB",@"562B56FDE73A4BDDA493B8DE5970F31E",@"EC6CE19DA8EB46C48250132AF40306C3",@"A9C26C85E9C24539952CAA3383754B0C", nil];
      NSArray *array3=[[NSArray alloc]initWithObjects:@"171A82814CC34B6AA2125303A9BAE81C",@"DC5AB54D37D847208AD4E7652A26DEC6",@"DC5AB54D37D847208AD4E7652A26DEC6",@"DC5AB54D37D847208AD4E7652A26DEC6",@"AF0FFA6881CA416DB4FA36735C0E8BE0",@"3A762AA2B9B644A7BDECE2F0EEA1B2DB",@"0DFE90E72D32479285864CA36E4F86F0",@"562B56FDE73A4BDDA493B8DE5970F31E",@"EC6CE19DA8EB46C48250132AF40306C3",@"A9C26C85E9C24539952CAA3383754B0C", nil];
    NSArray *array4=[[NSArray alloc]initWithObjects:@"1736932C8C0C44D9AF9D72B1BA411832",@"8401F317CEA1453597D93FFD23BD3BCB",@"8401F317CEA1453597D93FFD23BD3BCB",@"8401F317CEA1453597D93FFD23BD3BCB",@"A362794986CE464B9FC37834EB49750D",@"0E66C235BE6D4C1D8DA568947ED447AC",@"734BA930F91B4E8A8AD08717BAE8B6E8",@"9D5325FD6D59484F997897085B9F0675",@"3783734074F94D21BA4DD7010C427290", nil];

    _MATERArray=[[NSMutableArray alloc]init];
    if (PCODE<4) {
        [_MATERArray addObjectsFromArray:array1];
    }else if (PCODE==4){
        [_MATERArray addObjectsFromArray:array2];
    }else if (PCODE==5){
        [_MATERArray addObjectsFromArray:array3];
    }else if (PCODE==6||PCODE==7){
        [_MATERArray addObjectsFromArray:array4];
    }
    
}
//MARK:绘制主表格视图
-(void)addMainListView{
    NSArray *nameLabelaArray=nil;
     NSArray *statusLabelArray=nil;
    if (PCODE<2) {
        nameLabelaArray=@[@"材料名称",@"《建设项目选址意见书申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对",@"委托身份证明（须提供原件核对",@"项目建议书批复（启用审批新流程项目可用发改项目收件单及项目建议书文本、电子文件）或项目备案文件（须提供原件核对）",@"拟建位置1/1000带规划控制线地形图1份",@"有效土地权属证明（须提供原件核对",@"选址论证报告批复文件及报告文本（成果稿）、电子光盘"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要"];
    }else  if (PCODE==2||PCODE==3) {
        nameLabelaArray=@[@"材料名称",@"《建设项目批后修改(延期)事项申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对)",@"委托身份证明（须提供原件核对)",@"项目建议书批复（启用审批新流程项目可用发改项目收件单及项目建议书文本、电子文件）或项目备案文件（须提供原件核对）",@"拟建位置1/1000带规划控制线地形图1份",@"有效土地权属证明（须提供原件核对",@"选址论证报告批复文件及报告文本（成果稿）、电子光盘"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要",@"非必要"];
    }  else if (PCODE==4){
        nameLabelaArray=@[@"材料名称",@"《建设用地规划许可证申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对)",@"委托身份证明（须提供原件核对)",@"项目批准、核准或备案文件（批准文件为发改部门的可行性研究报告批复）",@"拟建位置1/1000带规划控制线地形图1份",@"出让土地项目提供土地出让合同（须提供原件核对）、勘测定界成果",@"划拔土地项目提供建设项目选址意见书（包括附图）复印件、国土部门用地预审意见（须提供原件核对）及勘测定界成果，涉及使用集体土地项目同步出具属地村民委员会书面同意意见(不含征收集体土地项目)",@"涉及受让主体变更的需提供主体变更材料"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要（出让土地项目提供）",@"非必要（划拨土地项目提供）",@"非必要(只针对申请变更的项目)"];
    } else if (PCODE==5){
        nameLabelaArray=@[@"材料名称",@"《建设用地规划许可证申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对)",@"委托身份证明（须提供原件核对)",@"项目批准、核准或备案文件（批准文件为发改部门的可行性研究报告批复）",@"拟建位置1/1000带规划控制线地形图1份",@"申请临时建设用地规划许可证需提供因建设项目施工或者地质勘查需要临时使用土地的有关证明文件",@"出让土地项目提供土地出让合同（须提供原件核对）、勘测定界成果",@"划拔土地项目提供建设项目选址意见书（包括附图）复印件、国土部门用地预审意见（须提供原件核对）及勘测定界成果，涉及使用集体土地项目同步出具属地村民委员会书面同意意见(不含征收集体土地项目)",@"涉及受让主体变更的需提供主体变更材料"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要（申请临时建设用地规划许可提供)",@"非必要（出让土地项目提供）",@"非必要（划拨土地项目提供）",@"非必要(只针对申请变更的项目)"];
    }else if (PCODE==6||PCODE==7){
        nameLabelaArray=@[@"材料名称",@"《建设项目规划条件申请表》",@"工商营业执照或组织机构代码证复印件（加盖单位公章）",@"授权委托书（须提供原件核对",@"委托身份证明（须提供原件核对)",@"项目批准、核准、备案文件、服务联系单、项目建议书批复或储备土地出让前期计划文件(须提供原件核对)",@"拟建位置1/1000带规划控制线地形图1份",@"选址论证报告批复文件及报告文本（成果稿）、电子光盘(要求编制选址论址报告的项目提供)",@"自有用地项目提供有效土地权属证明、房产权属证明（须提供原件核对）及原规划批准文件（视不同情况提供，须提供原件核对)",@"涉及外立面装修类项目不需立项，但须提供房产权属证明、土地权属证明及彩色现状照片、供参考的彩色实景效果图1份"];
        statusLabelArray=@[@"必要性",@"必要",@"必要",@"必要",@"必要",@"必要",@"必要",@"非必要(要求编制选址论证报告的项目)",@"非必要(自有用地项目提供)",@"非必要(针对立面装修项目)"];
    }
    for (int i=0; i<statusLabelArray.count; i++) {
        UIView *nameLabelView1=[[UIView alloc]initWithFrame:CGRectMake(0, 60+120*(i-1),160, 120)];
        nameLabelView1.userInteractionEnabled=YES;
        nameLabelView1.layer.borderColor=blueCyan.CGColor;
        nameLabelView1.layer.borderWidth=0.5;
        [_mainListView addSubview:nameLabelView1];
        UIView *statusLabelView2=[[UIView alloc]initWithFrame:CGRectMake(160, 60+120*(i-1), 50, 120)];
        statusLabelView2.userInteractionEnabled=YES;
        statusLabelView2.layer.borderColor=blueCyan.CGColor;
        statusLabelView2.layer.borderWidth=0.5;
        [_mainListView addSubview:statusLabelView2];
        UIScrollView *contentView3=[[UIScrollView alloc]initWithFrame:CGRectMake(210, 60+120*(i-1), Width-10-210, 120)];
        contentView3.tag=1+i;
        contentView3.userInteractionEnabled=YES;
        contentView3.layer.borderColor=blueCyan.CGColor;
        contentView3.layer.borderWidth=0.5;
        [_mainListView addSubview:contentView3];
       
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, 160, 90)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.numberOfLines=10;
        label1.font=[UIFont systemFontOfSize:15];
        label1.text=[nameLabelaArray objectAtIndex:i];
        [nameLabelView1  addSubview:label1];
        UILabel  *label2=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, 50, 80)];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.numberOfLines=10;
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
            if (i==6) {
                _textfield=[[UITextField alloc]initWithFrame:CGRectMake(5, 5, Width-230, 30)];
                _textfield.layer.borderColor=blueCyan.CGColor;
                _textfield.layer.borderWidth=0.5;
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
        }else if (i>6){
            nameLabelView1.frame=CGRectMake(0, 120+120*(i-1),160, 120);
            statusLabelView2.frame=CGRectMake(160, 120+120*(i-1),50, 120);
            contentView3.frame=CGRectMake(210, 120+120*(i-1),Width-220, 120);
            label1.frame=CGRectMake(0,  0, 160, 120);
            label2.frame=CGRectMake(0,  0, 50, 120);
            if (PCODE>3) {
                nameLabelView1.frame=CGRectMake(0, 840+150*(i-7),160, 150);
                statusLabelView2.frame=CGRectMake(160, 840+150*(i-7),50, 150);
                contentView3.frame=CGRectMake(210, 840+150*(i-7),Width-220, 150);
                label1.frame=CGRectMake(0,  0, 160, 150);
                label2.frame=CGRectMake(0,  0, 50, 150);
            }
        }
        if (i>0&&i<7) {
            UIButton *yangbiao=[[UIButton alloc]initWithFrame:CGRectMake(160-60,90, 60, 30)];
            [yangbiao addTarget:self action:@selector(yangbiao:) forControlEvents:UIControlEventTouchUpInside];
            yangbiao.backgroundColor=[UIColor whiteColor];
            yangbiao.layer.borderColor=blueCyan.CGColor;
            yangbiao.layer.borderWidth=0.5;
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
            zaixiantianxie.layer.borderWidth=0.5;
            zaixiantianxie.titleLabel.font=[UIFont systemFontOfSize:15];
            [zaixiantianxie setTitleColor:blueCyan forState:UIControlStateNormal];
            [zaixiantianxie setTitle:@"在线填写" forState:UIControlStateNormal];
            [nameLabelView1 addSubview:zaixiantianxie];
        }
        if (i>0) {
            UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,40, 40, 40)];
            if (i==6) {
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
        _picker = [[UIImagePickerController alloc] init];
        _picker.accessibilityValue=[NSString stringWithFormat:@"%d",sender.tag];
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.showsCameraControls = YES;
        //        picker.videoQuality=UIImagePickerControllerQualityTypeLow;
        _picker.delegate = self;
        [self presentViewController:_picker animated:YES completion:Nil];
    }];
    [alert addAction:cameraAlert];
    UIAlertAction *pictureAlert=[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _picker = [[UIImagePickerController alloc] init];
        //         picker.videoQuality=UIImagePickerControllerQualityTypeLow;
        _picker.delegate = self;
        _picker.accessibilityValue=[NSString stringWithFormat:@"%d",sender.tag];
        _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:_picker animated:YES completion:Nil];
    }];
    [alert addAction:pictureAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Get Photoes Module
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    NSData *imageData=UIImageJPEGRepresentation(originImage, 1);
//    float length=[imageData length]/1024;
    //    NSData *scaleImageData=UIImagePNGRepresentation(scaleImage);
    //    float length1=[scaleImageData length]/1024;
    //    NSLog(@"图片大小   %f  M   %f  M",length,length1);
    int imageBtnNum=[picker.accessibilityValue intValue];
    UIImage *scaleImage = [self imageWithImage:originImage scaledToSize:CGSizeMake(320*1.5, 480*1.5)];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *imagename=nil;
    if (imageBtnNum==202) {
         imagename=[NSString stringWithFormat:@"%@_a$%1.0f",[_MATERArray objectAtIndex:imageBtnNum-201],interval];
    }else if (imageBtnNum==203) {
        imagename=[NSString stringWithFormat:@"%@_b$%1.0f",[_MATERArray objectAtIndex:imageBtnNum-201],interval];
    }else if (imageBtnNum==204) {
        imagename=[NSString stringWithFormat:@"%@_c$%1.0f",[_MATERArray objectAtIndex:imageBtnNum-201],interval];
    }else{
        imagename=[NSString stringWithFormat:@"%@_%1.0f",[_MATERArray objectAtIndex:imageBtnNum-201],interval];
    }
    [_imageCommitArray addObject:scaleImage];
    [_imageNameArray addObject:imagename];
//        NSLog(@"图片   %@ ",imagename);

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
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSString *companyid=[def objectForKey:@"companyid"];
    NSString *userid=[def objectForKey:@"userid"];
    if ([def objectForKey:@"saveDic"]) {
         [self.view makeToast:@"提交数据不完整" duration:2 position:CSToastPositionCenter];
        return;
    }
    for (int i=0; i<_imageAllArray.count; i++) {
        NSArray *imageArray=[_imageAllArray objectAtIndex:i];
        if ((i==0&&imageArray==NULL)||(i==1&&imageArray==NULL)||(i==2&&imageArray==NULL)||(i==3&&imageArray==NULL)||(i==5&&imageArray==NULL)) {
            [self.view makeToast:@"必要图片获取不够" duration:2 position:CSToastPositionCenter];
                    return;
        }
    }
   //    if (_textfield.text==NULL) {
//        [self.view makeToast:@"四号线受理号" duration:2 position:CSToastPositionCenter];
//        return;
//    }
    NSArray *modifiedTagArray=@[@"0",@"0",@"1",@"1",@"0",@"0",@"0",@"1"];
    NSArray *businessIdArray=@[@"25",@"25",@"25",@"25",@"1",@"1",@"25",@"25"];
    NSDictionary *saveDic=[def objectForKey:@"saveDic"];
//    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text=@"数据加载中，请稍候...";
    [HZBanShiService BanShiWithCompanyid:companyid userid:userid qlsxcode:self.qlsxcode uuid:@"" uploadtime:@"" synctime:@"" linerange:@"[{\"x\":121.37701930100381,\"y\":31.140224825867108},{\"x\":121.37444116419017,\"y\":31.13796078195631},{\"x\":121.37535743581036,\"y\":31.135735320409562},{\"x\":121.37839370843409,\"y\":31.1385789563597},{\"x\":121.37658811435902,\"y\":31.14232655155866},{\"x\":121.37330929924761,\"y\":31.13840895880445}]" tzdm:@"" tdgyfs:@"" qlsxzx:@"" lxwh:@"" sqr:[saveDic objectForKey:@"sqr"] xmmc:[saveDic objectForKey:@"xmmc"] fddbr:[saveDic objectForKey:@"fddbr"] lxdh:[saveDic objectForKey:@"lxdh"] wtr:[saveDic objectForKey:@"wtr"] sjh:[saveDic objectForKey:@"sjh"] jsnrjgm:[saveDic objectForKey:@"jsnrjgm"] jsdzq:[saveDic objectForKey:@"jsdzq"] jsdzl:[saveDic objectForKey:@"jsdzl"] zbdz:[saveDic objectForKey:@"zbdz"] zbnz:[saveDic objectForKey:@"zbnz"] zbxz:[saveDic objectForKey:@"zbxz"] zbbz:[saveDic objectForKey:@"zbbz"] lzbg:[saveDic objectForKey:@"lzbg"] sxslh:@"" applysource:@"" xmsmqk:[saveDic objectForKey:@"xmsmqk"] filecode:@"" businessId:[businessIdArray objectAtIndex:self.PCODE] resuuid:@"" ydqsqk:@"" sfqdfapf:@"" sfghtjbg:@"" tdcb:@"" tznrjly:@"" modifiedTag:[modifiedTagArray objectAtIndex:self.PCODE] orgId:[self.orgDic objectForKey:@"orgId"] imageArray:_imageCommitArray imageNameArray:_imageNameArray AddBlock:^(NSDictionary *returnDic, NSError *error) {
    
    }];
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
-(BOOL)navigationShouldPopOnBackButton{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"saveDic"]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"返回将导致你所填写的信息丢失" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:okAlert];
        UIAlertAction *cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        return YES;
    }
   
    return NO;
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
