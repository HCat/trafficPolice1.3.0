//
//  PoliceLocationCell.h
//  移动采集
//
//  Created by hcat on 2017/9/13.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface PoliceLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UIImageView *imgV_location;


@property (nonatomic, strong) AMapPOI *poi;


@end
