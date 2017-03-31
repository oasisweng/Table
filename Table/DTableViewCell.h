//
//  DTableViewCell.h
//  Table
//
//  Created by Dingzhong Weng on 25/03/2017.
//  Copyright © 2017 DZW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *leftTextCurrencyLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightTextCurrencyLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftCurrencyValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightCurrencyValueLabel;

@end
