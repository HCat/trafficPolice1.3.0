//
//  IllegalParkAddHeadView.h
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalParkAPI.h"
#import "LRCameraVC.h"

@protocol IllegalParkAddHeadViewDelegate <NSObject>


-(void)recognitionCarNumber:(LRCameraVC *)cameraVC;
-(void)listentCarNumber;

@end

@interface IllegalParkAddHeadView : UICollectionReusableView

@property (nonatomic,strong) IllegalParkSaveParam *param;

@property (nonatomic,weak) id<IllegalParkAddHeadViewDelegate>delegate;

@property (nonatomic,assign,readonly) BOOL isCanCommit;

//拍照识别车牌照片之后做的处理

- (void)takePhotoToDiscernmentWithCarNumber:(NSString *)carNummber;

//提交成功之后headView所做的处理

- (void)handleBeforeCommit;

//通过所在路段的名字获取得到roadId
- (void)getRoadId;

@end
