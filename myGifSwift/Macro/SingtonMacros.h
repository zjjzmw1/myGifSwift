//
//  SingtonMacros.h
//  SwiftCodeFragments
//
//  Created by zhangmingwei on 2017/2/17.
//  Copyright © 2017年 SpeedX. All rights reserved.
//

#ifndef SingtonMacros_h
#define SingtonMacros_h


#define SAFE_GET_STRING(presence, key) \
([presence objectForKey:key] != nil && [presence objectForKey:key] != [NSNull null]) && [[presence objectForKey:key] isKindOfClass:[NSString class]] && ![[presence objectForKey:key] isEqualToString:@"null"] && ![[presence objectForKey:key] isEqualToString:@"<null>"] ? [presence objectForKey:key] : @"" \

#define CHECK_STRING_SAFE(val) \
val != nil ? [NSString stringWithFormat:@"%@", val] : @"" \

#define SAFE_GET_NUMBER(presence, key)  \
([presence objectForKey:key] != nil && [presence objectForKey:key] != [NSNull null]) ? [presence objectForKey:key] : @0 \




#pragma mark - 单例化一个类 instanceMethod:单例的方法名称

#define instance_interface(className, instanceMethod)   \
\
+ (instancetype)instanceMethod;

//实现方法
#define instance_implementation(className, instanceMethod)   \
\
static className * _instance; \
\
+ (instancetype)instanceMethod \
{   static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
+ (id)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone { \
return _instance; \
}



#endif /* SingtonMacros_h */
