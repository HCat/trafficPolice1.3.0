//
//  CALayer+Additions.m
//  trafficPolice
//
//  Created by hcat on 2017/5/23.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer(Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end
