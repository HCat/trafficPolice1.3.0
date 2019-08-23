//
//  FunctionView.h
//  移动采集
//
//  Created by hcat on 2019/8/21.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TakingPicturesBlock)(void);
typedef void(^PhotoAlbumBlock)(void);


@interface FunctionView : UIView

@property (nonatomic, copy) TakingPicturesBlock takingPicturesBlock; //拍照事件
@property (nonatomic, copy) PhotoAlbumBlock photoAlbumBlock; //相册事件

+ (FunctionView *)initCustomView;


@end

NS_ASSUME_NONNULL_END
