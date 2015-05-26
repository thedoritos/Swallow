//
//  SWLTwitterAPI.m
//  Pods
//
//  Created by t-matsumura on 5/23/15.
//
//

#import "SWLTwitterAPI.h"
#import <Social/Social.h>

@interface SWLTwitterAPI ()

@property (nonatomic) ACAccount *account;

@end

@implementation SWLTwitterAPI

- (instancetype)initWithAccount:(ACAccount *)account
{
    self = [super init];
    if (self) {
        self.account = account;
    }
    return self;
}

- (void)getStatusHomeTimeline:(JsonArrayHandler)success
                      failure:(ErrorHandler)failure
{
    SLRequest *request = [self createRequest:@"statuses/home_timeline" params:@{}];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        
        if (!(200 <= urlResponse.statusCode && urlResponse.statusCode < 300)) {
            failure([NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
                NSLocalizedDescriptionKey : @"Bad response status code."
            }]);
            return;
        }
        
        NSError *parseError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&parseError];
        if (parseError) {
            failure([NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
                NSLocalizedDescriptionKey : @"Bad response body."
            }]);
            return;
        }
        
        success(urlResponse.allHeaderFields, jsonObject);
    }];
}

- (void)getStatusMentionsTimeline:(JsonArrayHandler)success
                          failure:(ErrorHandler)failure
{
    SLRequest *request = [self createRequest:@"statuses/mentions_timeline" params:@{}];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        
        if (!(200 <= urlResponse.statusCode && urlResponse.statusCode < 300)) {
            failure([NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
                NSLocalizedDescriptionKey : @"Bad response status code."
            }]);
            return;
        }
        
        NSError *parseError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&parseError];
        if (parseError) {
            failure([NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
                NSLocalizedDescriptionKey : @"Bad response body."
            }]);
            return;
        }
        
        success(urlResponse.allHeaderFields, jsonObject);
    }];
}

- (void)getStatusRetweetsOfMe:(JsonArrayHandler)success
                      failure:(ErrorHandler)failure
{
    SLRequest *request = [self createRequest:@"statuses/retweets_of_me" params:@{}];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        
        if (!(200 <= urlResponse.statusCode && urlResponse.statusCode < 300)) {
            failure([NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
                NSLocalizedDescriptionKey : @"Bad response status code."
            }]);
            return;
        }
        
        NSError *parseError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&parseError];
        if (parseError) {
            failure([NSError errorWithDomain:@"Swallow" code:0 userInfo:@{
                NSLocalizedDescriptionKey : @"Bad response body."
            }]);
            return;
        }
        
        success(urlResponse.allHeaderFields, jsonObject);
    }];
}

#pragma mark - Private

- (SLRequest *)createRequest:(NSString *)endpoint params:(NSDictionary *)params
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/%@.json", endpoint];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:urlString]
                                               parameters:params];
    request.account = self.account;
    
    return request;
}

@end
