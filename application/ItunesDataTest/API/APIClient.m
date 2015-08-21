//
//  APIClient.m
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "APIClient.h"
#import "AFNetworking.h"

static NSString *const kMethodUserTreasures = @"search";

@interface APIClient () {
     NSString *_APIURL;
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end;
@implementation APIClient



#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static APIClient *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[APIClient alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        
        _APIURL = @"https://itunes.apple.com/";
    }
    return self;
}


- (void)getMusicData:(NSString *)term
             country:(NSString*)country
               limit:(NSNumber*)limit
              offset:(NSNumber*)offset
   completionHandler:(void (^)(BOOL succes, NSArray *songs, NSError *error,NSInteger total))completionHandler {
    
    NSDictionary *params = @{@"term" : term,@"country" : country,@"limit" : limit,@"offset" : offset,};
    
    [self.manager GET:[NSString stringWithFormat:kMethodUserTreasures]
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"%@", responseObject);
         
//         if (![[responseObject valueForKey:kSuccess] boolValue])
//         {
//             completionHandler(NO, nil, [self errorForResponseObject:responseObject]);
//             
//             return;
//         }
         
         completionHandler(YES, responseObject[@"results"], nil,[responseObject[@"resultCount"] integerValue]);
     }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", operation.responseString);
         
         completionHandler(NO, nil, error,0);
     }];

    
    
}

- (AFHTTPRequestOperationManager *)manager
{
    if (_manager == nil) {
        if (!_APIURL) {
            @throw [NSException exceptionWithName:NSObjectNotAvailableException reason:@"API URL is not set yet, call updateMainConfigWithCompletition: before using APICLient" userInfo:nil];
        }
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:_APIURL]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        _manager.securityPolicy.validatesDomainName = NO;
        
        [_manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    }

    
    return _manager;
}



@end
