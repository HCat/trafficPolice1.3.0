//
//  RemarkModel.h
//  移动采集
//
//  Created by hcat on 2017/8/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemarkModel : NSObject

@property (nonatomic, strong) NSNumber * remarkId;      //主键
@property (nonatomic, copy)   NSString * createName;    //名称
@property (nonatomic, strong) NSNumber * createTime;    //时间
@property (nonatomic, copy)   NSString * contents;      //备注


@end
