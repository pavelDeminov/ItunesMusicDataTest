//
//  APIClient.h
//  Test1
//
//  Created by Pavel Deminov on 17/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIClient : NSObject


+ (instancetype)sharedInstance;

- (void)getMusicData:(NSString *)term
             country:(NSString*)country
               limit:(NSNumber*)limit
              offset:(NSNumber*)offset
   completionHandler:(void (^)(BOOL succes, NSArray *songs, NSError *error,NSInteger total))completionHandler;

@end
