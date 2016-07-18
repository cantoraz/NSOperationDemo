//
//  ConcurrentOperationTest.m
//  NSOperationDemo
//
//  Created by Cantoraz Chou on 7/15/16.
//
//

#import "ConcurrentOperationTest.h"

#import "ConcurrentOperation.h"

@interface ConcurrentOperationTest ()
@property (nonatomic, strong) ConcurrentOperation* operation;
@end

@implementation ConcurrentOperationTest

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:@"Not availabe"
                                 userInfo:nil];
}

- (instancetype)initWithURL:(NSURL*)url
{
    if (self = [super init]) {
        _operation = [[ConcurrentOperation alloc] initWithImageURL:url];
        [_operation addObserver:self
                     forKeyPath:@"isFinished"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
        [_operation addObserver:self
                     forKeyPath:@"isExecuting"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [_operation removeObserver:self forKeyPath:@"isFinished"];
    [_operation removeObserver:self forKeyPath:@"isExecuting"];
}

- (void)launch
{
    [_operation start];
    
    NSLog(@"%@ sleep for 3 seconds...", self);
    [NSThread sleepForTimeInterval:3];
    NSLog(@"%@ continue launching...", self);
    
    NSLog(@"%@ concurrent = %d", _operation, _operation.concurrent);
    NSLog(@"%@ executing = %d", _operation, _operation.executing);
    NSLog(@"%@ finished = %d", _operation, _operation.finished);
}

#pragma mark -
#pragma mark <NSKeyValueObserving>

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString*,id>*)change
                       context:(void*)context
{
    if ([keyPath isEqualToString:@"isFinished"]) {
        
        NSLog(@"%@ finish has been changed to %@",
              _operation, change[NSKeyValueChangeNewKey]);
        
    } else if ([keyPath isEqualToString:@"isExecuting"]) {
        
        NSLog(@"%@ executing has been changed to %@",
              _operation, change[NSKeyValueChangeNewKey]);
        
    }
}

@end
