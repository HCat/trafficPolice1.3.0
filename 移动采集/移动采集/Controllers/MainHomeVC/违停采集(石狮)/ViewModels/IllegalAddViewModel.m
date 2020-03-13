//
//  IllegalAddViewModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/15.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAddViewModel.h"
#import "CommonAPI.h"

@implementation IllegalAddViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.param = [[IllegalSaveParam alloc] init];
        self.arr_upImages =  [NSMutableArray array];
        [self.arr_upImages addObject:[NSNull null]];
        [self.arr_upImages addObject:[NSNull null]];
        self.first = self.arr_upImages[0];
        self.secend = self.arr_upImages[1];
        
        @weakify(self);
        [[RACSignal combineLatest:@[RACObserve(self.param, roadId), RACObserve(self, first),RACObserve(self, secend),RACObserve(self.param, address),RACObserve(self.param, longitude),RACObserve(self.param, latitude),RACObserve(self.param, carNo)] reduce:^id (NSNumber * roadId,id first,id secend,NSString * address,NSNumber * longitude,NSNumber * latitude,NSString * carNo){
            return @(roadId && ![first isKindOfClass:[NSNull class]]&& ![secend isKindOfClass:[NSNull class]] && address.length > 0 && longitude && latitude && carNo.length > 0);
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.isCanCommit = [x boolValue];

        }];
        
        [[RACSignal combineLatest:@[[RACObserve(self.param, roadId) distinctUntilChanged], [RACObserve(self.param, carNo) distinctUntilChanged]] reduce:^id (NSNumber * roadId,NSString * carNo){
            return @(roadId && carNo && carNo.length > 0 && [ShareFun validateCarNumber:carNo]);
        }] subscribeNext:^(id x) {
            @strongify(self);
            if ([x boolValue]) {
                [self.command_carNoSect execute:nil];
            }
        
        }];
        
    }
    
    return self;
    
}


- (RACCommand *)command_commit{
    
    @weakify(self);
    if (_command_commit == nil) {
        _command_commit = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                IllegalSaveManger * manger = [[IllegalSaveManger alloc] init];
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
    
    return _command_commit;
    
    
    
}

- (RACCommand *)command_carNoSect{
    
    if (_command_carNoSect == nil) {
        
        @weakify(self);
        _command_carNoSect = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                /*code:0 超过90秒有一次采集记录，返回一次采集ID、采集时间，提示“同路段该车于yyyy-MM-dd已被拍照采集”，跳转至二次采集页面
                 code:110 提示“同路段当天已有违章行为，请不要重复采集！”
                 code:13 提示“同路段该车1分30秒内有采集记录，是否重新采集？”
                 code:999 无采集记录,不用任何提示
                 code:1 提示24小时到48小时内违章的提醒，如果无违章则为套牌提醒
                */
                
                IllegalCarNoSecManger * manger = [[IllegalCarNoSecManger alloc] init];
                manger.carNo = self.param.carNo;
                manger.roadId = self.param.roadId;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                   RACTuple * tuple = RACTuplePack(@(manger.responseModel.code),manger.illegalReponse,manger.responseModel.msg);
                    
                   [subscriber sendNext:tuple];
                    
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
    
    return _command_carNoSect;
    
}


- (RACCommand *)command_identifyCarNo{
    
    if (_command_identifyCarNo == nil) {
        
        @weakify(self);
        _command_identifyCarNo = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ImageFileInfo * imageInfo = (ImageFileInfo * )input;
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
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"识别车牌成功" object:nil];
                                    [subscriber sendNext:imageInfo];
                                }
                               
                            }
                            
                            if (manger.commonIdentifyResponse.cutImageUrl.length == 0 || !manger.commonIdentifyResponse.cutImageUrl) {
                                [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];
                                [subscriber sendNext:@"识别失败"];
                            }
                            
                        }
                    }else{
                        [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];
                        [subscriber sendNext:@"识别失败"];
                    }
                    [subscriber sendCompleted];
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];
                    [subscriber sendNext:@"识别失败"];
                    [subscriber sendCompleted];
                }];
                

                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return _command_identifyCarNo;
    
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
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"识别车牌成功" object:nil];
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
                    [t_arr_files    addObject:imageInfo];
                    [t_arr_remarks  addObject:t_str];
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


#pragma mark  - 存储停止定位位置

- (void)handleBeforeCommit{

    LocationStorageModel * model = [[LocationStorageModel alloc] init];
    model.streetName    = _param.roadName;
    model.address       = _param.address;
    
    [[LocationStorage sharedDefault] setIllegal:model];
    
    [_arr_upImages removeAllObjects];
    [_arr_upImages addObject:[NSNull null]];
    [_arr_upImages addObject:[NSNull null]];
    self.first = self.arr_upImages[0];
    self.secend = self.arr_upImages[1];
    
    self.param = [[IllegalSaveParam alloc] init];
    
    @weakify(self);
    [[RACSignal combineLatest:@[RACObserve(self.param, roadId), RACObserve(self, first),RACObserve(self, secend),RACObserve(self.param, address),RACObserve(self.param, longitude),RACObserve(self.param, latitude),RACObserve(self.param, carNo)] reduce:^id (NSNumber * roadId,id first,id secend,NSString * address,NSNumber * longitude,NSNumber * latitude,NSString * carNo){
        return @(roadId && ![first isKindOfClass:[NSNull class]]&& ![secend isKindOfClass:[NSNull class]] && address.length > 0 && longitude && latitude && carNo.length > 0);
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.isCanCommit = [x boolValue];

    }];
    
    [[RACSignal combineLatest:@[[RACObserve(self.param, roadId) distinctUntilChanged], [RACObserve(self.param, carNo) distinctUntilChanged]] reduce:^id (NSNumber * roadId,NSString * carNo){
        return @(roadId && carNo && carNo.length > 0 && [ShareFun validateCarNumber:carNo]);
    }] subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.command_carNoSect execute:nil];
        }
    
    }];
    
    [[LocationHelper sharedDefault] startLocation];
}

@end
