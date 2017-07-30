//
//  HZLocateContentViewController.h
//  HZGHJ
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface HZLocateContentViewController : UIViewController
@property(nonatomic,retain)NSString *uuid;//已提交
@property(nonatomic,strong)NSDictionary *commitData;//已提交

@property(nonatomic,retain)NSString *qlsxcode;
@property(nonatomic,assign)int PCODE;
@property(nonatomic,assign)int orgId;
@property(nonatomic,strong)NSArray* posArray;
@end
