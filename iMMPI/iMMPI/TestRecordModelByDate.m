//
//  TestRecordModelByDate.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestRecordModelByDate.h"


#pragma mark -
#pragma mark TestRecordModelByDate private

@interface TestRecordModelByDate()
{
    NSMutableArray *_records;
}

@end


#pragma mark -
#pragma mark TestRecordModelByDate implementation

@implementation TestRecordModelByDate

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _records = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark MutableTableViewModel

- (NSUInteger) numberOfSections
{
    return 1;
}


- (NSUInteger) numberOfRowsInSection: (NSUInteger) section
{
    return _records.count;
}


- (id<TestRecordProtocol>) objectAtIndexPath: (NSIndexPath *) indexPath
{
    return _records[indexPath.row];
}


- (void) addObjectsFromArray: (NSArray *) array
{
    [_records addObjectsFromArray: array];
    [self sortRecords];
}


- (BOOL) addNewObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    
    [_records addObject: object];
    [self sortRecords];
    
    return YES;
}


- (BOOL) updateObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    
    NSUInteger index = [_records indexOfObject: object];
    
    if (index != NSNotFound)
    {
        [self sortRecords];
        return YES;
    }
    else return NO;
}


#pragma mark -
#pragma mark private 

- (void) sortRecords
{
    [_records sortUsingDescriptors:
     @[[NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO]]];
}

@end
