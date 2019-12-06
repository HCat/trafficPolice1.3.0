//
//  IllegalExposureViewModel.m
//  移动采集
//
//  Created by hcat on 2019/12/5.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "IllegalExposureViewModel.h"
#import "CommonAPI.h"


@implementation IllegalExposureViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.param = [[ExposureCollectReportParam alloc] init];
        self.param.remarkNoCar = @1;
        
        self.arr_upImages =  [NSMutableArray array];
        [self.arr_upImages addObject:[NSNull null]];
        [self.arr_upImages addObject:[NSNull null]];
        self.first = self.arr_upImages[0];
        self.secend = self.arr_upImages[1];
        
        @weakify(self);
        [[RACSignal combineLatest:@[RACObserve(self.param, roadId), RACObserve(self, first),RACObserve(self.param, address),RACObserve(self.param, longitude),RACObserve(self.param, latitude),RACObserve(self.param, illegalType)] reduce:^id (NSNumber * roadId,id first,NSString * address,NSNumber * longitude,NSNumber * latitude,NSString * illegalType){
            return @(roadId && ![first isKindOfClass:[NSNull class]] && address.length > 0 && longitude && latitude && illegalType.length > 0);
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.isCanCommit = [x boolValue];
        }];
        
        
        self.command_commit = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ExposureCollectReportManger * manger = [[ExposureCollectReportManger alloc] init];
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
    
    return self;
    
}

- (RACCommand *)command_illegalList{
    
    if (_command_illegalList == nil) {
        
        @weakify(self);
        self.command_illegalList = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ExposureCollectTypeListManger * manger = [[ExposureCollectTypeListManger alloc] init];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        self.illegalList = manger.list;
                        [subscriber sendNext:@"加载成功"];
                    }else{
                        [subscriber sendNext:@"加载失败"];
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
    
    return _command_illegalList;
    
}





//拍照完之后停车取证请求服务端获取证件信息
- (void)getParkingIdentifyRequest:(ImageFileInfo * )imageInfo{

    @weakify(self);
    imageInfo.name = key_file;
    CommonIdentifyManger *manger = [[CommonIdentifyManger alloc] init];
    [manger configLoadingTitle:@"识别"];
    manger.isNeedShowHud = NO;
   
    manger.imageInfo = imageInfo;
    manger.type = 1;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        @strongify(self);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            if (manger.commonIdentifyResponse) {
                
                if (manger.commonIdentifyResponse.carNo && manger.commonIdentifyResponse.carNo.length > 0) {
                    if (manger.commonIdentifyResponse.carNo && manger.commonIdentifyResponse.carNo.length > 0) {
                        self.param.carNo = manger.commonIdentifyResponse.carNo;
                        self.param.carColor = manger.commonIdentifyResponse.color;
                    }
                   
                }
                
                if (manger.commonIdentifyResponse.cutImageUrl.length == 0 || !manger.commonIdentifyResponse.cutImageUrl) {
                    [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];
                }
                
            }
        }else{
            [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];

    }];
    

}

#pragma mark - 管理上传图片

//替换图片到arr_upImages数组中
- (void)replaceUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index{
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:remark forKey:@"remarks"];
    
    if (imageFileInfo) {
        imageFileInfo.name = key_files;
        [t_dic setObject:imageFileInfo             forKey:@"files"];
    }
    
    [t_dic setObject:@0 forKey:@"isMore"];
    [self.arr_upImages  replaceObjectAtIndex:index withObject:t_dic];
    
    self.first = self.arr_upImages[0];
    self.secend = self.arr_upImages[1];
    
}

//添加图片到arr_upImages数组中
- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark{
    
    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:remark forKey:@"remarks"];
    [t_dic setObject:@1 forKey:@"isMore"];
    [self.arr_upImages addObject:t_dic];
    
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (self.arr_upImages && self.arr_upImages.count > 0) {
        
        LxDBObjectAsJson(self.arr_upImages);
        
        NSMutableArray *t_arr_files     = [NSMutableArray array];
        NSMutableArray *t_arr_remarks   = [NSMutableArray array];
        
        for (int i = 0; i < _arr_upImages.count; i++) {
            
            if([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]){
                
                NSMutableDictionary *t_dic  = _arr_upImages[i];
                ImageFileInfo *imageInfo    = [t_dic objectForKey:@"files"];
                NSString * t_str = [t_dic objectForKey:@"remarks"];
                
                if (imageInfo) {
                    [t_arr_files     addObject:imageInfo];
                    if ([t_str isEqualToString:@"车牌近照"] ) {
                        [t_arr_remarks addObject:@"2"];
                    }else{
                        [t_arr_remarks addObject:@"0"];
                    }
                    
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
