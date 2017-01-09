//
//  HZHomeViewController.h
//  HZGHJ
//
//  Created by zhang on 16/12/6.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZURL.h"
@protocol LocalNotiDelegate;
@interface HZHomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UIView *noticeView;
@property(strong,nonatomic)NSDictionary *dic;
@property (weak, nonatomic) id<LocalNotiDelegate> delegate;
@end
@protocol LocalNotiDelegate <NSObject>
@required
-(void)getNoti;

@end
