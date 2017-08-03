//
//  BottomPickerView.m
//  trafficPolice
//
//  Created by hcat on 2017/5/24.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "BottomPickerView.h"
#import "UIButton+Block.h"


@interface BottomPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *lb_PickTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_selectedItem;

@end

@implementation BottomPickerView

+ (BottomPickerView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"BottomPickerView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [_btn_selectedItem setEnlargeEdgeWithTop:10 right:30 bottom:10 left:50];
    // Initialization code
}

- (void)setPickerTitle:(NSString *)pickerTitle{

    _pickerTitle = pickerTitle;
    _lb_PickTitle.text = _pickerTitle;

}


#pragma mark UIPickerView DataSource Method 数据源方法

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            if (self.items) {
                result = self.items.count;//根据数组的元素个数返回几行数据
            }
            
            break;
            
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerView Delegate Method 代理方法

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = UIColorFromRGB(0x4281E8);
        }
    }
    
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
   
    switch (component) {
        case 0:{
            if (self.items && self.items.count > 0) {
                NSObject *obj = self.items[row];
                if ([obj isMemberOfClass:[AccidentGetCodesModel class]]) {
                    AccidentGetCodesModel *t_model =( AccidentGetCodesModel *)obj;
                    genderLabel.text = t_model.modelName;
                }else{
                    genderLabel.text = self.items[row];
                    
                }
            }
            
            break;
        }
        default:
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = UIColorFromRGB(0x444444);
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:genderLabel.text];
    NSRange range = [genderLabel.text rangeOfString:genderLabel.text];
    [attributedString addAttributes:dic range:range];
    genderLabel.attributedText = attributedString;
    
    return genderLabel;
}


- (IBAction)handleBtnSelectedItemClicked:(id)sender {
    
    _index = [_pickView selectedRowInComponent:0];
    
    if (self.selectedBtnBlock) {
        self.selectedBtnBlock(_items,_index);
    }
    if (self.items && self.items.count > 0 ) {
        
        NSObject *obj = self.items[_index];
        if ([obj isMemberOfClass:[AccidentGetCodesModel class]]) {
            AccidentGetCodesModel *t_model =( AccidentGetCodesModel *)obj;
            if(self.selectedAccidentBtnBlock){
                self.selectedAccidentBtnBlock(t_model.modelName, t_model.modelId,t_model.modelType);
                
            }
        }
    }
}




@end
