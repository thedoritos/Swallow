//
//  SWLAccountManagerTests.m
//  Swallow
//
//  Created by thedoritos on 5/23/15.
//  Copyright (c) 2015 thedoritos. All rights reserved.
//

#import <SWLAccountManager.h>
#import <Accounts/Accounts.h>

SpecBegin(SWLAccountManager)

describe(@"SWLAccountManager", ^{
    __block SWLAccountManager *sut = nil;
    
    __block ACAccount *aimee = nil;
    __block ACAccount *brian = nil;
    
    beforeAll(^{
        aimee = [[ACAccount alloc] init];
        aimee.username = @"@aimee";
        
        brian = [[ACAccount alloc] init];
        brian.username = @"@brian";
        
        __block NSArray *accounts = @[aimee, brian];
        
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        id accountStoreMock = OCMPartialMock(accountStore);
        OCMStub([accountStoreMock accountsWithAccountType:[OCMArg any]]).andReturn(accounts);
        
        sut = [[SWLAccountManager alloc] initWithAccountStore:accountStoreMock];
    });
    
    beforeEach(^{
        waitUntil(^(DoneCallback done){
            [sut requestLoginWithAccount:aimee success:^(ACAccount *account) {
                done();
            } failure:^(NSError *error) {
                done();
            }];
        });
    });
    
    describe(@"#requestAccounts", ^{
        it(@"receive accounts saved on the device", ^{
            waitUntil(^(DoneCallback done) {
                [sut requestAccounts:^(NSArray *accounts) {
                    expect(accounts).to.haveCount(2);
                    done();
                } failure:^(NSError *error) {
                    failure(error.localizedDescription);
                    done();
                }];
            });
        });
    });
    
    describe(@"#requestCurrentAccount", ^{
        it(@"receive current login user account", ^{
            waitUntil(^(DoneCallback done) {
                [sut requestCurrentAccount:^(ACAccount *account) {
                    expect(account).to.equal(aimee);
                    done();
                } failure:^(NSError *error) {
                    failure(error.localizedDescription);
                    done();
                }];
            });
        });
    });
    
    describe(@"#requestLoginWithAccount", ^{
        it(@"receive current login user account", ^{
            waitUntil(^(DoneCallback done) {
                [sut requestLoginWithAccount:brian success:^(ACAccount *account) {
                    expect(account).to.equal(brian);
                    done();
                } failure:^(NSError *error) {
                    failure(error.localizedDescription);
                    done();
                }];
            });
        });
    });
    
    describe(@"#requestLogoutWithAccount", ^{
        it(@"receive logout user account", ^{
            waitUntil(^(DoneCallback done) {
                [sut requestLogoutWithAccount:aimee success:^(ACAccount *account) {
                    expect(account).to.equal(aimee);
                    done();
                } failure:^(NSError *error) {
                    failure(error.localizedDescription);
                    done();
                }];
            });
        });
    });
});

SpecEnd
