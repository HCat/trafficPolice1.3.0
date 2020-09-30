//
//  IllegalSearchView.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^IllegalSearchSelectAcion)(NSString *carNo,NSNumber * status);

@interface IllegalSearchView : UIView

@property (nonatomic,copy) IllegalSearchSelectAcion selectedBlock;

+ (IllegalSearchView *)initCustomView;

@end

NS_ASSUME_NONNULL_END
