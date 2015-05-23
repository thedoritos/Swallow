//
//  SWLTwitterTests.m
//  Swallow
//
//  Created by t-matsumura on 5/23/15.
//  Copyright (c) 2015 thedoritos. All rights reserved.
//

#import <SWLTwitterAPI.h>
#import <SWLAccountManager.h>

SpecBegin(SWLTwitterAPI)

describe(@"SWLTwitterAPI", ^{
    __block SWLTwitterAPI *sut = nil;
    __block NSArray *accounts = nil;
    __block BOOL skip = NO;
    
    beforeAll(^{
        setAsyncSpecTimeout(5.0);
        
        waitUntil(^(DoneCallback done){
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            SWLAccountManager *accountManager = [[SWLAccountManager alloc] initWithAccountStore:accountStore];
            [accountManager requestAccounts:^(NSArray *received) {
                accounts = received;
                done();
            } failure:^(NSError *error) {
                accounts = @[];
                done();
            }];
        });
        
        sut = [[SWLTwitterAPI alloc] initWithAccount:accounts.firstObject];
        
        skip = (accounts.count == 0);
        if (skip) {
            NSLog(@"Twitter accounts are not registered on this device. Specs will be skipped.");
        }
    });
    
    describe(@"#getStatusesHomeTimeline", ^{
        it(@"receive response", ^{
            if (skip) return;
            
            waitUntil(^(DoneCallback done) {
                [sut getStatusHomeTimeline:^(NSDictionary *header, NSArray *statuses) {
                    expect(header).notTo.beNil;
                    expect(statuses).notTo.beNil;
                    done();
                } failure:^(NSError *error) {
                    done();
                }];
            });
        });
    });
});

SpecEnd
