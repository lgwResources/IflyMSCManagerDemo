//
//  RBObjectSingleton.h
//  RepairBang
//
//  Created by L on 2018/5/10.
//  Copyright © 2018年 RB. All rights reserved.
//  单例

#ifndef RBObjectSingleton_h
#define RBObjectSingleton_h

#define RBOBJECT_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
@synchronized(self) {                            \
if (z##_shared_obj_name_ == nil) {             \
static dispatch_once_t done;\
dispatch_once(&done, ^{ z##_shared_obj_name_ = [[self alloc] init]; });\
}\
}                                                \
return z##_shared_obj_name_;                     \
}                                                  \
+ (id)allocWithZone:(NSZone *)zone {               \
@synchronized(self) {                            \
if (z##_shared_obj_name_ == nil) {             \
z##_shared_obj_name_ = [super allocWithZone:NULL]; \
return z##_shared_obj_name_;                 \
}                                              \
}                                                \
\
return nil;                                    \
}

#endif /* RBObjectSingleton_h */
