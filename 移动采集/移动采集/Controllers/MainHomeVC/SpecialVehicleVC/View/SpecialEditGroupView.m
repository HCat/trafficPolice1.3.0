//
//  SpecialEditGroupView.m
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialEditGroupView.h"

@interface SpecialEditGroupView()

@property (weak, nonatomic) IBOutlet UIView *v_show;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_subTitle;
@property (weak, nonatomic) IBOutlet UITextField *tf_group;

@property (nonatomic, strong) UIWindow *keyWindow;
@property(nonatomic,assign) BOOL keyBoardlsVisible;

@end


@implementation SpecialEditGroupView

+ (SpecialEditGroupView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SpecialEditGroupView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.v_show setClipsToBounds:YES];
    self.keyBoardlsVisible = NO;
    
    _tf_group.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _tf_group.leftViewMode = UITextFieldViewModeAlways;
   
    _lb_title.text = _title;
    _lb_subTitle.text = _subTitle;
    if (_model) {
        _tf_group.text = _model.name;
    }

}

- (IBAction)handleBtnQuitClicked:(id)sender {
    
    [self hide];
    
}


- (IBAction)handleBtnDetermineClicked:(id)sender {
    

    if (_tf_group.text.length == 0) {
        [ShareFun showTipLable:@"请输入组名"];
        return;
    }
    
    [_tf_group resignFirstResponder];
    
    
    WS(weakSelf);
    
    if (_model) {
        SpecialSaveGroupParam * param = [[SpecialSaveGroupParam alloc] init];
        param.groupId = _model.carId;
        param.name = _tf_group.text;
        
        LxDBObjectAsJson(param);
        SpecialSaveGroupManger * manger = [[SpecialSaveGroupManger alloc] init];
        manger.param = param;
        [manger configLoadingTitle:@"修改"];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                [strongSelf.model setName:param.name];
               
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPECIAL_EDITGROUP object:nil];
                [strongSelf performSelector:@selector(hide) withObject:nil afterDelay:1.5f];
                
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        
        
    }else{
        
        SpecialSaveGroupParam * param = [[SpecialSaveGroupParam alloc] init];
        param.name = _tf_group.text;
       
        SpecialSaveGroupManger * manger = [[SpecialSaveGroupManger alloc] init];
        manger.param = param;
        [manger configLoadingTitle:@"添加"];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                [strongSelf performSelector:@selector(hide) withObject:nil afterDelay:1.5f];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPECIAL_ADDGROUP object:nil];
                
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        
        
    }
    
    
}


- (void)show{
    
    self.keyWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _keyWindow.backgroundColor = [UIColor clearColor];
    _keyWindow.windowLevel = UIWindowLevelAlert;
    
    self.frame = _keyWindow.bounds;
    
    [_keyWindow addSubview:self];
    [_keyWindow makeKeyAndVisible];
    
}

- (void)hide{
    
    [self removeFromSuperview];
    if (self.keyWindow) {
        [self.keyWindow resignKeyWindow];
        [[UIApplication sharedApplication].delegate.window makeKeyWindow];
    }
    
}
- (void)keyboardWillShow:(NSNotification *)notification{
    
    if (!self.keyBoardlsVisible) {
        [self.v_show setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    }
    
}


-(void)keyboardDidShow:(NSNotification *)notification
{
    if (!self.keyBoardlsVisible) {
        self.keyBoardlsVisible = YES;
        //获取键盘高度
        NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect;
        
        [keyboardObject getValue:&keyboardRect];
        
        //得到键盘的高度
        //CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //调整放置有textView的view的位置
        
        //设置动画
        [UIView beginAnimations:nil context:nil];
        
        //定义动画时间
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelay:0];
        
        //设置view的frame，往上平移
        LxPrintf(@"%f",keyboardRect.size.height);
        
        CGFloat y = 0;
        if ( (SCREEN_HEIGHT - CGRectGetMaxY(self.v_show.frame)) < 347) {
            y = SCREEN_HEIGHT - CGRectGetMaxY(self.v_show.frame) - 347 ;
            [self.v_show setFrame:CGRectMake(self.v_show.frame.origin.x,  self.v_show.frame.origin.y + y, self.v_show.frame.size.width, self.v_show.frame.size.height)];
        }
        
        //提交动画
        [UIView commitAnimations];
    }
    
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    //[UIView beginAnimations:nil context:nil];
    // [UIView setAnimationDuration:0.25];
    self.keyBoardlsVisible = NO;
    //设置view的frame，往下平移
    [self.v_show setFrame:CGRectMake(0, 0, self.v_show.frame.size.width, self.v_show.frame.size.height)];
    [self.v_show setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    // [UIView commitAnimations];
}



- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    LxPrintf(@"SpecialEditGroupView dealloc");
    
}



@end
