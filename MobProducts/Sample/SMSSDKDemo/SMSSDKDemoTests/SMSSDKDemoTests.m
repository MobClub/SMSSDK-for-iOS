//
//  SMSSDKDemoTests.m
//  SMSSDKDemoTests
//
//  Created by youzu_Max on 2017/5/25.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+ContactFriends.h>

@interface SMSSDKDemoTests : XCTestCase

@end

#define SMSLog(s, ...) NSLog(@"\n\n---------------------------------------------------\n %s[line:%d] \n %@ \n---------------------------------------------------\n", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

@implementation SMSSDKDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

#pragma mark - 发送验证码

// 正常发送短信验证码
- (void)testSendCodeText
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeText"];
    
    [SMSSDK getVerificationCodeByMethod:0 phoneNumber:@"18021058213" zone:@"86" result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//正常发送语音验证码
- (void)testSendCodeVoice
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeVoice"];
    
    [SMSSDK getVerificationCodeByMethod:1 phoneNumber:@"18021058213" zone:@"86" result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//超过枚举值
- (void)testSendCodeNotMatchEnum
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeNotMatchEnum"];
    
    [SMSSDK getVerificationCodeByMethod:-100 phoneNumber:@"18021058213" zone:@"86" result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//电话号码是NSNumber
- (void)testSendCodeNSNumberTypePhone
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeNSNumberTypePhone"];
    
    [SMSSDK getVerificationCodeByMethod:0 phoneNumber:@18021058213 zone:@"86" result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//区号是NSNumber
- (void)testSendCodeNSNumberTypeZone
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeNSNumberTypeZone"];
    
    [SMSSDK getVerificationCodeByMethod:0 phoneNumber:@"18021058213" zone:@86 result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//区号是有 + 号
- (void)testSendCodeZonePlus
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeZonePlus"];
    
    [SMSSDK getVerificationCodeByMethod:0 phoneNumber:@"18021058213" zone:@"+86" result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//区号是随便写
- (void)testSendCodeZoneRandom
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeZoneRandom"];
    
    [SMSSDK getVerificationCodeByMethod:0 phoneNumber:@"18021058213" zone:@"+87" result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//区号是别的国家
- (void)testSendCodeZoneOther
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeZoneOtherZone"];
    
    [SMSSDK getVerificationCodeByMethod:0 phoneNumber:@"18021058213" zone:@"61" result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//无回调
- (void)testSendCodeNoBlock
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCodeNoBlock"];
    
    [SMSSDK getVerificationCodeByMethod:0 phoneNumber:@"18021058213" zone:@"+86" result:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//100次循环请求
- (void)testSendCode100times
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendCode100times"];
    
    __block NSInteger flag = 0;
    for (NSInteger i=0; i<100; i++)
    {
        [SMSSDK getVerificationCodeByMethod:0 phoneNumber:@"18021058213" zone:@"86" result:^(NSError *error) {
            
            SMSLog(@"%@",error);
            flag++;
            if (flag==99)
            {
                [expectation fulfill];
            }
        }];
    }
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

#pragma mark - 提交验证码

/*
 这个需要每次填写code,无法自动测试
 1. 测试code传NSNumber
 2. 测试phone传NSNumber
 3. 测试zone传NSNumber
 4. 测试zone传“+86”
 */

- (void)testCommitCode
{
    //    [self testSendCodeText];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCommitCode"];
    
    NSString *code = @"8692";
    
    [SMSSDK commitVerificationCode:code phoneNumber:@"18021058213" zone:@"86" result:^(NSError *error) {
        SMSLog(@"%@",error);
        XCTAssert(!error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testCommitCodeNSNumberZone
{
    //    [self testSendCodeText];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCommitCodeNSNumberZone"];
    
    id code = @3629;
    
    [SMSSDK commitVerificationCode:code phoneNumber:@"18021058213" zone:@86 result:^(NSError *error) {
        SMSLog(@"%@",error);
        XCTAssert(!error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testCommitCodeNSNumber
{
    //    [self testSendCodeText];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCommitCodeNSNumber"];
    
    NSString *code = @4636;
    
    [SMSSDK commitVerificationCode:code phoneNumber:@18021058213 zone:@86 result:^(NSError *error) {
        SMSLog(@"%@",error);
        XCTAssert(!error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}


- (void)testCommitCodeNoBlock
{
    //    [self testSendCodeText];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCommitCodeNoBlock"];
    
    NSString *code = @"4339";
    
    [SMSSDK commitVerificationCode:code phoneNumber:@"18021058213" zone:@"86" result:nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

//100次循环请求
- (void)testCommitCode100times
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCommitCode100times"];
    
    //    [self testSendCodeText];
    
    NSString *code = @"5350";
    
    __block NSInteger flag = 0;
    
    for (NSInteger i=0; i<100; i++)
    {
        [SMSSDK commitVerificationCode:code phoneNumber:@"18021058213" zone:@"86" result:^(NSError *error) {
            
            SMSLog(@"%@",error);
            
            flag++;
            
            if (flag==99)
            {
                [expectation fulfill];
            }
            
        }];
    }
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

#pragma mark - 通讯录好友开关

- (void)testSwitchOfContactsOnSend
{
    [SMSSDK enableAppContactFriends:YES];
    
    [self testSendCodeText];
}

- (void)testSwitchOfContactsOnCommit
{
    [SMSSDK enableAppContactFriends:YES];
    
    [self testCommitCode];
}

- (void)testSwitchOfContactsOffSend
{
    [SMSSDK enableAppContactFriends:NO];
    
    [self testSendCodeText];
}

- (void)testSwitchOfContactsOffCommit
{
    [SMSSDK enableAppContactFriends:NO];
    
    [self testCommitCode];
}

- (void)testSwitchOfContactsOffSummitUserinfo
{
    [SMSSDK enableAppContactFriends:NO];
    
    [self testSubmitUser];
}

- (void)testSwitchOfContactsOffGetFriends
{
    [SMSSDK enableAppContactFriends:NO];
    
    [self testGetAllContactFriends];
}

#pragma mark - 获取区号

- (void)testGetCountryZone
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetCountryZone"];
    
    [SMSSDK getCountryZone:^(NSError *error, NSArray *zonesArray) {
        
        XCTAssert(!error);
        SMSLog(@"%@",zonesArray);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        SMSLog(@"Over");
    }];
}

- (void)testGetCountryZoneNoResult
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetCountryZone"];
    
    [SMSSDK getCountryZone:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        SMSLog(@"Over");
    }];
}

- (void)testGetCountryZone100Times
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetCountryZone"];
    
    __block NSInteger flag = 0;
    
    for (NSInteger i=0; i<100; i++)
    {
        [SMSSDK getCountryZone:^(NSError *error, NSArray *zonesArray) {
            
            XCTAssert(!error);
            
            if (++flag==99)
            {
                SMSLog(@"%@",zonesArray);
                [expectation fulfill];
            }
        }];
    }
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        SMSLog(@"Over");
    }];
}

#pragma mark - 提交用户信息

/**
 1. user 传nil
 2. user 属性传number
 3. user 属性zone 传 "+86"
 4. user 不传属性 只alloc init
 5. 回调传nil
 */
- (void)testSubmitUser
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSubmitUser"];
    SMSSDKUserInfo *user = [[SMSSDKUserInfo alloc] init];
    user.phone = @"18021058213";
    user.zone = @"86";
    user.avatar = @"http://b.hiphotos.baidu.com/baike/w%3D268%3Bg%3D0/sign=92e00c9b8f5494ee8722081f15ce87c3/29381f30e924b899c83ff41c6d061d950a7bf697.jpg";
    [SMSSDK submitUserInfo:user result:^(NSError *error) {
        
        SMSLog(@"%@",error);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testSubmitUser100times
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSubmitUser100times"];
    SMSSDKUserInfo *user = [[SMSSDKUserInfo alloc] init];
    user.phone = @"13800138000";
    user.zone = @"86";
    user.avatar = @"http://b.hiphotos.baidu.com/baike/w%3D268%3Bg%3D0/sign=92e00c9b8f5494ee8722081f15ce87c3/29381f30e924b899c83ff41c6d061d950a7bf697.jpg";
    
    __block NSInteger flag=0;
    
    for (NSInteger i=0; i<100; i++)
    {
        [SMSSDK submitUserInfo:user result:^(NSError *error) {
            
            if (error)
            {
                SMSLog(@"%@",error);
            }
            flag++;
            if (flag==100)
            {
                [expectation fulfill];
                XCTAssert(!error);
            }
        }];
    }
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testSubmitUserWrongProperties
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSubmitUserWrongProperties"];
    SMSSDKUserInfo *user = [[SMSSDKUserInfo alloc] init];
    user.phone = @18021958213;
    user.zone  = @"+86";
    user.avatar = [NSMutableArray array];
    [SMSSDK submitUserInfo:user result:^(NSError *error) {
        
        if (error)
        {
            SMSLog(@"%@",error);
        }
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testSubmitUserNoProperty
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSubmitUserNoProperty"];
    SMSSDKUserInfo *user = [[SMSSDKUserInfo alloc] init];
    [SMSSDK submitUserInfo:user result:^(NSError *error) {
        
        if (error)
        {
            SMSLog(@"%@",error);
        }
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testSubmitUserNil
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSubmitUserNil"];
    
    [SMSSDK submitUserInfo:nil result:^(NSError *error) {
        
        if (error)
        {
            SMSLog(@"%@",error);
        }
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testSubmitUserNoResult
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSubmitUserNoResult"];
    
    SMSSDKUserInfo *user = [[SMSSDKUserInfo alloc] init];
    user.phone = @"18021058134";
    user.zone = @"86";
    
    [SMSSDK submitUserInfo:user result:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testGetAllContactFriends
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetAllContactFriends"];
    
    [SMSSDK getAllContactFriends:^(NSError *error, NSArray *friendsArray) {
        
        SMSLog(@"error:%@,friends:%@",error,friendsArray);
        
        XCTAssert(!error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testGetAllContactFriends100times
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetAllContactFriends100times"];
    
    int maxcount = 100;
    __block int count = 0;
    
    for (NSInteger i=0; i<maxcount; i++)
    {
        //        NSLog(@"======== test = %d", i);
        [SMSSDK getAllContactFriends:^(NSError *error, NSArray *friendsArray) {
            
            //            SMSLog(@"error:%@,friends:%@",error,friendsArray);
            
            //            XCTAssert(!error);
            
            count++;
            NSLog(@"------ count = %d", count);
            
            if (count==maxcount)
            {
                [expectation fulfill];
            }
            
        }];
    }
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testGetAllContactFriendsNoResult
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetAllContactFriendsNoResult"];
    
    [SMSSDK getAllContactFriends:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        SMSLog(@"Over");
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
