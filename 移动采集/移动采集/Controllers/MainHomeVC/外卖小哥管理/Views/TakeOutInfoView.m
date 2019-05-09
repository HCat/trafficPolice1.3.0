//
//  TakeOutInfoView.m
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutInfoView.h"

@interface TakeOutInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_arrow;

@property (weak, nonatomic) IBOutlet UILabel *lb_more;



@end

@implementation TakeOutInfoView

+ (TakeOutInfoView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TakeOutInfoView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    // Initialization code
}

- (void)configUI{
    
    if (self.isMore) {
        self.lb_content.hidden = YES;
        self.imageV_arrow.hidden = NO;
        self.lb_more.hidden = NO;
        self.lb_more.text = self.str_content;
        self.lb_title.text = self.str_title;
        
    }else{
        self.imageV_arrow.hidden = YES;
        self.lb_more.hidden = YES;
        self.lb_content.hidden = NO;
        self.lb_content.text = self.str_content;
        self.lb_title.text = self.str_title;
    }
    
}


- (IBAction)handleBtnMoreClicked:(id)sender {
    
    if (self.selectedBlock) {
        self.selectedBlock(self.index);
    }

}



@end
