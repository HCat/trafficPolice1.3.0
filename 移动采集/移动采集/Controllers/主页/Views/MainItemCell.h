//
//  MainItemCell.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/12.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainItemCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *lb_number;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_box;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_titleAndImage;



@end

NS_ASSUME_NONNULL_END
