//
//  BottomPickerView.h
//  trafficPolice
//
//  Created by hcat on 2017/5/24.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBtnBlock)(NSArray *items,NSInteger index);
typedef void(^SelectedAccidentBtnBlock)(NSString *title,NSInteger itemId,NSInteger itemType);
typedef void(^SelectedCompanyBtnBlock)(NSString *title,NSString * itemId);

@interface BottomPickerView : UIView

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,copy)   NSString *pickerTitle;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy)   SelectedBtnBlock selectedBtnBlock; //通用方法
@property (nonatomic,copy)   SelectedAccidentBtnBlock selectedAccidentBtnBlock; //特定block
@property (nonatomic,copy)   SelectedCompanyBtnBlock  selectedCompanyBtnBlock;


+ (BottomPickerView *)initCustomView;

@end
