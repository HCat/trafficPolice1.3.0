//
//  IllegalThroughSecAddView.m
//  trafficPolice
//
//  Created by hcat on 2017/6/5.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalThroughSecAddView.h"

@interface IllegalThroughSecAddView()

@property (weak, nonatomic) IBOutlet UILabel *lb_roadName;
@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;


@end


@implementation IllegalThroughSecAddView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCarNumber:(NSString *)carNumber{
    _carNumber = carNumber;
    
    if (_carNumber) {
        _lb_carNumber.text = _carNumber;
    }
}

- (void)setRoadName:(NSString *)roadName{
    _roadName = roadName;
    
    if (_roadName) {
        _lb_roadName.text = _roadName;
    }

}

#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"IllegalThroughSecAddView dealloc");
    
}

@end
