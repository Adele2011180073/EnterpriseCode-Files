//
//  HZPictureViewController.h
//  HZGHJ
//
//  Created by zhang on 16/12/13.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface HZPictureViewController : UIViewController
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSString *imageURL;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)BOOL isWeb;
@property(nonatomic,assign)NSInteger indexOfImage;
@end
