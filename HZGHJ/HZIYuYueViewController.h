//
//  HZIYuYueViewController.h
//  HZGHJ
//
//  Created by zhang on 16/12/12.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "AFNetworking.h"


@interface HZIYuYueViewController : UIViewController
@property(nonatomic,strong)NSDictionary*returnData;

@property(nonatomic,strong)UILabel *placehoderLabel;
@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,retain)UIDocumentInteractionController *docController;

@property(nonatomic,strong) QLPreviewController *previewController;
@end
