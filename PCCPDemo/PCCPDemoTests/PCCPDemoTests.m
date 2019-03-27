//
//  PCCPDemoTests.m
//  PCCPDemoTests
//
//  Created by Dwarven on 2019/3/27.
//  Copyright © 2019 Dwarven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PCCPViewController.h"

@interface PCCPDemoTests : XCTestCase

@end

@implementation PCCPDemoTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    id info = [PCCPViewController infoForPhoneCode:86];
    XCTAssertEqual(info && [info isKindOfClass:[NSDictionary class]], YES);
    XCTAssertEqual([info[@"country_cn"] isEqualToString:@"中国"], YES);
    XCTAssertEqual([info[@"country_en"] isEqualToString:@"China"], YES);
    XCTAssertEqual([info[@"country_code"] isEqualToString:@"CN"], YES);
}

@end
