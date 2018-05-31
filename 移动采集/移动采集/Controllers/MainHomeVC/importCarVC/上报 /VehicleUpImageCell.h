//
//  VehicleUpImageCell.h
//  移动采集
//
//  Created by hcat on 2018/5/17.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoModel.h"

@interface VehicleUpImageCell : UITableViewCell

@property(nonatomic,strong) NSMutableArray *arr_images;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@end
