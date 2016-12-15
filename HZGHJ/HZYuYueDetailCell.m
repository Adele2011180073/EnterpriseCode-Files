//
//  HZYuYueDetailCell.m
//  HZGHJ
//
//  Created by zhang on 16/12/12.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "HZYuYueDetailCell.h"

@implementation HZYuYueDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, Width-20, 120)];
        self.bgView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:217/255.0 alpha:1];
        self.bgView.layer.borderWidth=1;
        self.bgView.layer.cornerRadius=5;
        self.bgView.layer.borderColor=[UIColor colorWithRed:23/255.0 green:177/255.0 blue:242/255.0 alpha:1].CGColor;
        [self addSubview:self.bgView];
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, Width-40, 20)];
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.font=[UIFont systemFontOfSize:17];
        [self.bgView addSubview:self.titleLabel];
        self.subTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, Width-40, 20)];
        self.titleLabel.textColor=[UIColor blackColor];
        self.subTitle.textAlignment=NSTextAlignmentLeft;
        self.subTitle.font=[UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.subTitle];
        self.nameTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, Width-40, 15)];
        self.titleLabel.textColor=[UIColor blackColor];
        self.nameTitle.textAlignment=NSTextAlignmentLeft;
        self.nameTitle.font=[UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.nameTitle];
        self.phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, Width-40, 15)];
        self.titleLabel.textColor=[UIColor blackColor];
        self.phoneLabel.textAlignment=NSTextAlignmentLeft;
        self.phoneLabel.font=[UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.phoneLabel];
        self.statusTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 75, Width-40, 15)];
        self.statusTitle.textColor=[UIColor blackColor];
        self.statusTitle.textAlignment=NSTextAlignmentLeft;
        self.statusTitle.font=[UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.statusTitle];
        self.statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, Width-40, 20)];
        self.statusLabel.textAlignment=NSTextAlignmentLeft;
        self.statusLabel.font=[UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.statusLabel];
        self.subLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 90, Width-130, 20)];
        self.subLabel.text=@"预约状态";
        self.subLabel.textAlignment=NSTextAlignmentLeft;
        self.subLabel.font=[UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.subLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
