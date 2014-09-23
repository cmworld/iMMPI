//
//  UtilityFunctions.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "UtilityFunctions.h"


id nil2Null(id object)
{
    if (object != nil) return object;
    else return [NSNull null];
}


id null2Nil(id object)
{
    if (![object isKindOfClass: [NSNull class]]) return object;
    else return nil;
}


UIViewController *SelfOrFirstChild(UIViewController *controller)
{
    if ([controller isKindOfClass: [UINavigationController class]])
        return [(id)controller viewControllers][0];
    else
        return controller;
}


NSString *TransliterateToLatin(NSString *string)
{
    if (string.length > 0)
    {
        NSMutableString *mutable = [string mutableCopy];
        CFMutableStringRef mutableRef = (__bridge CFMutableStringRef)mutable;
        CFStringTransform(mutableRef, NULL, kCFStringTransformToLatin, false);
        CFStringTransform(mutableRef, NULL, kCFStringTransformStripCombiningMarks,  false);
        
        return [mutable copy];
    }
    else return nil;
}