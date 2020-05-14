//
//  AccidentChangePhotoModel.m
//  移动采集
//
//  Created by hcat on 2017/8/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentChangePhotoModel.h"

@implementation AccidentChangePhotoModel

- (BOOL)isUploadImage{

    if (_picModel) {
        return YES;
    }else{
        return NO;
    }

}


@end
