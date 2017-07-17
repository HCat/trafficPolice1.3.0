

/**
 *  在.h文件中定义的宏，arc
 *
 *  LRSingletonH(name) 这个是宏
 *  + (instancetype)shared##Name;这个是被代替的方法， ##代表着shared+Name 高度定制化
 * 在外边我们使用 “LRSingletonH(Name)” 那么在.h文件中，定义了一个方法"+ (instancetype)sharedName",所以，第一个字母要大写
 *
 *  @return 一个搞定好的方法名
 */
#define LRSingletonH(Name) + (instancetype)shared##Name;


/**
 *  在.m文件中处理好的宏 arc
 *
 *  LRSingletonM(Name) 这个是宏,因为是多行的东西，所以每行后面都有一个"\",最后一行除外，
 * 之所以还要传递一个“Name”,是因为有个方法要命名"+ (instancetype)shared##Name"
 *  @return 单利
 */
#define LRSingletonM(Name) \
static id _instance = nil;\
+ (instancetype)shared##Name{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
return _instance;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone{\
return _instance;\
}\
- (id)mutableCWithZone:(NSZone *)zone{\
    return _instance;\
}\


