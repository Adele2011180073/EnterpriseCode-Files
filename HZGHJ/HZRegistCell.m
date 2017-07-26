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
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 107, self.contentView.frame.size.height)];
        self.titleLabel.numberOfLines=2;
        self.titleLabel.textColor=[UIColor darkGrayColor];
        self.titleLabel.font=[UIFont systemFontOfSize:16];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
        UILabel  *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(118,  5, 2, self.contentView.frame.size.height-10)];
        lineLabel.backgroundColor=littleGray;
        [self  addSubview:lineLabel];
        
        self.textview=[[UITextView alloc]initWithFrame:CGRectMake(120, 5, Width-140, self.contentView.frame.size.height-10)];
        self.textview.translatesAutoresizingMaskIntoConstraints=NO;
        self.textview.font=[UIFont systemFontOfSize:15];
        self.textview.textColor=[UIColor darkGrayColor];
        [self  addSubview:self.textview];
    
//        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
//         [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
//             make.top.equalTo(@(Width-140));
//             make.left.equalTo(self).offset(120);
//             make.right.equalTo(self).offset(10);
//             make.bottom.equalTo(self).offset(10);
//         }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
