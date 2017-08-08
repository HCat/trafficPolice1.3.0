//
//  IllegalFootCell.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalFootCell.h"

@implementation IllegalFootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)handleBtnUpAbnormalClick:(id)sender {
    
    if (self.illegalUpAbnormalBlock) {
        self.illegalUpAbnormalBlock();
    }
    
    
}



#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"IllegalFootCell dealloc");
    
}


@end
