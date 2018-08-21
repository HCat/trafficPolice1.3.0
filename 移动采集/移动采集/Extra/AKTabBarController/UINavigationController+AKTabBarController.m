//
//  UINavigationController+AKTabBarController.m
//
//  Created by hcat on 2017/10/10.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UINavigationController+AKTabBarController.h"

@implementation UINavigationController (AKTabBarController)

- (NSString *)tabImageName{
	return [(self.viewControllers)[0] tabImageName];
}

- (NSString *)tabSelectedImageName{
    return [(self.viewControllers)[0] tabSelectedImageName];
}

- (NSString *)tabTitle{
	return [(self.viewControllers)[0] tabTitle];
}

-(BOOL)showMask{
    return [(self.viewControllers)[0] showMask];
}

-(BOOL)showTip{
    return [(self.viewControllers)[0] showTip];
}

-(NSInteger)showMaskNumber{
    return [(self.viewControllers)[0] showMaskNumber];;
}

-(BOOL)canChangeTab{
    return [(self.viewControllers)[0] canChangeTab];
}

@end
