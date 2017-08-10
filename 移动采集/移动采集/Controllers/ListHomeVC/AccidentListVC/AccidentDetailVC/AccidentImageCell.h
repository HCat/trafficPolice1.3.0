//
//  AccidentImageCell.h
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentPicListModel.h"

@interface AccidentImageCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray<AccidentPicListModel *> *arr_images;

- (float)heightWithimages;

@end
