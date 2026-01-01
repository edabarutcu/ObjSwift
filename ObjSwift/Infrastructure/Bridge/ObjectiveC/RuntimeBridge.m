//
//  RuntimeBridge.m
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

#import "RuntimeBridge.h"

@implementation RuntimeBridge

+ (NSArray<NSString *> *)getClassesConformingToProtocol:(NSString *)protocolName {
    NSMutableArray<NSString *> *classes = [NSMutableArray array];
    
    Protocol *protocol = NSProtocolFromString(protocolName);
    if (!protocol) {
        return classes;
    }
    
    int numClasses = objc_getClassList(NULL, 0);
    Class *classesList = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classesList, numClasses);
    
    for (int i = 0; i < numClasses; i++) {
        Class cls = classesList[i];
        if (class_conformsToProtocol(cls, protocol)) {
            [classes addObject:NSStringFromClass(cls)];
        }
    }
    
    free(classesList);
    return classes;
}

+ (NSArray<NSString *> *)getMethodsForClass:(NSString *)className {
    NSMutableArray<NSString *> *methods = [NSMutableArray array];
    Class cls = NSClassFromString(className);
    
    if (!cls) {
        return methods;
    }
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(cls, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL selector = method_getName(methodList[i]);
        [methods addObject:NSStringFromSelector(selector)];
    }
    
    free(methodList);
    return methods;
}

+ (NSArray<NSDictionary<NSString *, id> *> *)getPropertiesForClass:(NSString *)className {
    NSMutableArray<NSDictionary<NSString *, id> *> *properties = [NSMutableArray array];
    Class cls = NSClassFromString(className);
    
    if (!cls) {
        return properties;
    }
    
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(cls, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        const char *attributes = property_getAttributes(property);
        
        NSString *name = [NSString stringWithUTF8String:propertyName];
        NSString *attrString = [NSString stringWithUTF8String:attributes];
        
        NSString *type = @"id";
        NSArray *components = [attrString componentsSeparatedByString:@","];
        if (components.count > 0) {
            NSString *typeEncoding = components[0];
            if ([typeEncoding hasPrefix:@"T@"]) {
                if (typeEncoding.length > 3) {
                    type = [typeEncoding substringWithRange:NSMakeRange(2, typeEncoding.length - 3)];
                } else {
                    type = @"id";
                }
            } else if ([typeEncoding hasPrefix:@"T"]) {
                type = typeEncoding;
            }
        }
        
        [properties addObject:@{
            @"name": name,
            @"type": type,
            @"attributes": components ?: @[]
        }];
    }
    
    free(propertyList);
    return properties;
}

+ (NSArray<NSString *> *)getInstanceVariablesForClass:(NSString *)className {
    NSMutableArray<NSString *> *ivars = [NSMutableArray array];
    Class cls = NSClassFromString(className);
    
    if (!cls) {
        return ivars;
    }
    
    unsigned int ivarCount = 0;
    Ivar *ivarList = class_copyIvarList(cls, &ivarCount);
    
    for (unsigned int i = 0; i < ivarCount; i++) {
        const char *ivarName = ivar_getName(ivarList[i]);
        [ivars addObject:[NSString stringWithUTF8String:ivarName]];
    }
    
    free(ivarList);
    return ivars;
}

+ (nullable id)callMethod:(NSString *)methodName
                   onObject:(id)object
              withArguments:(nullable NSArray *)arguments
                     error:(NSError **)error {
    SEL selector = NSSelectorFromString(methodName);
    
    if (![object respondsToSelector:selector]) {
        if (error) {
            *error = [NSError errorWithDomain:@"RuntimeBridge"
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Method not found"}];
        }
        return nil;
    }
    
    NSMethodSignature *signature = [object methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:object];
    [invocation setSelector:selector];
    
    if (arguments) {
        for (NSUInteger i = 0; i < arguments.count && i < signature.numberOfArguments - 2; i++) {
            id arg = arguments[i];
            [invocation setArgument:&arg atIndex:(NSInteger)(i + 2)];
        }
    }
    
    [invocation invoke];
    
    const char *returnType = signature.methodReturnType;
    if (strcmp(returnType, @encode(void)) == 0) {
        return nil;
    }
    
    id returnValue = nil;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

+ (BOOL)respondsToSelector:(NSString *)selectorString onObject:(id)object {
    SEL selector = NSSelectorFromString(selectorString);
    return [object respondsToSelector:selector];
}

+ (nullable NSString *)getSuperclassOfClass:(NSString *)className {
    Class cls = NSClassFromString(className);
    if (!cls) {
        return nil;
    }
    
    Class superclass = class_getSuperclass(cls);
    return superclass ? NSStringFromClass(superclass) : nil;
}

+ (NSArray<NSString *> *)getClassHierarchyForClass:(NSString *)className {
    NSMutableArray<NSString *> *hierarchy = [NSMutableArray array];
    Class cls = NSClassFromString(className);
    
    if (!cls) {
        return hierarchy;
    }
    
    while (cls) {
        [hierarchy addObject:NSStringFromClass(cls)];
        cls = class_getSuperclass(cls);
    }
    
    return hierarchy;
}

+ (nullable NSString *)getTypeEncodingForProperty:(NSString *)propertyName
                                          inClass:(NSString *)className
                                            error:(NSError **)error {
    Class cls = NSClassFromString(className);
    if (!cls) {
        if (error) {
            *error = [NSError errorWithDomain:@"RuntimeBridge"
                                         code:2
                                     userInfo:@{NSLocalizedDescriptionKey: @"Class not found"}];
        }
        return nil;
    }
    
    objc_property_t property = class_getProperty(cls, [propertyName UTF8String]);
    if (!property) {
        if (error) {
            *error = [NSError errorWithDomain:@"RuntimeBridge"
                                         code:3
                                     userInfo:@{NSLocalizedDescriptionKey: @"Property not found"}];
        }
        return nil;
    }
    
    const char *attributes = property_getAttributes(property);
    return [NSString stringWithUTF8String:attributes];
}

@end



