//
//  ConcurrentThreadedOperationTest.h
//  NSOperationDemo
//
//  Created by Cantoraz Chou on 7/15/16.
//
//

#import <Foundation/Foundation.h>

@interface ConcurrentThreadedOperationTest : NSObject
- (instancetype _Nullable)initWithURL:(NSURL* _Nonnull)url;
- (void)launch;
@end
