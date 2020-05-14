//
//  LRBaseResponse.h
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRBaseResponse : NSObject

@property (nonatomic,assign)    NSInteger code;
@property (nonatomic,copy)      NSString *msg;
@property (nonatomic,strong)    id data;

@end
