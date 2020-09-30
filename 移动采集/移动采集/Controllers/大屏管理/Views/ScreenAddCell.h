//
//  ScreenAddCell.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/6/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ScreenAddCellCancelBlock)(NSNumber * index);
typedef void(^ScreenAddCellDoneBlock)(NSNumber * index,NSString * name);

@interface ScreenAddCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *tf_name;

@property(nonatomic, copy) NSString * name;

@property(nonatomic, strong) NSNumber * count;
@property(nonatomic, strong) NSNumber * index;

@property(nonatomic, copy) ScreenAddCellCancelBlock block;
@property(nonatomic, copy) ScreenAddCellDoneBlock doneBlock;
@end

NS_ASSUME_NONNULL_END
