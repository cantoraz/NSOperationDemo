//
//  ConcurrentOperation.m
//  NSOperationDemo
//
//  Created by Cantoraz Chou on 7/14/16.
//
//

#import "ConcurrentOperation.h"

@interface ConcurrentOperation ()
{
    BOOL _isFinished;
    BOOL _isExecuting;
}
@property (nonatomic, strong, nonnull) NSURL* url;
@end

@implementation ConcurrentOperation

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

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (void)start
{
    NSLog(@"Start in %@", [NSThread currentThread]);
    
    if ([self isCancelled]) {
        
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        return;
        
    } else {
        
        [self willChangeValueForKey:@"isExecuting"];
        [self main];
        _isExecuting = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
    }
}

- (void)main
{
    @autoreleasepool {
        NSLog(@"Run in %@", [NSThread currentThread]);
        
        // Step 1: Prepare request
        if ([self isCancelled]) {
            [self __completeOperation__];
            return;
        }
        
        NSURLRequest* req = [NSURLRequest requestWithURL:_url];
        
        // Step 2: Send request
        if ([self isCancelled]) {
            req = nil;
            [self __completeOperation__];
            return;
        }
        
        NSURLConnection* conn;
        if (req) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
            NSLog(@"connection %@", conn);
#pragma clang diagnostic pop
        }
        
        req = nil;
        
        // Step 3: Finish operation
        if ([self isCancelled]) {
            [conn cancel];
            conn = nil;
            [self __completeOperation__];
            return;
        }
        
        if (!conn) {
            [self __completeOperation__];
        }
        
        NSLog(@"%@ operation done.", [NSThread currentThread]);
    }
}

- (void)__completeOperation__
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = NO;
    _isFinished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end

#pragma mark -
#pragma mark <NSURLConnectionDelegate>

@interface ConcurrentOperation (NSURLConnectionDelegate) <NSURLConnectionDelegate>
@end

@implementation ConcurrentOperation (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [self __completeOperation__];
    
    if ([self isCancelled]) {
        return;
    }
    
    NSLog(@"Connection %p failed: %@", connection, error);
}

@end

#pragma mark -
#pragma mark <NSURLConnectionDataDelegate>

@interface ConcurrentOperation (NSURLConnectionDataDelegate) <NSURLConnectionDataDelegate>
@end

@implementation ConcurrentOperation (NSURLConnectionDataDelegate)

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    if ([self isCancelled]) {
        return;
    }
    
    NSLog(@"Connection %p received response %p", connection, response);
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    if ([self isCancelled]) {
        return;
    }
    
    NSLog(@"Connection %p received data %p", connection, data);
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [self __completeOperation__];
    
    if ([self isCancelled]) {
        return;
    }
    
    NSLog(@"Connection %p finished", connection);
}

@end
