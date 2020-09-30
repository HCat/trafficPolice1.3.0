//
//  PoliceDisAnnotationView.m
//  移动采集
//
//  Created by hcat on 2018/11/14.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceDisAnnotationView.h"
#import "PoliceDistributeAnnotation.h"
#import "PoliceDetailDisAnnotationView.h"


#define kPoliceMinWidth  20
#define kPoliceMaxWidth  200
#define kPoliceHeight    44

#define kPoliceHoriMargin 3
#define kPoliceVertMargin 5

#define kPoliceFontSize   12
#define kPoliceIconSize   22

#define kPoliceArrorHeight 3
#define kPoliceArrorWidth  6

@interface PoliceDisAnnotationView()

@property(nonatomic,strong) UILabel * lb_title;
@property(nonatomic,strong) UIButton * btn_action;
@property(nonatomic,strong) UIImageView * imgv_icon;
@end


@implementation PoliceDisAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    PoliceDistributeAnnotation * t_annotation = (PoliceDistributeAnnotation *)annotation;
    self = [super initWithAnnotation:t_annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initializeAnnotation:t_annotation];
    }
    
    return self;
}

- (void)initializeAnnotation:(PoliceDistributeAnnotation *)annotation {
    [self setupAnnotation:annotation];
}


- (void)setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    
     PoliceDistributeAnnotation * t_annotation = (PoliceDistributeAnnotation *)self.annotation;
    
    //当annotation滑出地图时候，即ann为nil时，不设置(否则由于枚举的类型会执行不该执行的方法)，只有annotation在地图范围内出现时才设置，可以打断点调试
    if (t_annotation) {
        [self setupAnnotation:t_annotation];
    }
}


- (void)setupAnnotation:(PoliceDistributeAnnotation *)annotation {
    
    NSString *t_str = annotation.policeModel.userName;
    if ([annotation.policeType isEqualToNumber:@2]) {
        t_str = annotation.vehicleCar.plateNo;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.bounds = CGRectMake(0.f, 0.f, kPoliceMinWidth, kPoliceHeight);
    self.centerOffset = CGPointMake(0, -(kPoliceHeight-kPoliceIconSize)/ 2.0);
    
    if (self.lb_title) {
        [self.lb_title removeFromSuperview];
        self.lb_title = nil;
    }
    
    if (self.imgv_icon) {
        [self.imgv_icon removeFromSuperview];
        self.imgv_icon = nil;
    }
    
    if (self.btn_action) {
        [self.btn_action removeFromSuperview];
        self.btn_action = nil;
    }

    self.lb_title = [[UILabel alloc] init];
    self.lb_title.backgroundColor  = [UIColor clearColor];
    self.lb_title.textAlignment    = NSTextAlignmentCenter;
    self.lb_title.textColor        = UIColorFromRGB(0x333333);
    self.lb_title.font             = [UIFont systemFontOfSize:kPoliceFontSize];
    [self addSubview:self.lb_title];
    
    self.imgv_icon = [[UIImageView alloc] init];
    [self addSubview:self.imgv_icon];
    
    self.lb_title.text = t_str;
    [self.lb_title sizeToFit];
    
    if (self.lb_title.frame.size.width > kPoliceMaxWidth)
    {
        self.lb_title.frame = CGRectMake(0, 0, kPoliceMaxWidth, kPoliceHeight - kPoliceVertMargin * 2 - kPoliceArrorHeight);
    }
    
    if ([annotation.policeType isEqualToNumber:@1]) {
        self.imgv_icon.image = [UIImage imageNamed:@"icon_policeDis_policeLocation"];
    }else{
        self.imgv_icon.image = [UIImage imageNamed:@"icon_policeDis_policeCar"];
    }
    
    self.bounds = CGRectMake(0.f, 0.f, self.lb_title.frame.size.width + kPoliceHoriMargin * 2, kPoliceHeight);
    
    self.lb_title.center = CGPointMake(CGRectGetMidX(self.bounds), (kPoliceHeight - kPoliceIconSize - kPoliceArrorHeight)/2);
    
    self.imgv_icon.frame = CGRectMake((self.lb_title.frame.size.width + kPoliceHoriMargin * 2 - kPoliceIconSize)/2,  CGRectGetMaxY(self.bounds)-kPoliceIconSize, kPoliceIconSize, kPoliceIconSize);
    self.btn_action.frame = self.bounds;
    
}



- (UIButton *)btn_action{
    if (!_btn_action) {
        _btn_action = [[UIButton alloc] init];
        _btn_action.backgroundColor = [UIColor clearColor];
        [_btn_action addTarget:self action:@selector(handleBtnCarClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_action];
    }
    
    return _btn_action;
    
}


- (void)handleBtnCarClicked:(id)sender{
    
    PoliceDistributeAnnotation * t_annotation = (PoliceDistributeAnnotation *)self.annotation;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POLICE_SHOWDETAIL object:t_annotation];
    
}


#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    NSLog(@"正在drawRect...");
    
    //获取当前图形,视图推入堆栈的图形,相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //
    [[UIColor whiteColor] set];
    //创建一个新的空图形路径
    CGContextBeginPath(ctx);
    
    NSLog(@"开始绘制...");
    
    //起始位置坐标
    CGFloat origin_x = rect.origin.x;
    CGFloat origin_y = rect.origin.y; //frame.origin.y + 10;
    //第一条线的位置坐标
    CGFloat line_1_x = rect.size.width;
    CGFloat line_1_y = origin_y;
    //第二条线的位置坐标
    CGFloat line_2_x = line_1_x;
    CGFloat line_2_y = CGRectGetMinY(_imgv_icon.frame) - kPoliceArrorHeight;
    //第三条线的位置坐标
    CGFloat line_3_x = CGRectGetMidX(self.bounds) + kPoliceArrorWidth/2;
    CGFloat line_3_y = line_2_y;
    //第四条线的位置坐标
    CGFloat line_4_x = CGRectGetMidX(self.bounds);
    CGFloat line_4_y = line_2_y + kPoliceArrorHeight;
    //第五条线的位置坐标
    CGFloat line_5_x = CGRectGetMidX(self.bounds) - kPoliceArrorWidth/2;
    CGFloat line_5_y = line_2_y;
    //第六条线的位置坐标
    CGFloat line_6_x = origin_x;
    CGFloat line_6_y = line_2_y;
    
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    
    CGContextAddLineToPoint(ctx, line_1_x, line_1_y);
    CGContextAddLineToPoint(ctx, line_2_x, line_2_y);
    CGContextAddLineToPoint(ctx, line_3_x, line_3_y);
    CGContextAddLineToPoint(ctx, line_4_x, line_4_y);
    CGContextAddLineToPoint(ctx, line_5_x, line_5_y);
    CGContextAddLineToPoint(ctx, line_6_x, line_6_y);
    
    CGContextClosePath(ctx);
    
    //设置填充颜色
    UIColor *customColor = [UIColor colorWithWhite:1 alpha:1];
    CGContextSetFillColorWithColor(ctx, customColor.CGColor);
    CGContextFillPath(ctx);
    

}



@end
