//
//  IllegalImageCell.h
//  trafficPolice
//
//  Created by hcat on 2017/6/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllegalImageCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray *arr_images;

- (float)heightWithimages;

@end
