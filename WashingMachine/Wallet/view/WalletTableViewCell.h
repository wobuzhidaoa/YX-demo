//
//  WalletTableViewCell.h
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/4.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@end
