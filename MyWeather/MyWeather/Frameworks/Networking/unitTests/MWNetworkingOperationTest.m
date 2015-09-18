//
// MWNetworkingOperationTest.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MWNetworkingOperation.h"
#import "MWNetworkingConfiguration.h"

@interface MWNetworkingOperation (UnitTesting)
- (void)startOperation;
- (void)finishOperation;
- (void)cancelOperation;
- (void)startNetworkRequestWithSessionManager;
- (NSOperationQueue *)serialOperationQueue;
- (BOOL)operationFinished;
- (BOOL)operationExecuting;
- (BOOL)shouldCancel;
- (void)setOperationExecuting:(BOOL)value;
- (void)setConfiguration:(id)configuration;

@property (nonatomic, strong) NSOperationQueue *serialOperationQueue;

@end

@interface MWNetworkingOperationTest : XCTestCase

@end

@implementation MWNetworkingOperationTest

- (void)setUp
{
	[super setUp];
	// Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

- (void)testPerformanceExample
{
	// This is an example of a performance test case.
	[self measureBlock: ^{
	    // Put the code you want to measure the time of here.
	}];
}

#pragma mark - Init
- (void)testInit
{
	MWNetworkingOperation *operation = [[MWNetworkingOperation alloc] init];

	XCTAssertNotNil([operation serialOperationQueue]);
	XCTAssertFalse([operation operationFinished]);
	XCTAssertFalse([operation operationExecuting]);
	XCTAssertEqual([[operation serialOperationQueue] maxConcurrentOperationCount], 1);
}



#pragma mark - start
- (void)testStart
{
	id operationPartialMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);
	MWNetworkingOperation *operation = (MWNetworkingOperation *)operationPartialMock;

	operation.serialOperationQueue = OCMPartialMock(operation.serialOperationQueue);
	id serialOperationPartialMock = operation.serialOperationQueue;

	OCMStub([operationPartialMock startOperation]);

	// Creo el block de invocacion para sobrescribir el operationqueue

	void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
		void (^passedBlock)();

		// El tercer param es el block que paso en el metodo
		// PAram 0 es self
		// Param 1 es _cmd
		// Param >=2 son los parametros que recibe la invocacion

		[invocation getArgument:&passedBlock atIndex:2];
		passedBlock();
	};

	// Sobrescribo el addOperationWithBlock con mi block custom
	[[[serialOperationPartialMock stub] andDo:proxyBlock] addOperationWithBlock:[OCMArg any]];

	// Llamo al start
	[operation start];

	// Verifico que se agrego en la cola del NSOperationQueue
	OCMVerify([serialOperationPartialMock addOperationWithBlock:[OCMArg any]]);
	// Verifico que se llamo al startOperation
	OCMVerify([operationPartialMock startOperation]);
}

#pragma mark - startOperation
- (void)testStartOperationIsExecutingTrue
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	OCMStub([assertionHandlerMock currentHandler]).andReturn(assertionHandlerMock);
	[OCMStub([assertionHandlerMock handleFailureInMethod:NULL object:OCMOCK_ANY file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY])andDo: ^(NSInvocation *invocation) {
	    NSLog(@"Que pasa aca");
	}];

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[[operationMock expect] andReturnValue:@YES] isExecuting];
	[[operationMock reject] isCancelled];

	[[[operationMock stub] andReturnValue:@YES] isExecuting];

	[operationMock startOperation];

	[operationMock verify];
}

- (void)testStartOperationNotExecutingAndCancelled
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	OCMStub([assertionHandlerMock currentHandler]).andReturn(assertionHandlerMock);
	[OCMStub([assertionHandlerMock handleFailureInMethod:NULL object:OCMOCK_ANY file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY])andDo: ^(NSInvocation *invocation) {
	    NSLog(@"Que pasa aca");
	}];

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[[operationMock expect] andReturnValue:@NO] isExecuting];
	[[[operationMock expect] andReturnValue:@YES] isCancelled];
	[[operationMock expect] finishOperation];

	[[[operationMock stub] andReturnValue:@NO] isExecuting];
	[[[operationMock stub] andReturnValue:@YES] isCancelled];
	[[operationMock stub] finishOperation];

	[operationMock startOperation];

	[operationMock verify];
}

