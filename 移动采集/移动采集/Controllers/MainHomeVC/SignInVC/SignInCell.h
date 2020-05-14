//
//  SignInCell.h
//  移动采集
//
//  Created by hcat on 2017/9/4.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInCellDelegate <NSObject>


- (void)handleBtnSignInOrOut;

@end

@interface SignInCell : UITableViewCell

@property (nonatomic,strong) NSDate *currentDate;
@property (nonatomic,assign) BOOL workstate;
@property (nonatomic,weak) id<SignInCellDelegate> delegate;

@end
