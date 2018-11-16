//
//  PoliceDisAnnotationView.m
//  移动采集
//
//  Created by hcat on 2018/11/14.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceDisAnnotationView.h"
#import "PoliceDistributeAnnotation.h"


#define kPoliceMinWidth  20
#define kPoliceMaxWidth  200
#define kPoliceHeight    44

#define kPoliceHoriMargin 3
#define kPoliceVertMargin 3

#define kPoliceFontSize   12

#define kPoliceArrorHeight        8


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
    
    NSString *t_str = @"陈意涵";
    
    self.backgroundColor = [UIColor clearColor];
    self.bounds = CGRectMake(0.f, 0.f, kPoliceMinWidth, kPoliceHeight);
    self.centerOffset = CGPointMake(0, -kPoliceHeight / 2.0);
   
    
    self.lb_title = [[UILabel alloc] init];
    self.lb_title.backgroundColor  = [UIColor redColor];
    self.lb_title.textAlignment    = NSTextAlignmentCenter;
    self.lb_title.textColor        = UIColorFromRGB(0x333333);
    self.lb_title.font             = [UIFont systemFontOfSize:kPoliceFontSize];
    [self addSubview:self.lb_title];
    
    self.imgv_icon = [[UIImageView alloc] init];
    
    
    
    self.lb_title.text = t_str;
    [self.lb_title sizeToFit];
    
    if (self.lb_title.frame.size.width > kPoliceMaxWidth)
    {
        self.lb_title.frame = CGRectMake(0, 0, kPoliceMaxWidth, kPoliceHeight - kPoliceVertMargin * 2 - kPoliceArrorHeight);
    }
    
    self.lb_title.center = CGPointMake(CGRectGetMidX(self.bounds), (kPoliceHeight - kPoliceVertMargin * 2 - 22)/2);
    
    if ([annotation.policeType isEqualToNumber:@1]) {
        self.imgv_icon.image = [UIImage imageNamed:@"icon_policeDis_policeLocation"];
    }else{
        self.imgv_icon.image = [UIImage imageNamed:@"icon_policeDis_policeCar"];
    }
    self.imgv_icon.frame = CGRectMake((self.lb_title.frame.size.width + kPoliceHoriMargin * 2)/2 - 11, CGRectGetMaxY(self.lb_title.frame), 22, 22);

    self.bounds = CGRectMake(0.f, 0.f, self.lb_title.frame.size.width + kPoliceHoriMargin * 2, kPoliceHeight);
    
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
    CGFloat origin_y = 10; //frame.origin.y + 10;
    //第一条线的位置坐标
    CGFloat line_1_x = rect.size.width - 20;
    CGFloat line_1_y = origin_y;
    //第二条线的位置坐标
    CGFloat line_2_x = line_1_x + 5;
    CGFloat line_2_y = rect.origin.y;
    //第三条线的位置坐标
    CGFloat line_3_x = line_2_x + 5;
    CGFloat line_3_y = line_1_y;
    //第四条线的位置坐标
    CGFloat line_4_x = rect.size.width;
    CGFloat line_4_y = line_1_y;
    //第五条线的位置坐标
    CGFloat line_5_x = rect.size.width;
    CGFloat line_5_y = rect.size.height;
    //第六条线的位置坐标
    CGFloat line_6_x = origin_x;
    CGFloat line_6_y = rect.size.height;
    
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
