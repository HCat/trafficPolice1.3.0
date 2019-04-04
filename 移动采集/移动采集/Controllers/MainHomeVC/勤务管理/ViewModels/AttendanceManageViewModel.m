//
//  AttendanceManageViewModel.m
//  移动采集
//
//  Created by hcat on 2019/4/3.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AttendanceManageViewModel.h"

@implementation AttendanceManageViewModel


- (instancetype)init{
    
    if (self = [super init]) {
    
        self.arr_group = @[].mutableCopy;
        self.arr_department = @[].mutableCopy;
        
        self.index_polices = @0;
        self.arr_polices = @[].mutableCopy;
        
        NSDate * date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]];
        NSDateFormatter *dataFormant = [[NSDateFormatter alloc] init];
        [dataFormant setDateFormat: @"yyyy-MM-dd"];
        NSString *dateStr = [dataFormant stringFromDate:date];
        self.workDateStr = dateStr;
        
        @weakify(self);
        
#pragma mark - 部门数据请求。只有UserModel的dutyCode为BIG_LEADER才可以选择中队
        self.command_department = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                CommonGetDepartmentManger * manger = [[CommonGetDepartmentManger alloc] init];
            
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (self.arr_department && self.arr_department.count > 0) {
                            [self.arr_department removeAllObjects];
                        }
                        
                        [self.arr_department addObjectsFromArray:manger.commonReponse];
                        self.count_department = @(self.arr_department.count);
                        if (self.arr_department.count > 0) {
                            DepartmentModel * model = self.arr_department[0];
                            self.departmentId = model.departmentId;
                            self.departmentName = model.name;
                        };
                        
                        [subscriber sendNext:@"加载成功"];
                        
                    };
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendCompleted];
                    
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
#pragma mark - 分组数据请求。只有departmentId确定了才请求数据
        self.command_group = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                CommonGroupByDepartmentIdManger * manger = [[CommonGroupByDepartmentIdManger alloc] init];
                manger.departmentId = self.departmentId;
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (self.arr_group && self.arr_group.count > 0) {
                            [self.arr_group removeAllObjects];
                        }
                        
                        [self.arr_group addObjectsFromArray:manger.groupList];
                        self.count_group = @(self.arr_group.count);
                        [subscriber sendNext:@"加载成功"];
                        
                    };
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendCompleted];
                    
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
        
#pragma mark - 警员数据请求。只有workDateStr和groupId确定了才请求数据
        self.command_polices = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSNumber * index = input;
                
                PoliceAnalyzeListParam * param = [[PoliceAnalyzeListParam alloc] init];
                param.workDateStr = self.workDateStr;
                param.parentId = self.groupId;
                param.start = index;
                param.length = @10;
                
                PoliceAnalyzeListManger * manger = [[PoliceAnalyzeListManger alloc] init];
                manger.param = param;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if ([index isEqualToNumber:@0]) {
                            [self.arr_polices removeAllObjects];
                        }
                        
                        [self.arr_polices addObjectsFromArray:manger.analyzeList];
                        
                        if (manger.analyzeList.count < [param.length integerValue] && self.arr_polices.count > 0) {
                            [subscriber sendNext:@"请求最后一条成功"];
                        }else{
                            [subscriber sendNext:@"加载成功"];
                        }
                        
                        
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
    
    return self;
    
}



@end
