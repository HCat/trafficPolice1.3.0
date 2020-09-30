//
//  TakeOutInfoView.h
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TakeOutMoreBlock)(int index);

@interface TakeOutInfoView : UIView

@property(nonatomic,assign) BOOL isMore;
@property(nonatomic,assign) int index;

@property(nonatomic,copy) NSString * str_title;
@property(nonatomic,copy) NSString * str_content;

@property(nonatomic,copy) TakeOutMoreBlock selectedBlock;


+ (TakeOutInfoView *)initCustomView;

- (void)configUI;

@end

NS_ASSUME_NONNULL_END
