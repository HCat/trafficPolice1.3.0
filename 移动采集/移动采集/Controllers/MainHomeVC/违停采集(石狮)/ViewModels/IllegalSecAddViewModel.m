//
//  IllegalSecAddViewModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalSecAddViewModel.h"

@implementation IllegalSecAddViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.param = [[IllegalSecAddParam alloc] init];
        self.arr_upImages =  [NSMutableArray array];
        self.count = self.arr_upImages.count;
        
        @weakify(self);
        //监听建筑垃圾类型数量
        [RACObserve(self,count) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            
            if ([x intValue] > 0) {
                self.isCanCommit = YES;
            }else{
                self.isCanCommit = NO;
            }
            
            
        }];
        
       
    }
    
    return self;
    
}

- (RACCommand *)command_load{
    
    if (_command_load == nil) {
        
        @weakify(self);
        self.command_load = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                IllegalSecLoadManger *manger = [[IllegalSecLoadManger alloc] init];
                manger.illegalId = self.param.illegalId;
                [manger configLoadingTitle:@"加载"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        self.secDetailModel = manger.illegalSecDetailModel;
                        [subscriber sendNext:@"加载成功"];
                    }
                    
                    [subscriber sendCompleted];
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return _command_load;

}

- (RACCommand *)command_add{
    
    if (_command_add == nil) {
           
           @weakify(self);
           self.command_add = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
               @strongify(self);
               RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                   
                   IllegalSecAddManger * manger = [[IllegalSecAddManger alloc] init];
                   manger.param = self.param;
                   LxDBObjectAsJson(manger.param);
                   [manger configLoadingTitle:@"提交"];
                   [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                       
                       if (manger.responseModel.code == CODE_SUCCESS) {
                           [subscriber sendNext:@"提交成功"];
                       }else{
                           [subscriber sendNext:@"提交失败"];
                       }
                   
                       [subscriber sendCompleted];
                       
                   } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                       [subscriber sendNext:@"提交失败"];
                       [subscriber sendCompleted];
                   }];
                   
                   return nil;
               }];
               
               return t_signal;
           }];
           
       }
       
       return _command_add;

}


//添加图片到arr_upImages数组中
- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo{
    
    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:imageFileInfo.fileName forKey:@"remarks"];
    [self.arr_upImages addObject:t_dic];
    self.count = self.arr_upImages.count;
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (self.arr_upImages && self.arr_upImages.count > 0) {
        
        LxDBObjectAsJson(self.arr_upImages);
        
        NSMutableArray *t_arr_files     = [NSMutableArray array];
        NSMutableArray *t_arr_remarks   = [NSMutableArray array];
        
        NSInteger j = 1;
        
        for (int i = 0; i < _arr_upImages.count; i++) {
            
            if([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]){
                
                NSMutableDictionary *t_dic  = _arr_upImages[i];
                ImageFileInfo *imageInfo    = [t_dic objectForKey:@"files"];
                
                if (imageInfo) {
                    [t_arr_files    addObject:imageInfo];
                    NSString *t_title = [NSString stringWithFormat:@"二次采集照%ld",j];
                    [t_arr_remarks  addObject:t_title];
                    j++;
                }
                
            }
            
        }
        
        if (t_arr_files.count > 0) {
            _param.files = t_arr_files;
        }
        
        if (t_arr_remarks.count > 0) {
            _param.remarks = [t_arr_remarks componentsJoinedByString:@","];;
        }
        
    }
    
}


@end
