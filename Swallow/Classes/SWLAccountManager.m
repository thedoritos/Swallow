//
//  SWLAccountManager.m
//  Pods
//
//  Created by t-matsumura on 5/23/15.
//
//

#import "SWLAccountManager.h"

static NSString * const kSWLCurrentUserNameKey = @"SWLCurrentUserNameKey";

@interface SWLAccountManager ()

@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccountType *accountType;

@end

@implementation SWLAccountManager

- (instancetype)initWithAccountStore:(ACAccountStore *)accountStore
{
    self = [super init];
    if (self) {
        self.accountStore = accountStore;
        self.accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    return self;
}

- (void)requestAccounts:(AccountsHandler)success
                failure:(ErrorHandler)failure
{
    [self requestStore:^(ACAccountStore *accountStore) {
        NSArray *accounts = [accountStore accountsWithAccountType:self.accountType];
        success(accounts);
    } failure:failure];
}

- (void)requestCurrentAccount:(AccountHandler)success
                      failure:(ErrorHandler)failure
{
    NSError *notFound = [NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
        NSLocalizedDescriptionKey : @"No accounts are currently logged in."
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUserName = [defaults objectForKey:kSWLCurrentUserNameKey];
    if (currentUserName == nil) {
        failure(notFound);
        return;
    }
    
    [self findAccount:currentUserName success:success failure:failure];
}

- (void)requestLoginWithAccount:(ACAccount *)account
                        success:(AccountHandler)success
                        failure:(ErrorHandler)failure
{
    [self findAccount:account.username success:^(ACAccount *found) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:found.username forKey:kSWLCurrentUserNameKey];
        success(found);
    } failure:failure];
}

- (void)requestLogoutWithAccount:(ACAccount *)account
                         success:(AccountHandler)success
                         failure:(ErrorHandler)failure
{
    NSError *notLoggedIn = [NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
        NSLocalizedDescriptionKey : @"This account isn't currently logged in."
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUserName = [defaults objectForKey:kSWLCurrentUserNameKey];
    if (currentUserName == nil || ![currentUserName isEqual:account.username]) {
        failure(notLoggedIn);
        return;
    }
    
    [defaults removeObjectForKey:kSWLCurrentUserNameKey];
    success(account);
}

#pragma mark - Private

- (void)requestStore:(AccountStoreHandler)success
             failure:(ErrorHandler)failure
{
    [self.accountStore requestAccessToAccountsWithType:self.accountType options:nil
                                            completion:^(BOOL granted, NSError *error) {
                                                if (error) {
                                                    failure(error);
                                                    return;
                                                }
                                                success(self.accountStore);
                                            }];
}

- (void)findAccount:(NSString *)accountName
            success:(AccountHandler)success
            failure:(ErrorHandler)failure
{
    [self requestAccounts:^(NSArray *accounts) {
        NSError *notFound = [NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
            NSLocalizedDescriptionKey : @"No accounts are currently logged in."
        }];
        
        for (ACAccount *account in accounts) {
            if ([account.username isEqualToString:accountName]) {
                success(account);
                return;
            }
        }
        
        failure(notFound);
    } failure:failure];
}

@end
