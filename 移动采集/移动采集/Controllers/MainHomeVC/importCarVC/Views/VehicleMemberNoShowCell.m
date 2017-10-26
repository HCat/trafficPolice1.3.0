//
//  VehicleMemberNoShowCell.m
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleMemberNoShowCell.h"
#import <PureLayout.h>
#import "CALayer+Additions.h"

@interface VehicleMemberNoShowCell ()

@property (nonatomic,weak) IBOutlet UILabel * lb_name;               //运输主体名称
@property (nonatomic,weak) IBOutlet UILabel * lb_memtype;            //运输主体性质:1土方车 2水泥砼车 3砂石子车


@property (weak, nonatomic) IBOutlet UIButton *btn_show;
@property (weak, nonatomic) IBOutlet UIView *v_backgound;

@end


@implementation VehicleMemberNoShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self imageViewWithDottedLine];
}

- (void)setMemberInfo:(MemberInfoModel *)memberInfo{
    
    _memberInfo = memberInfo;
    
    if (_memberInfo) {
        
        _lb_name.text = [ShareFun takeStringNoNull:_memberInfo.name];   //运输主体名称
        //车辆类型:1土方车 2水泥砼车 3砂石子车
        if ([_memberInfo.memtype isEqualToNumber:@1]) {
            _lb_memtype.text = @"土方车";
        }else if ([_memberInfo.memtype isEqualToNumber:@2]){
            _lb_memtype.text = @"水泥砼车";
        }else{
            _lb_memtype.text = @"砂石子车";
        }
        
    }
    
}

#pragma mark - 画虚线的ImageView

- (void)imageViewWithDottedLine{
    
    UIImageView *dashedImageView = [UIImageView newAutoLayoutView];
    [self.v_backgound addSubview:dashedImageView];
    [dashedImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_v_backgound withOffset:15];
    [dashedImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_v_backgound withOffset:-15];
    [dashedImageView autoSetDimension:ALDimensionHeight toSize:1.f];
    [dashedImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_btn_show];
    
    UIGraphicsBeginImageContext(CGSizeMake(SCREEN_WIDTH-50, 1));   // 开始画线
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(line, kCGLineCapRound);  // 设置线条终点形状
    CGFloat lengths[] = {5, 5};// 设置每画10个point空出1个point
    CGContextSetStrokeColorWithColor(line, DefaultBtnNuableColor.CGColor); // 设置线条颜色
    CGContextSetLineWidth(line, 1.0);// 设置线条宽度
    CGContextSetLineDash(line, 0, lengths, 2); // 画虚线
    CGContextMoveToPoint(line, 0.0, 0.0); // 开始画线，移动到起点
    CGContextAddLineToPoint(line, SCREEN_WIDTH-50, 0.0);// 画到终点
    CGContextStrokePath(line);
    CGContextClosePath(line);// 结束画线
    dashedImageView.image = UIGraphicsGetImageFromCurrentImageContext();// 画完后返回UIImage对象
    [self.contentView sendSubviewToBack:self.v_backgound];
}

#pragma mark - 按钮事件

- (IBAction)handleBtnShowMoreClicked:(id)sender {
    
    if (self.block) {
        self.block();
    }
    
    
}

#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    
    LxPrintf(@"VehicleMemberNoShowCell dealloc");

}

@end
