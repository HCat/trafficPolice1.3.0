//
//  JointImageCell.m
//  移动采集
//
//  Created by hcat on 2017/11/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "JointImageCell.h"
#import "JointImageVC.h"
#import "JointEnforceVC.h"


@implementation JointImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - set && get

- (void)setImageList:(NSMutableArray<JointLawImageModel *> *)imageList{
    _imageList = imageList;
    if (_imageList) {
        
        
        
        
    }

}


#pragma mark -

- (IBAction)handleBtnImageAddClicked:(id)sender {
    
    WS(weakSelf);
     JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    JointImageVC *t_imageAddVC = [[JointImageVC alloc] init];
    t_imageAddVC.block = ^(NSArray<JointLawImageModel *> *imageList) {
        SW(strongSelf, weakSelf);
        if (strongSelf.imageList.count > 0) {
            [strongSelf.imageList removeAllObjects];
        }
        [strongSelf.imageList addObjectsFromArray:imageList];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOADJOINTLAWIMAGE object:nil];
    };
    [t_vc.navigationController  pushViewController:t_imageAddVC animated:YES];
    
}

#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    
    NSLog(@"JointImageCell dealloc");
    
}

@end
