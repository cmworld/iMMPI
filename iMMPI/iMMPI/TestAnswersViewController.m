//
//  TestAnswersViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestAnswersViewController.h"
#import "Questionnaire.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kAnswerCellIdentifier = @"AnswerCell";


#pragma mark -
#pragma mark TestAnswersViewController private

@interface TestAnswersViewController ()
{
    Questionnaire *_questionnaire;
}

@end


#pragma mark -
#pragma mark TestAnswersViewController implementation

@implementation TestAnswersViewController

#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _questionnaire = [Questionnaire newForGender: GenderMale
                                            ageGroup: AgeGroupAdult];
    }
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return 10;
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kAnswerCellIdentifier];
    FRB_AssertNotNil(cell);
    
    return cell;
}

@end
