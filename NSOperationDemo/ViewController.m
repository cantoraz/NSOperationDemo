//
//  ViewController.m
//  NSOperationDemo
//
//  Created by Cantoraz Chou on 7/14/16.
//
//

#import "ViewController.h"

#import "NonConcurrentOperation.h"
#import "ConcurrentOperation.h"
#import "ConcurrentOperationTest.h"
#import "ConcurrentThreadedOperation.h"
#import "ConcurrentThreadedOperationTest.h"

static NSString* const kImageURL = @"https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png";
static NSString* const kImage2URL = @"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSLog(@"--------------------Start-Non-Concurrent-Operation->>>--------------------");
//    [self __startNonConcurrentOperation];
//    NSLog(@"--------------------<<<-Start-Non-Concurrent-Operation--------------------");
    
//    NSLog(@"--------------------Start-Concurrent-Operation->>>--------------------");
//    [self __startConcurrentOperation];
//    NSLog(@"--------------------<<<-Start-Concurrent-Operation--------------------");

    /*
    NSLog(@"----------Main-Thread-Start-Non-Concurrent-Operation->>>----------");
    // Just same as [self __startNonConcurrentOperation]
    NSLog(@"----------<<<-Main-Thread-Start-Non-Concurrent-Operation----------");
     */

    /*
    NSLog(@"----------Main-Thread-Start-Concurrent-Operation->>>----------");
    // Just same as [self __startConcurrentOperation]
    NSLog(@"----------<<<-Main-Thread-Start-Concurrent-Operation----------");
     */
    
//    NSLog(@"----------Sub-Thread-Start-Non-Concurrent-Operation->>>----------");
//    [self __subThreadStartNonConcurrentOperation];
//    NSLog(@"----------<<<-Sub-Thread-Start-Non-Concurrent-Operation----------");
    
//    NSLog(@"----------Sub-Thread-Start-Concurrent-Operation->>>----------");
//    [self __subThreadStartConcurrentOperation];
//    NSLog(@"----------<<<-Sub-Thread-Start-Concurrent-Operation----------");
    
//    NSLog(@"----------Main-Queue-Start-Non-Concurrent-Operation->>>----------");
//    [self __mainQueueStartNonConcurrentOperation];
//    NSLog(@"----------<<<-Main-Queue-Start-Non-Concurrent-Operation----------");
    
//    NSLog(@")----------Non-Main-Queue-Start-Non-Concurrent-Operation->>>----------");
//    [self __nonMainQueueStartNonConcurrentOperation];
//    NSLog(@")----------<<<-Non-Main-Queue-Start-Non-Concurrent-Operation----------");
    
//    NSLog(@"----------Main-Queue-Start-Concurrent-Operation->>>----------");
//    [self __mainQueueStartConcurrentOperation];
//    NSLog(@"----------<<<-Main-Queue-Start-Concurrent-Operation----------");
    
//    NSLog(@"----------Non-Main-Queue-Start-Concurrent-Operation->>>----------");
//    [self __nonMainQueueStartConcurrentOperation];
//    NSLog(@"----------<<<-Non-Main-Queue-Start-Concurrent-Operation----------");
}

- (void)__startNonConcurrentOperation
{
    NSURL* url = [NSURL URLWithString:kImageURL];

    NonConcurrentOperation* op1 = [[NonConcurrentOperation alloc] initWithImageURL:url];
    NonConcurrentOperation* op2 = [[NonConcurrentOperation alloc] initWithImageURL:url];
    
    [op1 start];
    [op1 cancel];
    [op2 cancel];
    [op2 start];
}

- (void)__startConcurrentOperation
{
    NSURL* url = [NSURL URLWithString:kImageURL];
    
    ConcurrentOperationTest* opTest1 = [[ConcurrentOperationTest alloc] initWithURL:url];
    ConcurrentOperationTest* opTest2 = [[ConcurrentOperationTest alloc] initWithURL:url];
    
    ConcurrentThreadedOperationTest* opTest3 = [[ConcurrentThreadedOperationTest alloc] initWithURL:url];
    ConcurrentThreadedOperationTest* opTest4 = [[ConcurrentThreadedOperationTest alloc] initWithURL:url];
    
    [opTest1 launch];
    [opTest2 launch];
    [opTest3 launch];
    [opTest4 launch];
}

- (void)__subThreadStartNonConcurrentOperation
{
    [NSThread detachNewThreadSelector:@selector(__startNonConcurrentOperation)
                             toTarget:self
                           withObject:NULL];
}

- (void)__subThreadStartConcurrentOperation
{
    [NSThread detachNewThreadSelector:@selector(__startConcurrentOperation)
                             toTarget:self
                           withObject:NULL];
}

- (void)__mainQueueStartNonConcurrentOperation
{
    NSURL* url = [NSURL URLWithString:kImageURL];
    
    NonConcurrentOperation* op1 = [[NonConcurrentOperation alloc] initWithImageURL:url];
    NonConcurrentOperation* op2 = [[NonConcurrentOperation alloc] initWithImageURL:url];
    
    NSOperationQueue* mainQ = [NSOperationQueue mainQueue];
    [mainQ addOperation:op1];
    [mainQ addOperation:op2];
//    [op2 cancel];
}

- (void)__nonMainQueueStartNonConcurrentOperation
{
    NSURL* url = [NSURL URLWithString:kImageURL];
    
    NonConcurrentOperation* op1 = [[NonConcurrentOperation alloc] initWithImageURL:url];
    NonConcurrentOperation* op2 = [[NonConcurrentOperation alloc] initWithImageURL:url];
    
    NSOperationQueue* q = [[NSOperationQueue alloc] init];
    [q addOperation:op1];
    [q addOperation:op2];
}

- (void)__mainQueueStartConcurrentOperation
{
    NSURL* url = [NSURL URLWithString:kImageURL];
    
    ConcurrentOperation* op1 = [[ConcurrentOperation alloc] initWithImageURL:url];
    ConcurrentOperation* op2 = [[ConcurrentOperation alloc] initWithImageURL:url];
    
    NSOperationQueue* mainQ = [NSOperationQueue mainQueue];
    [mainQ addOperation:op1];
    [mainQ addOperation:op2];
}

- (void)__nonMainQueueStartConcurrentOperation
{
    NSURL* url = [NSURL URLWithString:kImageURL];
    
    ConcurrentOperation* op1 = [[ConcurrentOperation alloc] initWithImageURL:url];
    ConcurrentOperation* op2 = [[ConcurrentOperation alloc] initWithImageURL:url];
    
    NSOperationQueue* q = [[NSOperationQueue alloc] init];
    [q addOperation:op1];
    [q addOperation:op2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
