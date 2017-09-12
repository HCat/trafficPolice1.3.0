//
//  GroupPoliceView.h
//  移动采集
//
//  Created by hcat on 2017/9/12.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupPoliceView;

typedef void(^GroupPoliceViewSelectedBlock)(GroupPoliceView *view);
typedef void(^GroupPoliceViewMakeSureBlock)(NSString *groupName, NSNumber *groupId);

@interface GroupPoliceView : UIView

@property (weak, nonatomic) IBOutlet UITextField *tf_groupName;

@property (nonatomic,strong) NSNumber * groupId;
@property (nonatomic,copy) NSString * groupName;
@property (nonatomic,copy) GroupPoliceViewSelectedBlock selectedBlock;
@property (nonatomic,copy) GroupPoliceViewMakeSureBlock makeSureBlock;


+ (GroupPoliceView *)initCustomView;

- (void)dismiss;

@end