- (void)testStartOperationNotExecutingAndNotCancelledShouldCancelTrue
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	OCMStub([assertionHandlerMock currentHandler]).andReturn(assertionHandlerMock);
	OCMStub([assertionHandlerMock handleFailureInMethod:NULL object:OCMOCK_ANY file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY]);

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[operationMock expect] willChangeValueForKey:@"isExecuting"];
	[[operationMock expect] didChangeValueForKey:@"isExecuting"];
	[[operationMock expect] setOperationExecuting:YES];
	[[[operationMock expect] andReturnValue:@YES] shouldCancel];
	[[operationMock reject] startNetworkRequestWithSessionManager];
	[[operationMock expect] cancelOperation];

	[[[operationMock stub] andReturnValue:@NO] isExecuting];
	[[[operationMock stub] andReturnValue:@NO] isCancelled];
	[[[operationMock stub] andReturnValue:@YES] shouldCancel];
	[[operationMock stub] willChangeValueForKey:OCMOCK_ANY];
	[[operationMock stub] didChangeValueForKey:OCMOCK_ANY];
	[[operationMock stub] setOperationExecuting:0];
	[[operationMock stub] cancelOperation];
	[[operationMock stub] startNetworkRequestWithSessionManager];

	[operationMock startOperation];

	[operationMock verify];
}

- (void)testStartOperationNotExecutingAndNotCancelledShouldCancelFalse
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	OCMStub([assertionHandlerMock currentHandler]).andReturn(assertionHandlerMock);
	OCMStub([assertionHandlerMock handleFailureInMethod:NULL object:OCMOCK_ANY file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY]);

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[operationMock expect] willChangeValueForKey:@"isExecuting"];
	[[operationMock expect] didChangeValueForKey:@"isExecuting"];
	[[operationMock expect] setOperationExecuting:YES];
	[[[operationMock expect] andReturnValue:@NO] shouldCancel];
	[[operationMock expect] startNetworkRequestWithSessionManager];
	[[operationMock reject] cancelOperation];

	[[[operationMock stub] andReturnValue:@NO] isExecuting];
	[[[operationMock stub] andReturnValue:@NO] isCancelled];
	[[[operationMock stub] andReturnValue:@NO] shouldCancel];
	[[operationMock stub] willChangeValueForKey:OCMOCK_ANY];
	[[operationMock stub] didChangeValueForKey:OCMOCK_ANY];
	[[operationMock stub] setOperationExecuting:0];
	[[operationMock stub] startNetworkRequestWithSessionManager];

	[operationMock startOperation];

	[operationMock verify];
}

#pragma mark - cancelOperation

#pragma mark - finishOperation

#pragma mark - startNetworkRequestWithSessionManager

#pragma mark - configuration

- (void)testSetConfigurationOnExecutingOperation
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	[[[assertionHandlerMock stub] andReturn:assertionHandlerMock] currentHandler];
	[[assertionHandlerMock stub] handleFailureInFunction:NULL file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY];

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	id newConfigMock = OCMStrictClassMock([MWNetworkingConfiguration class]);

	[[[operationMock stub]andReturnValue:@YES] isExecuting];
	[[[operationMock stub]andReturnValue:@NO] isFinished];
	[[[operationMock stub]andReturnValue:@NO] isCancelled];
	[[[newConfigMock stub] andReturn:newConfigMock] copy];

	[operationMock setConfiguration:newConfigMock];

	id copiedConfig = [operationMock valueForKeyPath:@"_configuration"];

	XCTAssertNil(copiedConfig);

	[operationMock verify];
	[newConfigMock verify];
}

- (void)testSetConfigurationOnFinishedOperation
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	[[[assertionHandlerMock stub] andReturn:assertionHandlerMock] currentHandler];
	[[assertionHandlerMock stub] handleFailureInFunction:NULL file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY];

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	id newConfigMock = OCMStrictClassMock([MWNetworkingConfiguration class]);

	[[[operationMock stub]andReturnValue:@NO] isExecuting];
	[[[operationMock stub]andReturnValue:@YES] isFinished];
	[[[operationMock stub]andReturnValue:@NO] isCancelled];
	[[[newConfigMock stub] andReturn:newConfigMock] copy];

	[operationMock setConfiguration:newConfigMock];

	id copiedConfig = [operationMock valueForKeyPath:@"_configuration"];

	XCTAssertNil(copiedConfig);

	[operationMock verify];
	[newConfigMock verify];
}

