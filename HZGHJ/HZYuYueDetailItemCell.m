//
//  HZYuYueDetailItemCell.m
//  HZGHJ
//
//  Created by zhang on 17/2/20.
//  Copyright © 2017年 FiveFu. All rights reserved.
//

#import "HZYuYueDetailItemCell.h"

@implementation HZYuYueDetailItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
       self.label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 120, self.frame.size.height-20)];
        self.label.textAlignment=NSTextAlignmentRight;
        self.label.textColor=blueCyan;
        self.label.font=[UIFont systemFontOfSize:15];
       [self.contentView addSubview:self.label];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(125, 10, 1, self.frame.size.height-20)];
        line.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        [self addSubview:line];
        
        self.text=[[UILabel alloc]initWithFrame:CGRectMake(130, 10, Width -140, self.frame.size.height-20)];
        self.text.numberOfLines=0;
        CGSize sizeToFit = [@"也是今天要记录的这个方法,在IOS8以后,官方提供了另外一个显示不等高cell的方法,首先,要保证你的约束对于cell来说限制死了上下边距,然后在controller写上预计高度,然后告诉控制器我自适应就好了,不用去自己计算cellHeigh" sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(Width-140, CGFLOAT_MAX) lineBreakMode:UILineBreakModeTailTruncation];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
        self.text.frame=CGRectMake(130, 10, Width-140, sizeToFit.height+20);
        self.text.text=@"也是今天要记录的这个方法,在IOS8以后,官方提供了另外一个显示不等高cell的方法,首先,要保证你的约束对于cell来说限制死了上下边距,然后在controller写上预计高度,然后告诉控制器我自适应就好了,不用去自己计算cellHeigh";
        self.text.textAlignment=NSTextAlignmentLeft;
        self.text.font=[UIFont systemFontOfSize:15];
         [self.contentView addSubview:self.text];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
