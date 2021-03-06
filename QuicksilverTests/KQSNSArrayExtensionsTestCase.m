//
//  KQSNSArrayExtensionsTestCase.m
//  QuicksilverTests-iOS
//
//  Created by William Towe on 3/8/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <XCTest/XCTest.h>

#import <Quicksilver/NSArray+KQSExtensions.h>

@interface KQSNSArrayExtensionsTestCase : XCTestCase

@end

@implementation KQSNSArrayExtensionsTestCase

- (void)testEach {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@2,@3,@4];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [begin KQS_each:^(NSNumber *object, NSInteger index) {
        [temp addObject:@(object.integerValue + 1)];
    }];
    
    XCTAssertEqualObjects(temp, end);
}
- (void)testFilter {
    NSArray *begin = @[@1,@2,@3,@4];
    NSArray *end = @[@2,@4];
    
    XCTAssertEqualObjects([begin KQS_filter:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testReject {
    NSArray *begin = @[@1,@2,@3,@4];
    NSArray *end = @[@1,@3];
    
    XCTAssertEqualObjects([begin KQS_reject:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFind {
    NSArray *begin = @[@1,@2,@3];
    NSNumber *end = @2;
    
    XCTAssertEqualObjects([begin KQS_find:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFindWithIndex {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@2,@1];
    
    XCTAssertEqualObjects([begin KQS_findWithIndex:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testMap {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@"1",@"2",@"3"];
    
    XCTAssertEqualObjects([begin KQS_map:^id(NSNumber *object, NSInteger index) {
        return object.stringValue;
    }], end);
}
- (void)testReduce {
    NSArray *begin = @[@[@1],@[@2],@[@3]];
    NSArray *end = @[@1,@2,@3];
    
    XCTAssertEqualObjects([begin KQS_reduceWithStart:[[NSMutableArray alloc] init] block:^id(NSMutableArray *sum, NSArray *object, NSInteger index) {
        [sum addObjectsFromArray:object];
        return sum;
    }], end);
}
- (void)testFlatten {
    NSArray *begin = @[@[@1],@[@2],@[@3]];
    NSArray *end = @[@1,@2,@3];
    
    XCTAssertEqualObjects([begin KQS_flatten], end);
}
- (void)testFlattenMap {
    NSArray *begin = @[@[@1],@[@2],@[@3]];
    NSArray *end = @[@2,@3,@4];
    
    XCTAssertEqualObjects([begin KQS_flattenMap:^id _Nullable(NSNumber * _Nonnull object, NSInteger index) {
        return @(object.integerValue + 1);
    }], end);
}
- (void)testAny {
    NSArray *begin = @[@1,@3,@2];
    
    XCTAssertTrue([begin KQS_any:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = @[@1,@3,@5];
    
    XCTAssertFalse([begin KQS_any:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testAll {
    NSArray *begin = @[@2,@4,@6];
    
    XCTAssertTrue([begin KQS_all:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = @[@2,@4,@5];
    
    XCTAssertFalse([begin KQS_all:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testNone {
    NSArray *begin = @[@3,@5,@7];
    
    XCTAssertTrue([begin KQS_none:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = @[@3,@5,@6];
    
    XCTAssertFalse([begin KQS_none:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testTake {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@1,@2];
    
    XCTAssertEqualObjects([begin KQS_take:2], end);
    
    end = @[@1,@2,@3];
    
    XCTAssertEqualObjects([begin KQS_take:begin.count], end);
    
    XCTAssertEqualObjects([begin KQS_take:begin.count + 1], begin);
}
- (void)testTakeWhile {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@1,@2];
    
    XCTAssertEqualObjects([begin KQS_takeWhile:^BOOL(NSNumber *_Nonnull object, NSInteger index) {
        return object.integerValue < [begin.lastObject integerValue];
    }], end);
    
    end = @[@1,@2,@3];
    
    XCTAssertEqualObjects([begin KQS_takeWhile:^BOOL(NSNumber * _Nonnull object, NSInteger index) {
        return object.integerValue < [begin.lastObject integerValue] + 1;
    }], end);
}
- (void)testDrop {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@2,@3];
    
    XCTAssertEqualObjects([begin KQS_drop:1], end);
    
    end = @[];
    
    XCTAssertEqualObjects([begin KQS_drop:begin.count], end);
    
    XCTAssertEqualObjects([begin KQS_drop:begin.count + 1], end);
}
- (void)testDropWhile {
    NSArray *begin = @[@1,@2,@3];
    NSArray *end = @[@2,@3];
    
    XCTAssertEqualObjects([begin KQS_dropWhile:^BOOL(NSNumber * _Nonnull object, NSInteger index) {
        return object.integerValue < 2;
    }], end);
    
    end = @[];
    
    XCTAssertEqualObjects([begin KQS_dropWhile:^BOOL(NSNumber *_Nonnull object, NSInteger index) {
        return object.integerValue < [begin.lastObject integerValue] + 1;
    }], end);
}
- (void)testZip {
    NSArray *first = @[@1,@2];
    NSArray *second = @[@3,@4];
    NSArray *end = @[@[@1,@3],@[@2,@4]];
    
    XCTAssertEqualObjects([first KQS_zip:second], end);
    
    second = @[@3,@4,@5];
    
    XCTAssertEqualObjects([first KQS_zip:second], end);
}
- (void)testSum {
    NSArray *begin = @[@1,@2,@3];
    NSNumber *end = @6;
    
    XCTAssertEqualObjects([begin KQS_sum], end);
    
    begin = @[@1.0,@2.0,@3.0];
    end = @6.0;
    
    XCTAssertEqualObjects([begin KQS_sum], end);
    
    begin = @[[NSDecimalNumber decimalNumberWithString:@"1"],[NSDecimalNumber decimalNumberWithString:@"2"],[NSDecimalNumber decimalNumberWithString:@"3"]];
    end = [NSDecimalNumber decimalNumberWithString:@"6"];
    
    XCTAssertEqualObjects([begin KQS_sum], end);
}
- (void)testProduct {
    NSArray *begin = @[@2,@3,@4];
    NSNumber *end = @24;
    
    XCTAssertEqualObjects([begin KQS_product], end);
    
    begin = @[@2.0,@3.0,@4.0];
    end = @24.0;
    
    XCTAssertEqualObjects([begin KQS_product], end);
    
    begin = @[[NSDecimalNumber decimalNumberWithString:@"2"],[NSDecimalNumber decimalNumberWithString:@"3"],[NSDecimalNumber decimalNumberWithString:@"4"]];
    end = [NSDecimalNumber decimalNumberWithString:@"24"];
    
    XCTAssertEqualObjects([begin KQS_product], end);
}
- (void)testMaximum {
    NSArray *begin = @[@1,@3,@2];
    NSNumber *end = @3;
    
    XCTAssertEqualObjects([begin KQS_maximum], end);
}
- (void)testMinimum {
    NSArray *begin = @[@1,@-1,@2];
    NSNumber *end = @-1;
    
    XCTAssertEqualObjects([begin KQS_minimum], end);
}

@end