- (void)testSetConfigurationOnCancelledOperation
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	[[[assertionHandlerMock stub] andReturn:assertionHandlerMock] currentHandler];
	[[assertionHandlerMock stub] handleFailureInFunction:NULL file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY];

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	id newConfigMock = OCMStrictClassMock([MWNetworkingConfiguration class]);

	[[[operationMock stub]andReturnValue:@NO] isExecuting];
	[[[operationMock stub]andReturnValue:@NO] isFinished];
	[[[operationMock stub]andReturnValue:@YES] isCancelled];
	[[[newConfigMock stub] andReturn:newConfigMock] copy];

	[operationMock setConfiguration:newConfigMock];

	id copiedConfig = [operationMock valueForKeyPath:@"_configuration"];

	XCTAssertNil(copiedConfig);

	[operationMock verify];
	[newConfigMock verify];
}

- (void)testSetConfigurationOnFinishedAndCancelledOperation
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	[[[assertionHandlerMock stub] andReturn:assertionHandlerMock] currentHandler];
	[[assertionHandlerMock stub] handleFailureInFunction:NULL file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY];

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	id newConfigMock = OCMStrictClassMock([MWNetworkingConfiguration class]);

	[[[operationMock stub]andReturnValue:@NO] isExecuting];
	[[[operationMock stub]andReturnValue:@YES] isFinished];
	[[[operationMock stub]andReturnValue:@YES] isCancelled];
	[[[newConfigMock stub] andReturn:newConfigMock] copy];

	[operationMock setConfiguration:newConfigMock];

	id copiedConfig = [operationMock valueForKeyPath:@"_configuration"];

	XCTAssertNil(copiedConfig);

	[operationMock verify];
	[newConfigMock verify];
}

- (void)testSetConfigurationOnFinishedCancelledAndExecutingOperation
{
	id assertionHandlerMock = OCMClassMock([NSAssertionHandler class]);
	[[[assertionHandlerMock stub] andReturn:assertionHandlerMock] currentHandler];
	[[assertionHandlerMock stub] handleFailureInFunction:NULL file:OCMOCK_ANY lineNumber:0 description:OCMOCK_ANY];

	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	id newConfigMock = OCMStrictClassMock([MWNetworkingConfiguration class]);

	[[[operationMock stub]andReturnValue:@YES] isExecuting];
	[[[operationMock stub]andReturnValue:@YES] isFinished];
	[[[operationMock stub]andReturnValue:@YES] isCancelled];
	[[[newConfigMock stub] andReturn:newConfigMock] copy];

	[operationMock setConfiguration:newConfigMock];

	id copiedConfig = [operationMock valueForKeyPath:@"_configuration"];

	XCTAssertNil(copiedConfig);

	[operationMock verify];
	[newConfigMock verify];
}

- (void)testSetConfigurationOk
{
	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	id newConfigMock = OCMStrictClassMock([MWNetworkingConfiguration class]);

	[[[operationMock stub]andReturnValue:@NO] isExecuting];
	[[[operationMock stub]andReturnValue:@NO] isFinished];
	[[[operationMock stub]andReturnValue:@NO] isCancelled];
	[[[newConfigMock stub] andReturn:newConfigMock] copy];

	[operationMock setConfiguration:newConfigMock];

	id copiedConfig = [operationMock valueForKeyPath:@"_configuration"];

	XCTAssertEqualObjects(newConfigMock, copiedConfig);

	[operationMock verify];
	[newConfigMock verify];
}

- (void)testConfigCopyOnGetConfiguration
{
	// create a mock for the user defaults and make sure it's used
	id configMock = OCMPartialMock([[MWNetworkingConfiguration alloc] init]);

	id configMockCopy = OCMPartialMock([[MWNetworkingConfiguration alloc] init]);

	MWNetworkingOperation *netOperation = [[MWNetworkingOperation alloc] init];

	[netOperation setValue:configMock forKeyPath:@"_configuration"];

	OCMStub([configMock copy]).andReturn(configMockCopy);

	MWNetworkingConfiguration *configCopy = [netOperation configuration];

	XCTAssertEqual(configCopy, configMockCopy);

	OCMVerify([configMock copy]);

	// XCTAssertEqual(configCopy, operation.configuration);
}

#pragma mark - shouldCancel

/*
   BOOL shouldCancel = [self isCancelled];

   for (NSOperation * operation in self.dependencies){
   shouldCancel |= [operation isCancelled];
   }
   if (shouldCancel){
   [self cancelOperation];
   }
   return shouldCancel;
 */

