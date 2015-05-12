//
//  LSDCoreDataHelpersTests.m
//  LSDCoreDataHelpersTests
//
//  Created by nsleader on 05/07/2015.
//  Copyright (c) 2014 nsleader. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LSDCoreDataHelpers/LSDCoreDataStack.h>
#import <LSDCoreDataHelpers/NSManagedObject+Helper.h>
#import "TestEntity.h"


@protocol LSDCoreDataStackProtocolTests <LSDCoreDataStackProtocol>

- (NSString *)modelName;

@end


@interface Tests : XCTestCase

@property (nonatomic) id<LSDCoreDataStackProtocolTests> coreDataStak;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    self.coreDataStak = (id<LSDCoreDataStackProtocolTests>)[LSDCoreDataStack new];
    [self.coreDataStak setupWithModelName:@"TestModel"];
    [self.coreDataStak info];
}

- (void)testCoreDataStack
{
    XCTAssertNotNil([_coreDataStak mainCtx]);
    XCTAssertNotNil([_coreDataStak backgroundCtx]);
}

- (void)testContextType
{
    XCTAssertEqual([_coreDataStak mainCtx].concurrencyType, NSMainQueueConcurrencyType);
    XCTAssertEqual([_coreDataStak backgroundCtx].concurrencyType, NSPrivateQueueConcurrencyType);
}

- (void)testModelName
{
    XCTAssertEqualObjects([_coreDataStak modelName], @"TestModel");
}

- (void)testManagedObject
{
    TestEntity *mo = [TestEntity createInContext:[_coreDataStak mainCtx]];
    XCTAssertNotNil(mo);
    XCTAssert([mo isMemberOfClass:[TestEntity class]]);
    XCTAssert([mo isKindOfClass:[NSManagedObject class]]);
    XCTAssertEqualObjects(mo.managedObjectContext, [_coreDataStak mainCtx]);
}

@end
