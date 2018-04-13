//
//  HZRegistCell.m
//  HZGHJ
//
//  Created by zhang on 2017/7/25.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZRegistCell.h"
#import "Masonry.h"
@implementation HZRegistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 107, 60)];
        self.titleLabel.numberOfLines=2;
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.font=[UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
        UILabel  *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(118,  5, 2, 50)];
        lineLabel.backgroundColor=[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0];
        [self  addSubview:lineLabel];
        
        self.textview=[[UITextView alloc]initWithFrame:CGRectMake(120, 0, Width-125, 60)];
        self.textview.translatesAutoresizingMaskIntoConstraints=NO;
        self.textview.font=[UIFont systemFontOfSize:15];
        self.textview.textColor=[UIColor darkGrayColor];
        [self  addSubview:self.textview];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
