//
//  UIViewController+AKTabBarController.m
//
//  Created by hcat on 2017/10/10.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UIViewController+AKTabBarController.h"

#import "AKTabBarController.h"

@implementation UIViewController (AKTabBarController)

- (NSString *)tabImageName
{
	return nil;
}

- (NSString *)tabSelectedImageName
{
    return nil;
}

- (NSString *)tabTitle
{
	return nil;
}

-(void)tabBarReSelected{
    
}

-(BOOL)showMask{
    return NO;
}

-(NSInteger)showMaskNumber{
    return 0;
}


-(BOOL)canChangeTab{
    return YES;
}

- (AKTabBarController *)akTabBarController
{
    UIViewController *parent = self.parentViewController;
    Class cls = [AKTabBarController class];
    while(parent) {
        if([parent isKindOfClass:cls]) {
            return (AKTabBarController*) parent;
        }
        parent = parent.parentViewController;
    }

    return nil;
}

@end
