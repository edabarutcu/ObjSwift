//
//  RuntimeBridge.h
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeBridge : NSObject

+ (NSArray<NSString *> *)getClassesConformingToProtocol:(NSString *)protocolName NS_SWIFT_NAME(getClasses(conformingTo:));
+ (NSArray<NSString *> *)getMethodsForClass:(NSString *)className NS_SWIFT_NAME(getMethods(for:));
+ (NSArray<NSDictionary<NSString *, id> *> *)getPropertiesForClass:(NSString *)className NS_SWIFT_NAME(getProperties(for:));
+ (NSArray<NSString *> *)getInstanceVariablesForClass:(NSString *)className NS_SWIFT_NAME(getInstanceVariables(for:));

+ (nullable id)callMethod:(NSString *)methodName
                   onObject:(id)object
              withArguments:(nullable NSArray *)arguments
                     error:(NSError **)error;

+ (BOOL)respondsToSelector:(NSString *)selectorString onObject:(id)object NS_SWIFT_NAME(responds(to:on:));

+ (nullable NSString *)getSuperclassOfClass:(NSString *)className NS_SWIFT_NAME(getSuperclass(of:));
+ (NSArray<NSString *> *)getClassHierarchyForClass:(NSString *)className NS_SWIFT_NAME(getClassHierarchy(for:));

+ (nullable NSString *)getTypeEncodingForProperty:(NSString *)propertyName
                                          inClass:(NSString *)className
                                            error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

