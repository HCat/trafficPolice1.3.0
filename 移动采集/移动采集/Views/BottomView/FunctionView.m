//
//  FunctionView.m
//  移动采集
//
//  Created by hcat on 2019/8/21.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "FunctionView.h"

@implementation FunctionView

+ (FunctionView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FunctionView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)handleBtnTakingPicturesClick:(id)sender {
    if (self.takingPicturesBlock) {
        self.takingPicturesBlock();
    }
    
}

- (IBAction)handleBtnPhotoAlbumClick:(id)sender {
    if (self.photoAlbumBlock) {
        self.photoAlbumBlock();
    }
    
}

@end
