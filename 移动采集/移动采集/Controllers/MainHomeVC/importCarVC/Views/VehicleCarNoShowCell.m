//
//  VehicleCarNoShowCell.m
//  移动采集
//
//  Created by hcat-89 on 2017/9/7.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleCarNoShowCell.h"
#import <PureLayout.h>
#import "CALayer+Additions.h"

@interface VehicleCarNoShowCell ()

@property (nonatomic,weak) IBOutlet UILabel * lb_plateno;                    //车牌号
@property (nonatomic,weak) IBOutlet UILabel * lb_jinNumber;                    //晋工号
@property (nonatomic,weak) IBOutlet UILabel * lb_carType;                    //车辆类型:1土方车 2水泥砼车 3砂石子车
@property (nonatomic,weak) IBOutlet UILabel * lb_inspectTimeEnd;             //车厢外高度


@property (weak, nonatomic) IBOutlet UIButton *btn_show;
@property (weak, nonatomic) IBOutlet UIView *v_backgound;

@end


@implementation VehicleCarNoShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self imageViewWithDottedLine];
}


- (void)setVehicle:(VehicleModel *)vehicle{
    
    _vehicle = vehicle;
    
    if (_vehicle) {
        
        _lb_plateno.text = [ShareFun takeStringNoNull:_vehicle.plateno];  //车牌号
        _lb_jinNumber.text = [ShareFun takeStringNoNull:[NSString stringWithFormat:@"%@%@",_vehicle.memFormNo,_vehicle.selfNo]];
        
        //车辆类型:1土方车 2水泥砼车 3砂石子车
        if ([_vehicle.carType isEqualToNumber:@1]) {
            _lb_carType.text = @"土方车";
        }else if ([_vehicle.carType isEqualToNumber:@2]){
            _lb_carType.text = @"水泥砼车";
        }else{
            _lb_carType.text = @"砂石子车";
        }
        
        _lb_inspectTimeEnd.text = [ShareFun takeStringNoNull:_vehicle.carriageOutsideH];             //年审截止日期
  
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
    CGContextClosePath(line);// 结束画线
    CGContextStrokePath(line);
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
    
    LxPrintf(@"VehicleCarNoShowCell dealloc");
    
}

@end
