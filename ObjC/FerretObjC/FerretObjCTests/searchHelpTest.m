//
//  searchHelpTest.m
//  FerretObjC
//
//  Created by Andrew(Zhiyong) Yang on 1/14/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FSearch+testHelper.h"

#define INDEX_FOLDER @"index_folder"
@interface searchHelpTest : XCTestCase

@end

@implementation searchHelpTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // create folder
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:INDEX_FOLDER isDirectory:&isDir])
        if(![fileManager createDirectoryAtPath:INDEX_FOLDER withIntermediateDirectories:YES attributes:nil error:NULL])
            NSLog(@"Error: Create folder failed %@", INDEX_FOLDER);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [FSearch testInFolder:INDEX_FOLDER];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
