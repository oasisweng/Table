//
//  DTableViewCell.m
//  Table
//
//  Created by Dingzhong Weng on 25/03/2017.
//  Copyright © 2017 DZW. All rights reserved.
//

#import "DTableViewCell.h"

@implementation DTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected){
        self.backgroundColor = [UIColor redColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
