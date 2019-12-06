//
//  IllegalExposureIllegalTypeModel.h
//  移动采集
//
//  Created by hcat on 2019/12/5.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IllegalExposureIllegalTypeModel : NSObject

@property(nonatomic,copy)    NSString * illegalId;      //违法类型编号
@property(nonatomic,copy)    NSString * illegalName;    //违法名称
@property(nonatomic,copy)    NSString * parentId;       //父类ID
@property(nonatomic,strong)  NSNumber * floor;          //层级 0 父级 1 子级
@property(nonatomic,assign)  BOOL isSelected;           //是否被选中

@property(nonatomic,strong)  NSArray <IllegalExposureIllegalTypeModel *> * exposureTypeList;

@end

NS_ASSUME_NONNULL_END
