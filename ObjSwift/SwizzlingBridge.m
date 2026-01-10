//
//  SwizzlingBridge.m
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

#import "SwizzlingBridge.h"

@implementation SwizzlingBridge

+ (BOOL)swizzleInstanceMethod:(NSString *)originalSelector
            withSwizzledSelector:(NSString *)swizzledSelector
                       inClass:(NSString *)className
                         error:(NSError **)error {
    Class cls = NSClassFromString(className);
    if (!cls) {
        if (error) {
            *error = [NSError errorWithDomain:@"SwizzlingBridge"
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Class not found"}];
        }
        return NO;
    }
    
    SEL originalSel = NSSelectorFromString(originalSelector);
    SEL swizzledSel = NSSelectorFromString(swizzledSelector);
    
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSel);
    
    if (!originalMethod || !swizzledMethod) {
        if (error) {
            *error = [NSError errorWithDomain:@"SwizzlingBridge"
                                         code:2
                                     userInfo:@{NSLocalizedDescriptionKey: @"Method not found"}];
        }
        return NO;
    }
    
    BOOL didAddMethod = class_addMethod(cls,
                                       originalSel,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                           swizzledSel,
                           method_getImplementation(originalMethod),
                           method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

+ (BOOL)swizzleClassMethod:(NSString *)originalSelector
       withSwizzledSelector:(NSString *)swizzledSelector
                    inClass:(NSString *)className
                      error:(NSError **)error {
    Class cls = NSClassFromString(className);
    if (!cls) {
        if (error) {
            *error = [NSError errorWithDomain:@"SwizzlingBridge"
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Class not found"}];
        }
        return NO;
    }
    
    SEL originalSel = NSSelectorFromString(originalSelector);
    SEL swizzledSel = NSSelectorFromString(swizzledSelector);
    
    Method originalMethod = class_getClassMethod(cls, originalSel);
    Method swizzledMethod = class_getClassMethod(cls, swizzledSel);
    
    if (!originalMethod || !swizzledMethod) {
        if (error) {
            *error = [NSError errorWithDomain:@"SwizzlingBridge"
                                         code:2
                                     userInfo:@{NSLocalizedDescriptionKey: @"Method not found"}];
        }
        return NO;
    }
    
    BOOL didAddMethod = class_addMethod(object_getClass(cls),
                                       originalSel,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(object_getClass(cls),
                           swizzledSel,
                           method_getImplementation(originalMethod),
                           method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

@end

