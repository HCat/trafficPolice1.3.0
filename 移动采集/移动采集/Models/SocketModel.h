//
//  SocketModel.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SocketModel : NSObject

@property (nonatomic,strong) NSNumber *fromUserId;
@property (nonatomic,strong) NSNumber *msgType;
@property (nonatomic,strong) NSNumber *totalStep;
@property (nonatomic,strong) id message;

@end
