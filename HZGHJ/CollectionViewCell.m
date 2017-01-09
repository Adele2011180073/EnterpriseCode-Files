//
//  CollectionViewCell.m
//  HZGHJ
//
//  Created by zhang on 16/12/12.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.image=[[UIImageView alloc]initWithFrame:CGRectMake(25, 25,Width/3.5-50,Width/3.5-50)];
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,frame.size.height-Width/3.5+80, Width/3.5, 20)];
         self.numLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,15, 30, 30)];
        self.numLabel.clipsToBounds=YES;
        self.numLabel.hidden=YES;
        self.numLabel.layer.cornerRadius=15;
        self.numLabel.textAlignment=NSTextAlignmentCenter;
        self.numLabel.backgroundColor=[UIColor redColor];
        self.numLabel.textColor=[UIColor whiteColor];
         self.numLabel.font=[UIFont systemFontOfSize:16];
        self.titleLabel.font=[UIFont systemFontOfSize:16];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.textColor=[UIColor blackColor];
        [self addSubview:self.image];
        [self addSubview:self.titleLabel];
        [self addSubview:self.numLabel];
    }
    return self;
}

@end
