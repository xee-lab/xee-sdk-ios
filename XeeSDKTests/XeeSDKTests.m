/*
 * Copyright 2016 Eliocity
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <XCTest/XCTest.h>
@import XeeSDK;

@interface XeeSDKTests : XCTestCase

@end

@implementation XeeSDKTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    XeeConfig *config = [[XeeConfig alloc] init];
    config.secretKey = @"6xEj7PAIPOChvOkTEcGH";
    config.clientID = @"5IOeWPhCzg95QYM3jFBz";
    config.redirectURI = @"xeexee://foo";
    config.scopes = @[
                      @"users_read",
                      @"cars_read",
                      @"trips_read",
                      @"signals_read",
                      @"locations_read",
                      @"status_read"
                      ];
    config.environment = XeeEnvironmentSANDBOX;
    [[Xee connectManager] setConfig:config];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testCreateHTTPBodyWithParams {
    NSData *data = [[XeeHTTPClient client] createHTTPBodyWithDictionary:@{@"key1":@"value1",
                                                                          @"key2":@"value2"}];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    XCTAssertTrue([string isEqualToString:@"key1=value1&key2=value2"]);
}

-(void)testCar {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    [[[Xee requestManager] cars] carWithCarId:9 completionHandler:^(XeeCar *car, NSArray<XeeError *> *errors) {
        XCTAssertNil(errors);
        XCTAssertNotNil(car);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"Expectation timeout error: %@", error);
    }];
}

-(void)testCarStatus {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    [[[Xee requestManager] cars] statusWithCarId:9 completionHandler:^(XeeCarStatus *carStatus, NSArray<XeeError *> *errors) {
        XCTAssertNil(errors);
        XCTAssertNotNil(carStatus.accelerometer);
        XCTAssertNotNil(carStatus.location);
        XCTAssertTrue(carStatus.signals.count > 0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"Expectation timeout error: %@", error);
    }];
    
}

@end
