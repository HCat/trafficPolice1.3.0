//
//  AccidentImageCell.h
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccidentImageCell;

@interface AccidentImageCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray *arr_images;

- (float)heightWithimages;

@end
