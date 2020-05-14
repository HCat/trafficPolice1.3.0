//
//  TaskFlowsUserListVC.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "AddressBookAPI.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^taskFlowsUserListBlock)(AddressBookModel * model);

@interface TaskFlowsUserListVC : HideTabSuperVC

@property (nonatomic,copy) taskFlowsUserListBlock block;

@end

NS_ASSUME_NONNULL_END
