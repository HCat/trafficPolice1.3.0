//
//  MainListCell.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/14.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainListCell.h"

@interface MainListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_state;


@end


@implementation MainListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    
    [RACObserve(self, model) subscribeNext:^(MenuInfoModel * _Nullable x) {
        
        @strongify(self);
        
        self.lb_name.text = x.menuName;
        
        
        if ([x.isOrg isEqualToNumber:@1]) {
            
            self.imageV_icon.image = [UIImage imageNamed:x.menuIcon];
            
            if ([x.isUser isEqualToNumber:@1]) {
                if ([x.isActive isEqualToNumber:@1]) {
                    self.imageV_state.image = [UIImage imageNamed:@"check_box_active"];
                }else{
                    self.imageV_state.image = [UIImage imageNamed:@"check_box"];
                }
            }else{
                self.imageV_state.image = [UIImage imageNamed:@"check_box_disable"];
            }
            
        }else{
            
            self.imageV_icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_p",x.menuIcon]];
            self.imageV_state.image = [UIImage imageNamed:@"check_box_disable"];
        }
        
        if ([x.current isEqualToString:@"1"]) {
            self.imageV_state.image = [UIImage imageNamed:@"check_box_disable"];
        }
        
    }];
    
    
    
    
}



@end
