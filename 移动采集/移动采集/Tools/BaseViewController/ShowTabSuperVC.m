//
//  ShowTabSuperVC.m
//  HelloToy
//
//  Created by chenzf on 15/10/9.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ShowTabSuperVC.h"
#import "AppDelegate.h"
#import "UIButton+Block.h"



@interface ShowTabSuperVC ()



@end

@implementation ShowTabSuperVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationDelegate.vc_tabBar showTabBarAnimated:NO];
    

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
    
}


#pragma mark - 定位相关

-(void)locationChange{
    
//    if (self.isNeedShowLocation) {
//        [self showLocationInfo:[LocationHelper sharedDefault].city image:@"nav_location"];
//    }
    
    
}

- (void)showLocationInfo:(NSString *)title image:(NSString *)imageName{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    //paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:13],
                                  //NSForegroundColorAttributeName:_textColor ? _textColor : textColor,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(100, 28) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    //CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 28)];
    CGRect buttonFrame = CGRectMake(0, 0, size.width + 20.0f, 28);
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentMode = UIViewContentModeScaleToFill;
    button.backgroundColor = [UIColor clearColor];
    button.frame = buttonFrame;
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitle:title forState:UIControlStateNormal];
    if(imageName.length > 0)
    {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    
    
    [button addTarget:self action:@selector(reloadLocationInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

- (void)reloadLocationInfo:(id)sender{
    
    [[LocationHelper sharedDefault] startLocation];
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

     [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
}

@end
