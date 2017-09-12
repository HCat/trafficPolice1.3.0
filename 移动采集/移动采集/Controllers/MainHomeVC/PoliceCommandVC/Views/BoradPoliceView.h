//
//  BoradPoliceView.h
//  移动采集
//
//  Created by hcat on 2017/9/12.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextView.h"

typedef void(^BoradPoliceViewBlock)(NSString *content);


@interface BoradPoliceView : UIView

@property (weak, nonatomic) IBOutlet FSTextView *tv_content;

@property (nonatomic,copy,readonly) NSString * content;
@property (nonatomic,copy) BoradPoliceViewBlock block;


+ (BoradPoliceView *)initCustomView;

- (void)dismiss;

@end
