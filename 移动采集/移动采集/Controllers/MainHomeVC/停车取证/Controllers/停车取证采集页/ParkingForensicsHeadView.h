//
//  ParkingForensicsHeadView.h
//  移动采集
//
//  Created by hcat on 2019/7/29.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingForensicsAPI.h"
#import "LRCameraVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ParkingForensicsHeadViewDelegate <NSObject>

- (void)recognitionCarNumber:(ImageFileInfo * )imageInfo;

@end

@interface ParkingForensicsHeadView : UICollectionReusableView

@property (nonatomic,strong) ParkingForensicsParam * param;
@property(copy, nonatomic, nullable)  NSString * placenum;
@property (nonatomic,weak) id<ParkingForensicsHeadViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
