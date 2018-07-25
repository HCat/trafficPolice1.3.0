//
//  AccidentUpCell.h
//  移动采集
//
//  Created by hcat on 2018/7/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AccidentUpCellDelegate <NSObject>

- (void)handleUpAction;

@end


@interface AccidentUpCell : UITableViewCell

@property(nonatomic,weak) id<AccidentUpCellDelegate> delegate;

@end
