//
//  CollAddressVCTableViewCell.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/8.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *machineImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *styleImageView;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
