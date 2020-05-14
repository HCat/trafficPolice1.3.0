//
//  IllegalAddHeadView.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/15.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFileInfo.h"
#import "IllegalAPI.h"

NS_ASSUME_NONNULL_BEGIN


@protocol IllegalAddHeadViewDelegate <NSObject>


-(void)recognitionCarNumber:(ImageFileInfo * )imageInfo;
-(void)listentCarNumber;

@end

@interface IllegalAddHeadView : UICollectionReusableView

@property (nonatomic,strong) IllegalSaveParam * param;
@property (nonatomic,weak) id<IllegalAddHeadViewDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