- (void)testShouldCancelledMethodNotCancelledAndNoDependencies
{
	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[[operationMock stub] andReturnValue:@NO] isCancelled];
	[[[operationMock stub] andReturn:[NSArray array]] dependencies];

	BOOL shouldCancelValue = [operationMock shouldCancel];

	[operationMock verify];

	XCTAssertFalse(shouldCancelValue);
}

- (void)testShouldCancelledMethodNotCancelledAndNoDependenciesCancelled
{
	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[[operationMock stub] andReturnValue:@NO] isCancelled];

	NSMutableArray *dependenciesMocks = [NSMutableArray array];

	// Creo 10 dependencies
	for (int i = 0; i < 10; i++) {
		id dependencyMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);
		[[[dependencyMock stub] andReturnValue:@NO] isCancelled];

		[dependenciesMocks addObject:dependencyMock];
	}

	[[[operationMock stub] andReturn:dependenciesMocks] dependencies];

	BOOL shouldCancelValue = [operationMock shouldCancel];

	[operationMock verify];

	XCTAssertFalse(shouldCancelValue);
}

- (void)testShouldCancelMethodIsCancelled
{
	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[[operationMock stub] andReturnValue:@YES] isCancelled];
	[[operationMock reject] dependencies];

	BOOL shouldCancelValue = [operationMock shouldCancel];

	XCTAssertTrue(shouldCancelValue);
}

- (void)testShouldCancelMethodNotCancelledWithDependenciesOneCancelled
{
	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[[operationMock expect] andReturnValue:@NO] isCancelled];
	[[[operationMock stub] andReturnValue:@NO] isCancelled];

	NSMutableArray *dependenciesMocks = [NSMutableArray array];

	// Creo 10 dependencies

	for (int i = 0; i < 10; i++) {
		id dependencyMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

		if (i == 0) {
			[[[dependencyMock expect] andReturnValue:@YES] isCancelled];
			[[[dependencyMock stub] andReturnValue:@YES] isCancelled];
		} else {
			[[[dependencyMock reject] andReturnValue:@NO] isCancelled];
			[[[dependencyMock stub] andReturnValue:@NO] isCancelled];
		}

		[dependenciesMocks addObject:dependencyMock];
	}

	[[[operationMock stub] andReturn:dependenciesMocks] dependencies];

	BOOL shouldCancelValue = [operationMock shouldCancel];

	[operationMock verify];
	for (id dependency in dependenciesMocks) {
		[dependency verify];
	}

	XCTAssertTrue(shouldCancelValue);
}

- (void)testShouldCancelMethodNotCancelledWithDependenciesMoreThanOneCancelled
{
	id operationMock = OCMPartialMock([[MWNetworkingOperation alloc] init]);

	[[[operationMock expect] andReturnValue:@NO] isCancelled];
	[[[operationMock stub] andReturnValue:@NO] isCancelled];

	NSMutableArray *dependenciesMocks = [NSMutableArray array];

	// Creo 3 dependencies

	// LA primer dependency no esta cancelada entonces debería seguir
	id dependencyMock0 = OCMPartialMock([[MWNetworkingOperation alloc] init]);
	[[[dependencyMock0 expect] andReturnValue:@NO] isCancelled];
	[[[dependencyMock0 stub] andReturnValue:@NO] isCancelled];

	// La segunda dependency esta cancelada por lo que debería cortar aca
	id dependencyMock1 = OCMPartialMock([[MWNetworkingOperation alloc] init]);
	[[[dependencyMock1 expect] andReturnValue:@YES] isCancelled];
	[[[dependencyMock1 stub] andReturnValue:@YES] isCancelled];

	// Si la tercera dependency se intenta revisar al estar la segunda cancelada esta mal
	id dependencyMock2 = OCMPartialMock([[MWNetworkingOperation alloc] init]);
	[[[dependencyMock2 reject] andReturnValue:@YES] isCancelled];
	[[[dependencyMock2 stub] andReturnValue:@YES] isCancelled];

	[dependenciesMocks addObject:dependencyMock0];
	[dependenciesMocks addObject:dependencyMock1];
	[dependenciesMocks addObject:dependencyMock2];

	[[[operationMock stub] andReturn:dependenciesMocks] dependencies];

	BOOL shouldCancelValue = [operationMock shouldCancel];

	[operationMock verify];
	for (id dependency in dependenciesMocks) {
		[dependency verify];
	}

	XCTAssertTrue(shouldCancelValue);
}

@end
