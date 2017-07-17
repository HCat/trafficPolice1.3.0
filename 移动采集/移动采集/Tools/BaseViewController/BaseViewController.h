//
//  BaseViewController.h
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NetworkChangeBlock)();

@interface BaseViewController : UIViewController

@property (nonatomic,copy) NetworkChangeBlock networkChangeBlock;

@end
