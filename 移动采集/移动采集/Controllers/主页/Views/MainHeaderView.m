//
//  MainHeaderView.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainHeaderView.h"

@interface MainHeaderView()

@property (assign, nonatomic) CGFloat historyY;
@property (weak, nonatomic) IBOutlet UIImageView *image_bg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lb_name_bottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_image_bottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_user_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_user_height;

@end


@implementation MainHeaderView

+ (MainHeaderView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MainHeaderView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV_user.layer.cornerRadius = self.image_user_width.constant/2;

}

- (void)scrollViewWillBeginDragging:(CGFloat)contentOffsetY{
    
    self.historyY = contentOffsetY;
    
}


- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    
    CGFloat height = IS_IPHONE_X_MORE ? 160 + 24 : 160;
    
    height = height - Height_NavBar+20;
    
    self.image_user_width.constant = 40 + (17 * ((height - contentOffsetY)/height));
    self.image_user_height.constant = 40 + (17 * ((height - contentOffsetY)/height));
    self.imageV_user.layer.cornerRadius = self.image_user_width.constant/2;
    self.lb_name.alpha = 1.0 * ((38 - contentOffsetY)/38);
    self.lb_phone.alpha = 1.0 * ((38 - contentOffsetY)/38);
    if (contentOffsetY > 35) {
        self.image_bg.hidden = YES;
        self.backgroundColor = UIColorFromRGB(0x305BF1);
    }else{
        self.image_bg.hidden = NO;
        self.backgroundColor = UIColorFromRGB(0xfffffff);
    }
    
    if (contentOffsetY< self.historyY) {
        if (contentOffsetY > 64) {
            self.lb_name_bottom.constant  = 15;
        }else{
            self.lb_name_bottom.constant  = (15 + (49 - contentOffsetY) > 64) ? 64 : (15 + (49 - contentOffsetY));
        }
        
        if (contentOffsetY > 38) {
            self.layout_image_bottom.constant = 10;
        }else{
            self.layout_image_bottom.constant  = (10 + (28 - contentOffsetY) > 38) ? 38 : (10 + (28 - contentOffsetY));
        }
        
        
    }else if (contentOffsetY > self.historyY) {

        if (contentOffsetY > 64) {
            self.lb_name_bottom.constant  = 15;
        }else{
            self.lb_name_bottom.constant  = 64- contentOffsetY;
        }
        
        if (contentOffsetY > 38) {
            self.layout_image_bottom.constant = 10;
        }else{
            self.layout_image_bottom.constant = 38- contentOffsetY;
        }
        
    }

}



@end
