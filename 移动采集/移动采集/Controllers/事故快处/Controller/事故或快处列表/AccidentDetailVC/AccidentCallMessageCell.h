//
//  AccidentCallMessageCell.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/16.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccidentCallMessageCell : UITableViewCell

@property(nonatomic,strong) AccidentInfoModel *accident;

- (float)heightWithAccident;

@end

NS_ASSUME_NONNULL_END
