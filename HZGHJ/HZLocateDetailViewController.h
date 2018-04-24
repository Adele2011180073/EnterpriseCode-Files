//
//  HZLocateDetailViewController.h
//  HZGHJ
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZLocateDetailViewController : UIViewController
@property(nonatomic,retain)NSDictionary *qlsxcodeDic;
@property(nonatomic,retain)NSString *type;//判断是否是建筑类 市政类
@property(nonatomic,retain)NSString* orgId;
@end
