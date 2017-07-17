//
//  BaseModel.m
//  trafficPolice
//
//  Created by hcat on 2017/5/22.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (nullable instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}


- (id)copyWithZone:(nullable NSZone *)zone{

    return [self modelCopy];

}
- (NSUInteger)hash{

    return [self modelHash];
}


- (BOOL)isEqual:(id)object{
    return [self modelIsEqual:object];

}

@end
