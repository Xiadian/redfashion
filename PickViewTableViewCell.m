//
//  PickViewTableViewCell.m
//  redfashion
//
//  Created by XiaDian on 16/1/4.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "PickViewTableViewCell.h"

@implementation PickViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
