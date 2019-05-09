//
//  NSLayoutConstraintOnePixelLine.m
//  SlagCar
//
//  Created by hcat on 2018/11/26.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "NSLayoutConstraintOnePixelLine.h"

@implementation NSLayoutConstraintOnePixelLine

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.constant == 1) {
        self.constant = 1 / [UIScreen mainScreen].scale;
    }
}

@end
