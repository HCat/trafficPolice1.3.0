//
//  AccidentUpImageCell.h
//  移动采集
//
//  Created by hcat on 2018/7/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoModel.h"

@interface AccidentUpImageCell : UITableViewCell

@property (strong,nonatomic) NSMutableArray *arr_photo; //照片数据
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@end
