//
//  UITableView+Lr_Placeholder.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "UITableView+Lr_Placeholder.h"
#import "NSObject+Swizzling.h"
#import "LRPlaceholderView.h"

@implementation UITableView (Lr_Placeholder)

#pragma mark - methods swizzing

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) bySwizzledSelector:@selector(lr_reloadData)];
        
    });
}

- (void)lr_reloadData{
    if (self.isNeedPlaceholderView == NO) {
        //不需要被methods swizzing
        [self lr_reloadData];
        return;
    }
    
    if (!self.firstReload) {
        
        if(self.isNetAvailable){
            if (!self.placeholderView) {
                [self makeDefaultNetAvailableView];
            }
            
            [self addSubview:self.placeholderView];
            self.placeholderView.hidden = NO;
           
        }else{
            
            if (!self.placeholderView) {
                 [self makeDefaultPlaceholderView];
            }
            [self checkEmpty]; 
        }
        
    }
    // 用于进行判断第一次默认reloadData的行为
    self.firstReload = NO;
    [self lr_reloadData];

}

#pragma mark - DefaultPlaceholderView

- (void)makeDefaultNetAvailableView{
    
    LRPlaceholderView *placeholderView = [[LRPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    placeholderView.isNetvailable = self.isNetAvailable;

    __weak typeof(self) weakSelf = self;
    [placeholderView setReloadClickBlock:^{
        __strong typeof (self) strongSelf = weakSelf;
        if (strongSelf.reloadBlock) {
            strongSelf.reloadBlock();
        }
    }];
    
    self.placeholderView = placeholderView;

}

- (void)makeDefaultPlaceholderView{
    
    LRPlaceholderView *placeholderView = [[LRPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    placeholderView.isNetvailable = self.isNetAvailable;
    placeholderView.str_placeholder = self.str_placeholder;
    
    self.placeholderView = placeholderView;

}

#pragma mark -

- (void)checkEmpty{
    
    BOOL isEmpty = YES; //flag标示
    
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1;//获取当前TableView组数
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i];//获取当前TableView各组行数
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
        }
    }
    
    if (isEmpty) {//若为空，加载占位图
        //默认占位图
        self.placeholderView.hidden = NO;
        [self addSubview:self.placeholderView];
    } else {
        //不为空，移除占位图
        self.placeholderView.hidden = YES;
        [self.placeholderView removeFromSuperview];
    }
    
}

#pragma mark - placeholderView

- (UIView *)placeholderView{

    return objc_getAssociatedObject(self, @selector(placeholderView));
}

- (void)setPlaceholderView:(UIView *)placeholderView{
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

#pragma mark - firstReload

- (BOOL)firstReload {
    return [objc_getAssociatedObject(self, @selector(firstReload)) boolValue];
}

- (void)setFirstReload:(BOOL)firstReload {
    objc_setAssociatedObject(self, @selector(firstReload), @(firstReload), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - isNetAvailable

- (BOOL)isNetAvailable {
    return [objc_getAssociatedObject(self, @selector(isNetAvailable)) boolValue];
}

- (void)setIsNetAvailable:(BOOL)isNetAvailable {
    objc_setAssociatedObject(self, @selector(isNetAvailable), @(isNetAvailable), OBJC_ASSOCIATION_ASSIGN);
    
    if (self.placeholderView) {
        [self.placeholderView removeFromSuperview];
        self.placeholderView.hidden = YES;
        self.placeholderView = nil;
        
    }
}

#pragma mark - isNeedPlaceholderView

- (void)setIsNeedPlaceholderView:(BOOL)isNeedPlaceholderView{
    // 注意BOOL类型 需要用OBJC_ASSOCIATION_RETAIN_NONATOMIC 不要用错，否则set方法会赋值出错
    objc_setAssociatedObject(self, @selector(isNeedPlaceholderView), @(isNeedPlaceholderView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isNeedPlaceholderView{
    //_cmd == @select(isIgnore); 和set方法里一致
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setStr_placeholder:(NSString *)str_placeholder{
    // 注意BOOL类型 需要用OBJC_ASSOCIATION_RETAIN_NONATOMIC 不要用错，否则set方法会赋值出错
    objc_setAssociatedObject(self, @selector(str_placeholder), str_placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)str_placeholder{
    //_cmd == @select(isIgnore); 和set方法里一致
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - reloadBlock

- (void (^)(void))reloadBlock {
    return objc_getAssociatedObject(self, @selector(reloadBlock));
}

- (void)setReloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, @selector(reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
