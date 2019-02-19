//
//  CollAddressDetailTableViewCell.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/8.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollAddressDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buildingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *layerNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *machineImageView;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@end
