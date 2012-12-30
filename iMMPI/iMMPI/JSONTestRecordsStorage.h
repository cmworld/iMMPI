//
//  JSONTestRecordsStorage.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark JSONTestRecordsStorage interface

/*! An implementation of TestRecordStorage which stores each TestRecord object in JSON format in a separate file in Documents directory.
 */
@interface JSONTestRecordsStorage : NSObject<TestRecordStorage>

/*! This method serializes the testRecord object in JSON format and saves it to disk. The file name is selected depending on the test record data and if the file with the same name already exists, it is not overwritten, and a new file name is selected to save the record.
 
 @param testRecord A TestRecord object to be added to the storage.
 
 @return YES if the record has been added to storage, NO otherwise.
 */
- (BOOL) addNewTestRecord: (id<TestRecord>) testRecord;



/*! This method serializes the testRecord object in JSON format ans saves it to disk. The test record file is overwritten as the result of this operation.
 
 If the record does not yet exist in storage, this method does nothing and returns NO.
 
 @param testRecord A TestRecord object to be updated in the persistent storage.
 
 @return YES if the record exists in storage and has been successfully updated. NO if update failed or record does not exist.
 */
- (BOOL) updateTestRecord: (id<TestRecord>) testRecord;



/*! This method loads all JSON test record files and parses these into TestRecord objects.
 
 @return YES if operation succeeded, NO otherwise.
 */
- (BOOL) loadStoredTestRecords;



/*! This method returns all test records currently loaded.
 
 This method does create a new NSArray instance with the list of test records currently loaded, so it should not be called too often for performance reasons.
 
 @return An array of TestRecord objects.
 */
- (NSArray *) allTestRecords;

@end
