//
//  IllegalImageCell.h
//  trafficPolice
//
//  Created by hcat on 2017/6/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllegalImageCell : UITableViewCell

@property (nonatomic,strong) NSNumber * type; //1为IllegalExposureDetail调用 2为IllegalAddDetailVC调用
@property (nonatomic,strong) NSMutableArray *arr_images;

- (float)heightWithimages;

@end
