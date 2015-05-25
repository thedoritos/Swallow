//
//  SWLTwitterAPI.h
//  Pods
//
//  Created by t-matsumura on 5/23/15.
//
//

#import <Accounts/Accounts.h>

typedef void (^JsonHandler)(NSDictionary *header, NSDictionary *json);
typedef void (^JsonArrayHandler)(NSDictionary *header, NSArray *jsonArray);
typedef void (^ErrorHandler)(NSError *error);

@interface SWLTwitterAPI : NSObject

- (instancetype)initWithAccount:(ACAccount *)account;

- (void)getStatusHomeTimeline:(JsonArrayHandler)success
                      failure:(ErrorHandler)failure;

- (void)getStatusMentionsTimeline:(JsonArrayHandler)success
                          failure:(ErrorHandler)failure;

@end
