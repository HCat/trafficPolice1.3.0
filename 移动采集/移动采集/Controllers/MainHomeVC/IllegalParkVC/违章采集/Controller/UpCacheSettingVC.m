//
//  UpCacheSettingVC.m
//  移动采集
//
//  Created by hcat on 2018/10/16.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "UpCacheSettingVC.h"
#import "AutomaicUpCacheModel.h"

@interface UpCacheSettingVC ()

@property (weak, nonatomic) IBOutlet UISwitch *switch_automatic;

@end

@implementation UpCacheSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    switch (_automaicUpCacheType) {
        case UpCacheTypePark:{
            [self.switch_automatic setOn:[AutomaicUpCacheModel sharedDefault].isAutoPark];
        }
            break;
        case UpCacheTypeReversePark:{
             [self.switch_automatic setOn:[AutomaicUpCacheModel sharedDefault].isAutoReversePark];
            
        }
            break;
        case UpCacheTypeLockPark:{
             [self.switch_automatic setOn:[AutomaicUpCacheModel sharedDefault].isAutoLockPark];
        }
            break;
        case UpCacheTypeCarInfoAdd:{
             [self.switch_automatic setOn:[AutomaicUpCacheModel sharedDefault].isAutoCarInfoAdd];
        }
            break;
        case UpCacheTypeThrough:{
             [self.switch_automatic setOn:[AutomaicUpCacheModel sharedDefault].isAutoThrough];
        }
            break;
        case UpCacheTypeAccident:{
             [self.switch_automatic setOn:[AutomaicUpCacheModel sharedDefault].isAutoAccident];
        }
            break;
        case UpCacheTypeFastAccident:{
             [self.switch_automatic setOn:[AutomaicUpCacheModel sharedDefault].isAutoFastAccident];
        }
            break;
            
        default:
            break;
    }

}


- (IBAction)handleSwitchChanges:(id)sender {
    
    UISwitch * switch_automaic = sender;
    
    switch (_automaicUpCacheType) {
        case UpCacheTypePark:{
            [[AutomaicUpCacheModel sharedDefault] setIsAutoPark:switch_automaic.isOn];
        }
            break;
        case UpCacheTypeReversePark:{
            [[AutomaicUpCacheModel sharedDefault] setIsAutoReversePark:switch_automaic.isOn];
        }
            break;
        case UpCacheTypeLockPark:{
            [[AutomaicUpCacheModel sharedDefault] setIsAutoLockPark:switch_automaic.isOn];
        }
            break;
        case UpCacheTypeCarInfoAdd:{
            [[AutomaicUpCacheModel sharedDefault] setIsAutoCarInfoAdd:switch_automaic.isOn];
        }
            break;
        case UpCacheTypeThrough:{
            [[AutomaicUpCacheModel sharedDefault] setIsAutoThrough:switch_automaic.isOn];
        }
            break;
        case UpCacheTypeAccident:{
            [[AutomaicUpCacheModel sharedDefault] setIsAutoAccident:switch_automaic.isOn];
        }
            break;
        case UpCacheTypeFastAccident:{
            [[AutomaicUpCacheModel sharedDefault] setIsAutoFastAccident:switch_automaic.isOn];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"UpCacheSettingVC dealloc");
    
}


@end
