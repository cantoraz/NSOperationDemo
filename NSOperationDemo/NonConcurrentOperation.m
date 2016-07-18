//
//  NonConcurrentOperation.m
//  NSOperationDemo
//
//  Created by Cantoraz Chou on 7/14/16.
//
//

#import "NonConcurrentOperation.h"

#import <UIKit/UIKit.h>

@interface NonConcurrentOperation ()
@property (nonatomic, strong, nonnull) NSURL* url;
@end

@implementation NonConcurrentOperation

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:@"Not avaialbe"
                                 userInfo:nil];
}

- (instancetype)initWithImageURL:(NSURL*)url
{
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)main
{
    @autoreleasepool {
        
        // Step 1: Prepare request
        if (self.cancelled) {
            return;
        }
        
        NSLog(@"%@ sleep for 3 seconds...", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:3];
        NSLog(@"%@ Continue doing...", [NSThread currentThread]);
        
        NSURLRequest* req = [NSURLRequest requestWithURL:_url];
        
        // Step 2: Send request
        if (self.cancelled) {
            req = nil;
            return;
        }
        
        NSURLConnection* conn;
        if (req) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
#pragma clang diagnositc pop
        }
        
        req = nil;
        
        // Step 3: Finish operation
        if (self.cancelled) {
            [conn cancel];
            conn = nil;
            return;
        }
        
        NSLog(@"%@ operation done.", [NSThread currentThread]);
    }
}

@end

#pragma mark -

@interface NonConcurrentOperation (NSURLConnectionDelegate) <NSURLConnectionDelegate>
@end

@implementation NonConcurrentOperation (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    if (self.cancelled) {
        return;
    }
    
    NSLog(@"Connection %p failed: %@", connection, error);
}

@end

#pragma mark -

@interface NonConcurrentOperation (NSURLConnectionDataDelegate) <NSURLConnectionDataDelegate>
@end

@implementation NonConcurrentOperation (NSURLConnectionDataDelegate)

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    if (self.cancelled) {
        return;
    }
    
    NSLog(@"Connection %p received response %p", connection, response);
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    if (self.cancelled) {
        return;
    }
    
    NSLog(@"Connection %p received data %p", connection, data);
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    if (self.cancelled) {
        return;
    }
    
    NSLog(@"Connection %p finished", connection);
}

@end
