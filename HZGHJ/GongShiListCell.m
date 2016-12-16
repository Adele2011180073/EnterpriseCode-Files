//
//  GongShiListCell.m
//  HZGHJ
//
//  Created by zhang on 16/12/15.
//  Copyright © 2016年 FiveFu. All rights reserved.
//

#import "GongShiListCell.h"

@implementation GongShiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.image = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.image.textColor=blueCyan;
        self.image.text=@"\U0000e67f";
        self.image.font=[UIFont fontWithName:@"iconfont" size:32];
        [self addSubview:self.image ];
        
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50,10,Width-60, 20)];
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.numberOfLines=1;
        self.titleLabel.font=[UIFont systemFontOfSize:16];
        [self addSubview:self.titleLabel];
        self.subLabel=[[UILabel alloc]initWithFrame:CGRectMake(50,30 , 150, 20)];
        self.subLabel.textColor=[UIColor grayColor];
        self.subLabel.textAlignment=NSTextAlignmentLeft;
        self.subLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:self.subLabel];
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(Width-160,40 , 150, 20)];
        self.timeLabel.textColor=[UIColor darkGrayColor];
        self.timeLabel.textAlignment=NSTextAlignmentLeft;
        self.timeLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.timeLabel];
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(Width-160,40 , 150, 20)];
        self.timeLabel.textColor=[UIColor darkGrayColor];
        self.timeLabel.textAlignment=NSTextAlignmentLeft;
        self.timeLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
