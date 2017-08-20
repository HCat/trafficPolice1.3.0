//
//  AccidentChangePhotoModel.h
//  移动采集
//
//  Created by hcat on 2017/8/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentPicListModel.h"
#import <Photos/Photos.h>

@interface AccidentChangePhotoModel : NSObject

@property (nonatomic, strong) NSNumber *modelId;
@property (nonatomic, strong) AccidentPicListModel *picModel;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) PHAsset *asset;


@end
