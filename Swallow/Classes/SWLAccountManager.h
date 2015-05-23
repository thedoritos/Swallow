//
//  SWLAccountManager.h
//  Pods
//
//  Created by t-matsumura on 5/23/15.
//
//

#import <Accounts/Accounts.h>

typedef void (^AccountStoreHandler)(ACAccountStore *accountStore);
typedef void (^AccountsHandler)(NSArray *accounts);
typedef void (^AccountHandler)(ACAccount *account);
typedef void (^ErrorHandler)(NSError *error);

@interface SWLAccountManager : NSObject

- (instancetype)initWithAccountStore:(ACAccountStore *)accountStore;

- (void)requestAccounts:(AccountsHandler)success
                failure:(ErrorHandler)failure;

- (void)requestCurrentAccount:(AccountHandler)success
                      failure:(ErrorHandler)failure;

- (void)requestLoginWithAccount:(ACAccount *)account
                        success:(AccountHandler)success
                      failure:(ErrorHandler)failure;

- (void)requestLogoutWithAccount:(ACAccount *)account
                         success:(AccountHandler)success
                         failure:(ErrorHandler)failure;

@end
