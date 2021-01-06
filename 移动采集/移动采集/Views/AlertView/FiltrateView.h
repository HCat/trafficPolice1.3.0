//
//  FiltrateView.h
//  ElectricityManager
//
//  Created by 黄芦荣 on 2020/6/17.
//  Copyright © 2020 hcat. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface FiltrateView : UIView


@property(nonatomic, copy , nullable) NSString * string_car;

@property(nonatomic, copy, nullable) NSString * string_name;

@property(nonatomic, copy, nullable) NSString * string_address;

@property(nonatomic, copy, nullable) NSString * string_startTime;

@property(nonatomic, copy, nullable) NSString * string_endTime;


@property (weak, nonatomic) IBOutlet UITextField * tf_car;
@property (weak, nonatomic) IBOutlet UITextField * tf_name;
@property (weak, nonatomic) IBOutlet UITextField * tf_startTime;
@property (weak, nonatomic) IBOutlet UITextField * tf_endTime;
@property (weak, nonatomic) IBOutlet UITextField * tf_address;




+ (FiltrateView *)initCustomView;

@end

NS_ASSUME_NONNULL_END
