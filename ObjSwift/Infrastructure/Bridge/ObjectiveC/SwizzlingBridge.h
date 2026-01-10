//
//  SwizzlingBridge.h
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwizzlingBridge : NSObject

+ (BOOL)swizzleInstanceMethod:(NSString *)originalSelector
            withSwizzledSelector:(NSString *)swizzledSelector
                       inClass:(NSString *)className
                         error:(NSError **)error;

+ (BOOL)swizzleClassMethod:(NSString *)originalSelector
       withSwizzledSelector:(NSString *)swizzledSelector
                    inClass:(NSString *)className
                      error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END



