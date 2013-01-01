//
//  RecordsListViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "RecordsListViewController.h"
#import "EditTestRecordViewController.h"
#import "TestAnswersViewController.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kRecordCellIdentifier = @"com.immpi.cells.record";

static NSString * const kSegueAddRecord   = @"com.immpi.segue.addRecord";
static NSString * const kSegueEditRecord  = @"com.immpi.segue.editRecord";
static NSString * const kSegueEditAnswers = @"com.immpi.segue.editAnswers";


#pragma mark -
#pragma mark RecordsListViewController private

@interface RecordsListViewController()<EditTestRecordViewControllerDelegate>
{
    NSDateFormatter *_dateFormatter;
}

@end


#pragma mark -
#pragma mark RecordsListViewController implementation

@implementation RecordsListViewController

#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}


#pragma mark -
#pragma mark view lifecycle

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    if (_model == nil) _model = [TestRecordModelByDate new];
    
    // We do init storage here since if the view never appears
    // there is no sense loading the records anyway.
    //
    // Once the storage has been initialized, this method does
    // nothing.
    [self initStorageInBackgroundIfNeeded];
}


#pragma mark -
#pragma mark navigation

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Creating a new test record
    if ([segue.identifier isEqualToString: kSegueAddRecord])
    {
        EditTestRecordViewController *controller =
        (id)[segue.destinationViewController viewControllers][0];
        
        FRB_AssertClass(controller, EditTestRecordViewController);
        
        controller.delegate = self;
        controller.record   = [TestRecord new];
        controller.title    = ___New_Record;
    }
    
    // Editing existing test record
    else if ([segue.identifier isEqualToString: kSegueEditRecord])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        
        id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(record, TestRecordProtocol);
        
        
        EditTestRecordViewController *controller =
        (id)[segue.destinationViewController viewControllers][0];
        FRB_AssertClass(controller, EditTestRecordViewController);
        
        
        controller.delegate = self;
        controller.title    = ___Edit_Record;
        controller.record   = record;
    }
    
    // Editing test answers for a record
    else if ([segue.identifier isEqualToString: kSegueEditAnswers])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        
        id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(record, TestRecordProtocol);
        
        
        TestAnswersViewController *controller =
        (id)[segue.destinationViewController viewControllers][0];
        FRB_AssertClass(controller, TestAnswersViewController);
        
        
        controller.record  =   record;
        controller.storage = _storage;
    }
}


#pragma mark -
#pragma mark private

- (void) initStorageInBackgroundIfNeeded
{
    if (_storage == nil)
    {
        _storage = [JSONTestRecordsStorage new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_storage loadStoredTestRecords];
            NSArray *allRecords = [_storage allTestRecords];
            
            if (allRecords.count > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_model addObjectsFromArray: allRecords];
                    [self.tableView reloadData];
                });
            }
        });
    }
}


- (NSString *) abbreviatePersonName: (NSString *) name
{
    NSArray *components = [name componentsSeparatedByCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (components.count == 0) return nil;
    
    NSMutableArray *abbreviated = [NSMutableArray array];
    
    [abbreviated addObject: components[0]];
    
    if (components.count > 1)
    {
        for (NSUInteger i = 1; i < components.count; ++i)
        {
            NSString *component = components[i];
            
            if (component.length > 0)
                [abbreviated addObject:
                 [NSString stringWithFormat: @"%@.",
                 [[component substringToIndex: 1] uppercaseString]]];
        }
    }
    
    return [abbreviated componentsJoinedByString: @" "];
}


#pragma mark -
#pragma mark UITableViewDelegate

     - (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    id sender = [tableView cellForRowAtIndexPath: indexPath];
    
    [self performSegueWithIdentifier: kSegueEditAnswers
                              sender: sender];
}


#pragma mark - 
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return [_model numberOfSections];
}


- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return [_model numberOfRowsInSection: section];
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kRecordCellIdentifier];
    FRB_AssertNotNil(cell);
    
    id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    cell.textLabel.text       = [self abbreviatePersonName: record.person.name];
    cell.detailTextLabel.text = [_dateFormatter stringFromDate: record.date];
    
    return cell;
}


#pragma mark -
#pragma mark EditTestRecordViewControllerDelegate

- (void) editTestRecordViewController: (EditTestRecordViewController *) controller
               didFinishEditingRecord: (id<TestRecordProtocol>) record
{
    [self dismissViewControllerAnimated: YES
                             completion: nil];
    
    if (record != nil)
    {
        if ([_storage containsTestRecord: record])
        {
            [_model       updateObject: record];
            [_storage updateTestRecord: record];
        }
        else
        {
            [_model       addNewObject: record];
            [_storage addNewTestRecord: record];
        }
        
        [self.tableView reloadData];
    }
}

@end
