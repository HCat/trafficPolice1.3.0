//
//  ElectronicTypeModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/4/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ElectronicTypeModel : NSObject

@property (nonatomic,copy) NSString * typeName;      //片区名
@property (nonatomic,strong) NSNumber * typeId;        //片区编号

@end

NS_ASSUME_NONNULL_END
