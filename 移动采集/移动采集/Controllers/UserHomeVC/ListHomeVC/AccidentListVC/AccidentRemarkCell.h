//
//  AccidentRemarkCell.h
//  移动采集
//
//  Created by hcat on 2017/8/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarkModel.h"

typedef void(^remarkCountClickBlock)(void);

@interface AccidentRemarkCell : UITableViewCell

@property (nonatomic,strong) RemarkModel *remarkModel;
@property (nonatomic,assign) NSInteger remarkCount;
@property (nonatomic,copy) remarkCountClickBlock countBlock;


@end
